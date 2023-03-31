package com.gsc.nerrorserver.api.member.dto;

import lombok.Builder;
import lombok.Data;

@Data
public class SignupResponseDto {
    String id;
    String nickname;

    @Builder
    public SignupResponseDto(String id, String nickname) {
        this.id = id;
        this.nickname = nickname;
    }
}
