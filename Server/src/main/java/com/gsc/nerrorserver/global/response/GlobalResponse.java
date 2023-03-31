package com.gsc.nerrorserver.global.response;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.util.HashMap;
import java.util.Map;

@Getter
@RequiredArgsConstructor
public class GlobalResponse<T> {

    private final GlobalResponseHeader header;
    private final Map<String, T> body;

    private final static int SUCCESS = 200;
    private final static int NOT_FOUND = 400;
    private final static int FAILED = 500;

    //custom
    private final static int UNAUTHORIZED = 401;
    private final static int FORBIDDEN = 403;
    private final static int CONFLICT = 409;

    private final static String SUCCESS_MESSAGE = "(200) SUCCESS";
    private final static String NOT_FOUND_MESSAGE = "(400) NOT FOUND";
    private final static String UNAUTHORIZED_MESSAGE = "(401) 인증되지 않은 요청입니다";
    private final static String FORBIDDEN_MESSAGE = "(403) 실패한 요청입니다";
    private final static String CONFLICT_MESSAGE = "(409) 이미 존재하는 회원입니다";
    private final static String FAILED_MESSAGE = "(500) 서버 오류";

    public static <T> GlobalResponse<T> success(Map<String, Object> map) {
        return new GlobalResponse(new GlobalResponseHeader(SUCCESS, SUCCESS_MESSAGE), map);
    }
    public static <T> GlobalResponse<T> success(String name, T body) {
        Map<String, T> map = new HashMap<>();
        map.put(name, body);

        return new GlobalResponse(new GlobalResponseHeader(SUCCESS, SUCCESS_MESSAGE), map);
    }

    public static <T> GlobalResponse<T> fail() {
        return new GlobalResponse(new GlobalResponseHeader(FAILED, FAILED_MESSAGE), null);
    }

    public static <T> GlobalResponse<T> fail(String msg, T body) {
        Map<String, T> map = new HashMap<>();
        map.put(msg, body);
        return new GlobalResponse(new GlobalResponseHeader(FAILED, FAILED_MESSAGE), map);
    }
    public static <T> GlobalResponse<T> conflict(String msg, T body) {
        Map<String, T> map = new HashMap<>();
        map.put(msg, body);
        return new GlobalResponse(new GlobalResponseHeader(CONFLICT, CONFLICT_MESSAGE), map);
    }

    public static <T> GlobalResponse<T> unauthorized(String msg, T body) {
        Map<String, T> map = new HashMap<>();
        map.put(msg, body);
        return new GlobalResponse(new GlobalResponseHeader(UNAUTHORIZED, UNAUTHORIZED_MESSAGE), map);
    }

    public static <T> GlobalResponse<T> forbidden(String msg, T body) {
        Map<String, T> map = new HashMap<>();
        map.put(msg, body);
        return new GlobalResponse(new GlobalResponseHeader(FORBIDDEN, FORBIDDEN_MESSAGE), map);
    }

}
