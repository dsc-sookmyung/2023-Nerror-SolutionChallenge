package com.gsc.nerrorserver.api.mail.service;


import com.gsc.nerrorserver.api.mail.dto.MailReceiveDto;
import com.gsc.nerrorserver.api.mail.entity.MailAccount;
import com.gsc.nerrorserver.api.mail.entity.MailData;
import com.gsc.nerrorserver.api.mail.repository.MailAccountRepository;
import com.gsc.nerrorserver.api.mail.repository.MailDataRepository;
import com.gsc.nerrorserver.api.member.dto.LoginResponseDto;
import com.gsc.nerrorserver.api.member.entity.BadgeType;
import com.gsc.nerrorserver.api.member.entity.Member;
import com.gsc.nerrorserver.api.member.repository.MemberRepository;
import com.gsc.nerrorserver.global.auth.MailAuthenticator;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.search.ComparisonTerm;
import javax.mail.search.ReceivedDateTerm;
import javax.mail.search.SearchTerm;
import java.io.*;
import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class MailService {

    private final JavaMailSender emailSender;
    public static final String ePw = createKey();
    public static final String MAIL_IMG_LOGO_ROUTE = "https://ifh.cc/g/yl5Kbp.png";

    private final MailAccountRepository mailAccountRepository;
    private final MailDataRepository mailDataRepository;
    private final MemberRepository memberRepository;

    private MimeMessage createMessage(String to) throws Exception {
        log.info("수신자 : " + to);
        log.info("인증번호 : " + ePw);
        MimeMessage message = emailSender.createMimeMessage();


        message.addRecipients(MimeMessage.RecipientType.TO, to); //수신자 지정
        message.setSubject("[Marbon] 이메일 인증을 완료해주세요."); //발신 메일제목

        String msgg = "";
        msgg += "<div style='margin:20px;'>";
//        msgg+= "<h1> 안녕하세요 . </h1>";
//        msgg+= "<br>";
//        msgg+= "<p>Marbon 을 이용해주셔서 감사합니다.<p>";
        msgg += "<br>";
        msgg += "<img src=" + MAIL_IMG_LOGO_ROUTE + " />";
        msgg += "<h2>회원가입을 위한 이메일 인증을 진행합니다.<br>아래 8자리 인증코드를 입력하여 이메일 인증을 완료해주세요.</h2>";
        msgg += "<div style='font-size:170%'>";
        msgg += "인증번호 : <strong>" + ePw + "</strong><br/> ";
        msgg += "</div>";
        message.setText(msgg, "utf-8", "html"); //내용 지정
        message.setFrom(new InternetAddress("marbonkr@gmail.com", "Marbon")); //보내는 사람 지정

        return message;
    }

    // 인증번호 생성기
    public static String createKey() {
        StringBuilder key = new StringBuilder();
        Random rnd = new Random();

        for (int i = 0; i < 8; i++) { // 인증코드 8자리
            int index = rnd.nextInt(3); // 0~2 까지 랜덤

            switch (index) {
                case 0:
                    key.append((char) ((int) (rnd.nextInt(26)) + 97));
                    //  a~z  (ex. 1+97=98 => (char)98 = 'b')
                    break;
                case 1:
                    key.append((char) ((int) (rnd.nextInt(26)) + 65));
                    //  A~Z
                    break;
                case 2:
                    key.append((rnd.nextInt(10)));
                    // 0~9
                    break;
            }
        }
        return key.toString();
    }

    public String sendSimpleMessage(String to) throws Exception {

        MimeMessage message = createMessage(to);
        log.info(String.valueOf(message));

        try { //예외처리
            emailSender.send(message);
            log.info("이메일 전송에 성공했음다");
        } catch (MailException es) {
            es.printStackTrace();
            throw new IllegalArgumentException();
        }
        return ePw; // 반환값
    }

    @Transactional
    public Member addMailbox(MailReceiveDto dto) throws Exception {

        MailAccount mailAccount = MailAccount.builder()
                .member(memberRepository.findMemberById(dto.getId()))
                .username(dto.getUsername())
                .password(dto.getPassword())
                .host(dto.getHost())
                .port(dto.getPort())
                .build();

        // 계정 추가
        mailAccountRepository.saveAndFlush(mailAccount);
        log.info("[메일박스 추가] 계정 {}가 추가되었습니다.", mailAccount.getUsername());

        return memberRepository.findMemberById(dto.getId());
    }

    @Transactional
    public int updateMailCount(MailAccount mailAccount) throws Exception {
        Properties props = System.getProperties();
        props.setProperty("mail.store.protocol", "imaps");

        Session session = Session.getDefaultInstance(props, new MailAuthenticator(mailAccount.getUsername(), mailAccount.getPassword()));
        Store store = session.getStore("imaps");
        store.connect(mailAccount.getHost(), mailAccount.getUsername(), mailAccount.getPassword());

        Folder inbox = store.getFolder("INBOX");
        inbox.open(Folder.READ_ONLY);
        int count = inbox.getMessageCount(); // 받은메일함 메일갯수
        inbox.close(false);
        store.close();

        mailAccount.setMailCount(count);

        log.info("[updateMailCount] {} 계정의 메일 개수를 업데이트했습니다. count : {}", mailAccount.getUsername(), count);
        return count;
    }

    @Transactional
    public void updateTotalCount(String memberId) throws Exception {
        Member member = memberRepository.findMemberById(memberId);
        Collection<MailAccount> accountList = member.getMailAccount();
        int totalCount = 0;

        for (MailAccount account : accountList) {
            totalCount += updateMailCount(account); // updateMailCount 에서도 account setting 진행
        }
        member.setTotalCount(totalCount);
        memberRepository.saveAndFlush(member);

        log.info("[updateTotalCount 메일 총 개수 업데이트] {} 계정의 현재 총 메일수는 {}개 입니다.", member.getId(), member.getTotalCount());
    }

    public MailData handleMailData(MailAccount account, Message msg) throws Exception {
        String sender = msg.getFrom()[0].toString();
        String subject = msg.getSubject();
        String contentType = msg.getContentType();
        Date receivedDate = msg.getReceivedDate();
        long attachmentSize = 0L;
        String messageContent = "";
        Collection<File> attachments = new ArrayList<>();
        log.info("제목 : " + subject);

        if (contentType.contains("multipart")) {
            // 멀티파트 처리
            Multipart multipart = (Multipart) msg.getContent();
            for (int idx = 0; idx < multipart.getCount(); idx++) {
                MimeBodyPart part = (MimeBodyPart) multipart.getBodyPart(idx);
                // 첨부파일이 있는 경우
                if (Part.ATTACHMENT.equalsIgnoreCase(part.getDisposition())) {
                    attachmentSize += part.getSize();
                    String fileName = part.getFileName();
                    log.info("파일 제목 : " + fileName); // 파일 정보 출력
                    // 파일 inputStream 으로 저장
                    attachments.add(new File(fileName));
                } else { // 없으면 메일 내용만 저장
                    messageContent = part.getContent().toString();
                }
            }
        } else {
            Object content = msg.getContent();
            if (content != null) {
                messageContent = content.toString();
            }
        }
        String removeHtmlTag = messageContent.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
        return MailData.builder()
                .account(account)
                .subject(subject)
                .sender(sender)
                .contents(removeHtmlTag)
                .receivedDate(receivedDate)
                .attachmentSize(attachmentSize)
                .build();
    }


    // dto로 메일 전체 불러온 후 DB 저장
    public void fetchAndSaveAllMails(MailAccount mailAccount) throws Exception {

        String protocol = "imaps"; //imaps

        // TODO : Collection 으로 받아와서 일괄저장할건지, 불러올때마다 DB 호출할건지?
        // TODO : 메일 중복저장 되지 않게

        Properties props = System.getProperties();
        props.setProperty("mail.store.protocol", protocol);

        Session session = Session.getDefaultInstance(props, new MailAuthenticator(mailAccount.getUsername(), mailAccount.getPassword()));
        Store store = session.getStore(protocol);
        store.connect(mailAccount.getHost(), mailAccount.getUsername(), mailAccount.getPassword());

        Folder inbox = store.getFolder("INBOX");
        inbox.open(Folder.READ_ONLY);

        log.info("[시간측정] 메일 읽어오기 시작");
        // 받은 편지함에 있는 메일 모두 읽어오기
        Message[] arrayMessages = inbox.getMessages();
        log.info("[시간측정] 메일 읽어오기 종료");

        Collection<MailData> mailDataList = new ArrayList<>();
        for (Message msg : arrayMessages) {
            MailData mailData = handleMailData(mailAccount, msg);
            if (mailDataRepository.findByMailAccountAndReceivedDate(mailAccount, msg.getReceivedDate()) == null) {
                log.info("[새로운 메일 도착] 새로운 메일이 도착했어요!");
                mailDataList.add(mailData);
            }
        }

        // 메일박스와 연결 끊기
        inbox.close(false);
        store.close();

        log.info("[읽어온 메일] : {}", mailDataList);
        mailDataRepository.saveAll(mailDataList);
        log.info("[메세지 읽어오기] DB 저장 완료");
    }

    @Transactional
    // 새로고침시 새로운 메일 읽어오기
    public void readRecentMails(MailAccount mailAccount) throws Exception {

        Properties props = System.getProperties();
        props.setProperty("mail.store.protocol", "imaps");

        Session session = Session.getDefaultInstance(props, new MailAuthenticator(mailAccount.getUsername(), mailAccount.getPassword()));
        Store store = session.getStore("imaps");
        store.connect(mailAccount.getHost(), mailAccount.getUsername(), mailAccount.getPassword());

        Folder inbox = store.getFolder("INBOX"); // inbox = 받은편지함
        inbox.open(Folder.READ_ONLY);
        // TODO : READ_ONLY 로 열어도 읽음 표시 남는지 확인 - 읽고 나서 읽은 메일로 표시되는 문제 테스트~

        Collection<MailData> mailList = new ArrayList<>();

        // 안 읽은 메일 필터링해서 불러오기
        Date lastReadDate = mailDataRepository.findTopByMailAccountOrderByReceivedDateDesc(mailAccount).getReceivedDate();
        SearchTerm newerThan = new ReceivedDateTerm(ComparisonTerm.GT, lastReadDate);
        Message[] recentMessages = inbox.search(newerThan);

        List<MailData> mailDataList = new ArrayList<>();
        // 읽어서 데이터 저장
        for (Message msg : recentMessages) {
            MailData mailData = handleMailData(mailAccount, msg);
            if (mailDataRepository.existsMailDataByMailAccountAndReceivedDate(mailAccount, msg.getReceivedDate())) {
                log.info("[새로고침] 마지막 읽은 이후로 새로운 메일이 도착했어요!");
                mailDataList.add(mailData);
            }
        }

        inbox.close(false);
        store.close();

        mailDataRepository.saveAll(mailDataList);
        log.info("[새로운 메일 저장] {} 이후 도착한 메일들을 저장했습니다.", lastReadDate);
    }

    @Transactional
    public void grantBadge(String id) {
        Member member = memberRepository.findMemberById(id);
        Set<BadgeType> badgeList = member.getBadge();
        int totalCount = member.getTotalCount();
        int deleteCount = member.getDeletedCount();
        long deletedRatio = ((long)deleteCount / (long)totalCount) * 100;
        int currentAttendance = member.getAttendance().size();

        // @Refactor 뱃지 리스트 Set 으로 변경 -> 자동 중복제거
        if (deleteCount >= 1) badgeList.add(BadgeType.STARTERS);
        if (deleteCount >= 65) badgeList.add(BadgeType.ENVIRONMENTAL_TUTELARY);
        if (deleteCount >= 422) badgeList.add(BadgeType.EARTH_TUTELARY);
        if (totalCount >= 10000) badgeList.add(BadgeType.MAIL_RICH);
        if (deletedRatio >= 42.195) badgeList.add(BadgeType.MARBON_MARATHONER);
        if (currentAttendance >= 7) badgeList.add(BadgeType.ENVIRONMENTAL_MODEL);

        member.setBadge(badgeList);
        memberRepository.save(member);

        log.info("[뱃지 부여] 뱃지 부여를 완료했습니다. 현재 뱃지 리스트 : {}", badgeList);
    }

    /*
        ** 새로고침 Service
    */
    @Transactional
    public void refresh(String id) throws Exception {
        Member member = memberRepository.findMemberById(id);
        Collection<MailAccount> accountList = member.getMailAccount();

        // 매번 읽어올 때마다 값이 같아야 하므로 0으로 지정해뒀음
        int totalCount = 0;

        for (MailAccount mailAccount : accountList) {
            // 새로운 메일 읽기
            if (mailDataRepository.findTopByMailAccountOrderByReceivedDateDesc(mailAccount) == null) {
                log.info("[메일 읽어오기] 계정 추가 이후 처음으로 메일을 수신하고 있어요.");
                fetchAndSaveAllMails(mailAccount);
            } else readRecentMails(mailAccount);

            // 메일 총 갯수 업데이트하기
            totalCount += updateMailCount(mailAccount);
        }

        // 뱃지 부여
        grantBadge(member.getId());

        member.setTotalCount(totalCount);
        memberRepository.save(member);
        mailAccountRepository.saveAll(accountList);

        log.info("[새로고침] 새로고침을 완료했습니다.");
    }

    /*
        ** 메일 계정 삭제 service
     */
    public MailAccount deleteAccount(String username) {

        MailAccount account = mailAccountRepository.findById(username).orElseThrow();

        mailAccountRepository.delete(account);
        log.info("[메일박스 삭제] {} 계정에 연결된 메일 {}의 연결을 삭제합니다.", account.getMember().getId(), username);
        return account;
    }

    /*
        ** 메일 삭제 service
     */
    public void deleteMail(MailAccount mailAccount) throws Exception {

        String protocol = "imaps"; //imaps

        // TODO : Collection 으로 받아와서 일괄저장할건지, 불러올때마다 DB 호출할건지?
        // TODO : 메일 중복저장 되지 않게

        Properties props = System.getProperties();
        props.setProperty("mail.store.protocol", protocol);

        Session session = Session.getDefaultInstance(props, new MailAuthenticator(mailAccount.getUsername(), mailAccount.getPassword()));
        Store store = session.getStore(protocol);
        store.connect(mailAccount.getHost(), mailAccount.getUsername(), mailAccount.getPassword());

        Folder inbox = store.getFolder("INBOX");
        inbox.open(Folder.READ_ONLY);

        log.info("[시간측정] 메일 읽어오기 시작");
        // 받은 편지함에 있는 메일 모두 읽어오기
        Message[] arrayMessages = inbox.getMessages();
        log.info("[시간측정] 메일 읽어오기 종료");

        Collection<MailData> mailDataList = new ArrayList<>();
        for (Message msg : arrayMessages) {
            MailData mailData = handleMailData(mailAccount, msg);
            if (mailDataRepository.findByMailAccountAndReceivedDate(mailAccount, msg.getReceivedDate()) == null) {
                log.info("[새로운 메일 도착] 새로운 메일이 도착했어요!");
                mailDataList.add(mailData);
            }
        }

        // 메일박스와 연결 끊기
        inbox.close(false);
        store.close();

        log.info("[읽어온 메일] : {}", mailDataList);
        mailDataRepository.saveAll(mailDataList);
        log.info("[메세지 읽어오기] DB 저장 완료");
    }

    public List<MailData> test(String username) {
        return mailDataRepository.findAllByMailAccount(mailAccountRepository.findById(username).orElseThrow());
    }
}
