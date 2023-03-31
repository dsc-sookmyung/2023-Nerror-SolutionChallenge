package com.gsc.nerrorserver.api.mail.controller;

import com.gsc.nerrorserver.api.mail.dto.MailReceiveDto;
import com.gsc.nerrorserver.api.mail.dto.MailboxResponseDto;
import com.gsc.nerrorserver.api.mail.entity.MailAccount;
import com.gsc.nerrorserver.api.mail.entity.MailData;
import com.gsc.nerrorserver.api.mail.service.MailService;
import com.gsc.nerrorserver.api.member.entity.Member;
import com.gsc.nerrorserver.api.member.repository.MemberRepository;
import com.gsc.nerrorserver.global.response.GlobalResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.net.http.HttpResponse;
import java.util.*;


@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/mailbox")
public class MailController {

    private final MemberRepository memberRepository;
    private final MailService mailService;

    /* 메일 계정 추가 API */
    // TODO : 메일함 현황 불러오기, 사용자 레벨 조회
    @PostMapping("/add")
    public ResponseEntity addAccount(HttpServletResponse res, @RequestBody MailReceiveDto dto) {
        try {
            // 계정 추가
            Member member = mailService.addMailbox(dto);

            // 메일 총 개수 저장
            mailService.updateTotalCount(dto.getId());

            // DTO 생성
            List<MailAccount> mailAccountList = member.getMailAccount();
            List<String> accountList = new ArrayList<>();
            for (MailAccount account : mailAccountList) accountList.add(account.getUsername());
            MailboxResponseDto responseDto = MailboxResponseDto.builder()
                    .id(member.getId())
                    .nickname(member.getNickname())
                    .accountList(accountList)
                    .totalCount(memberRepository.findMemberById(member.getId()).getTotalCount())
                    .build();
            return ResponseEntity.ok(responseDto);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "계정 정보 오류로 메일박스 연결에 실패했습니다.");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
        }
    }

    /* 메일 읽어오는 API */
    @GetMapping("/save")
    public ResponseEntity saveMailData(HttpServletResponse res, @RequestParam(name = "id") String memberId) {
        try {
            Member member = memberRepository.findMemberById(memberId);
            Collection<MailAccount> accountList = member.getMailAccount();

            // 메일 읽고 저장
            for (MailAccount account : accountList) {
                mailService.fetchAndSaveAllMails(account);
            }

            // total count update
            mailService.updateTotalCount(memberId);

            Map<String, Integer> result = new HashMap<>();
            result.put("totalCount", memberRepository.findMemberById(memberId).getTotalCount());
            return ResponseEntity.ok(result);

        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> result = new HashMap<>();
            result.put("error", "메일을 수신하는 과정에서 에러가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(result);
        }
    }

    /* 메일박스 삭제 */
    @GetMapping("/deleteMailbox")
    public GlobalResponse deleteMailbox(HttpServletResponse res, @RequestParam(name = "username") String username) {
        MailAccount deletedAccound = mailService.deleteAccount(username);
        return GlobalResponse.success("msg", deletedAccound.getUsername());
    }

    /* 새로고침 API (최신 메일 불러오기, 총 메일 개수 업데이트) */
    @GetMapping("/refresh")
    public GlobalResponse refresh(HttpServletResponse res, @RequestParam(name = "id") String id) {
        try {
            mailService.refresh(id);
            log.info("[새로고침] 최신 메일을 업데이트하고, 뱃지 설정 및 부여를 완료했습니다.");

            Member resultMember = memberRepository.findMemberById(id);
            return GlobalResponse.success("result", resultMember);
        } catch (Exception e) {
            e.printStackTrace();
            res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return GlobalResponse.unauthorized("error", "메세지 개수를 업데이트하는 과정에서 오류가 발생했습니다.");
        }
    }

//    @GetMapping("/mailbox/my")
//    public GlobalResponse mypage(HttpServletResponse res, @RequestParam(name = "id") String id) {
//        // totalCount, deleteCount, currentLevel 등등 update 후 data fetching
//
//    }

    @GetMapping("/testSend")
    public ResponseEntity testSend(@RequestParam String username) {

        List<MailData> mailDataList = mailService.test(username);
        return ResponseEntity.ok(mailDataList);
    }
}
