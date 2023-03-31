package com.gsc.nerrorserver.global.response;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class TokenResponse {

    private String msg;
    private int statusCode;

    public TokenResponse(String msg, int statusCode) {
        this.msg = msg;
        this.statusCode = statusCode;
    }

}
