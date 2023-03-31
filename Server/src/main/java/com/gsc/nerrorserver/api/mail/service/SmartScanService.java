package com.gsc.nerrorserver.api.mail.service;

import com.gsc.nerrorserver.api.mail.entity.MailAccount;
import com.gsc.nerrorserver.api.mail.entity.MailData;
import com.gsc.nerrorserver.api.mail.repository.MailAccountRepository;
import com.gsc.nerrorserver.api.mail.repository.MailDataRepository;
import com.gsc.nerrorserver.global.auth.MailAuthenticator;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriBuilder;
import org.springframework.web.util.UriComponentsBuilder;

import javax.mail.*;
import javax.mail.search.*;
import java.net.URI;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;

@Slf4j
@Service
@RequiredArgsConstructor
public class SmartScanService {

    private final MailAccountRepository mailAccountRepository;
    private final MailDataRepository mailDataRepository;

    private static final String ML_SERVER_URI = "http://localhost:9000";
    private static final String API_PATH = "/api/hello";

//    public ResponseEntity sendAndGetData(String username) {
//
//        MailAccount mailAccount = mailAccountRepository.findById(username).orElseThrow();
//        List<MailData> mailDataList = mailDataRepository.findAllByMailAccount(mailAccount);
//
//        URI uri = UriComponentsBuilder
//                .fromUriString(ML_SERVER_URI)
//                .path(API_PATH)
//                .encode()
//                .build()
//                .toUri();
//        log.info("[Smart Scan] ML 서버 ({})로 데이터를 전송합니다.", uri);
//
//        RestTemplate rt = new RestTemplate();
//        return rt.
//    }

    /*
        ** 메일 삭제 Service
     */
    public void deleteMail(String username, List<Long> deleteIdList) throws Exception {

        MailAccount account = mailAccountRepository.findById(username).orElseThrow();

        // 삭제 대상 찾기
        List<MailData> deleteMailDataList = new ArrayList<>();

        // IMAP connection 생성
        Properties props = System.getProperties();
        props.setProperty("mail.store.protocol", "imaps");
        Session session = Session.getDefaultInstance(props, new MailAuthenticator(account.getUsername(), account.getPassword()));
        Store store = session.getStore("imaps");
        store.connect(account.getHost(), account.getUsername(), account.getPassword());
        Folder inbox = store.getFolder("INBOX");
        inbox.open(Folder.READ_WRITE);   // TODO : READ_WRITE

        for (MailData m : mailDataRepository.findAllByMailAccount(account)) {
            if (deleteIdList.contains(m.getId())) {
                // 삭제 조건에 포함되면 삭제 리스트에 추가
                deleteMailDataList.add(m);

                // 메일 서버에서도 삭제 표시
                String deleteSubject = m.getSubject();
                Date deleteReceivedDate = m.getReceivedDate();
                SearchTerm andTerm = new AndTerm(new SubjectTerm(deleteSubject), new ReceivedDateTerm(ComparisonTerm.GT, deleteReceivedDate));
                Message[] deletedMessage = inbox.search(andTerm);
                for (Message msg : deletedMessage) msg.setFlag(Flags.Flag.DELETED, true);
            }
        }

        // 삭제 결과 메일 서버와 DB 반영
        inbox.close(true);
        store.close();
        mailDataRepository.deleteAll(deleteMailDataList);
    }
}
