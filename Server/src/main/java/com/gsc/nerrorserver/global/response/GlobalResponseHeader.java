package com.gsc.nerrorserver.global.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
public class GlobalResponseHeader {
    private int code;
    private String message;
}
