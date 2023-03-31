package com.gsc.nerrorserver.api.member.controller;

import com.gsc.nerrorserver.api.member.dto.LoginRequestDto;
import com.gsc.nerrorserver.api.member.dto.MailConfirmDto;
import com.gsc.nerrorserver.api.member.dto.SignupRequestDto;
import com.gsc.nerrorserver.api.mail.service.MailService;
import com.gsc.nerrorserver.api.member.dto.SignupResponseDto;
import com.gsc.nerrorserver.api.member.entity.Member;
import com.gsc.nerrorserver.api.member.repository.MemberRepository;
import com.gsc.nerrorserver.api.member.service.MemberService;
import com.gsc.nerrorserver.global.response.GlobalResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;

@Tag(name = "member", description = "회원 API")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/auth")
public class MemberController {

    private final MailService mailService;
    private final MemberService memberService;
    private final MemberRepository memberRepository;

    @Operation(summary = "이메일 인증", description = "이메일 인증번호 (ePw) 를 입력받은 메일로 전송합니다.")
    @PostMapping("/confirm")
    public ResponseEntity emailConfirm(@RequestBody MailConfirmDto dto) throws Exception {

        String ePw = mailService.sendSimpleMessage(dto.email);
        Map<String, String> confirmResult = new HashMap<>();
        confirmResult.put("AuthenticationCode", ePw);
        return ResponseEntity.ok(confirmResult);
    }

    @PostMapping("/signup")
    public ResponseEntity signup(HttpServletResponse res, @RequestBody SignupRequestDto requestDto) throws Exception {
        Map<String, String> result = new HashMap<>();

        // 중복가입 방지
        if (memberRepository.existsMemberById(requestDto.getId())) {
            result.put("error", "이미 존재하는 이메일입니다.");
            return ResponseEntity.status(HttpStatus.CONFLICT).body(result);
//            return GlobalResponse.conflict("error", "존재하는 이메일입니다.");
        }

        // 닉네임 중복검사
        else if (memberRepository.existsMemberByNickname(requestDto.getNickname())) {
            result.put("error", "이미 존재하는 닉네임입니다.");
            return ResponseEntity.status(HttpStatus.CONFLICT).body(result);
//            return GlobalResponse.conflict("error", "중복된 닉네임입니다.");
        }

        else {
            // 회원가입 진행
            Member member = memberService.signup(res, requestDto);
            SignupResponseDto responseDto = SignupResponseDto.builder()
                    .id(member.getId())
                    .nickname(member.getNickname())
                    .build();
            return ResponseEntity.ok(responseDto);
        }
    }

    @PostMapping("/login")
    public ResponseEntity login(HttpServletResponse res, @RequestBody LoginRequestDto dto) throws Exception {
        try {
            return ResponseEntity.ok(memberService.login(res, dto));
        } catch (BadCredentialsException e) {
            e.printStackTrace();
            Map<String, String> result = new HashMap<>();
            result.put("error", "인증 정보가 잘못되었습니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(result);
        }
    }
}