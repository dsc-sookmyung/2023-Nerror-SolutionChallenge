package com.gsc.nerrorserver.api.mail.entity;

public enum AccountType {

    NAVER("네이버메일"),
    GOOGLE("구글메일"),
    DAUM("다음메일"),
    ETC("기타메일");

    private final String name;
    AccountType(String name) {
        this.name = name;
    }

    public String getName() {
        return this.name();
    }
}
