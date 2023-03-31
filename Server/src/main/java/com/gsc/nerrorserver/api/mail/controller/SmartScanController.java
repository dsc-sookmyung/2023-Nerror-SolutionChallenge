package com.gsc.nerrorserver.api.mail.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/v1")
public class SmartScanController {

//    @GetMapping("/scan")
//    public ResponseEntity smartScan(@RequestParam String username) {
//        // 1. Server → ML Server : Username의 Mail Data 를 POST request
//
//        // 2. ML Server → Server : 삭제해야 할 메일의 ID(List) 를 POST response
//        // 3. Server : ID List 에 대해 삭제 처리 진행
//        // 4. Server → Client : 삭제 완료되었다는 응답과 함께, 삭제량과 totalCount 반영된 DTO를 응답
//
//        return ResponseEntity.ok();
//    }

}
