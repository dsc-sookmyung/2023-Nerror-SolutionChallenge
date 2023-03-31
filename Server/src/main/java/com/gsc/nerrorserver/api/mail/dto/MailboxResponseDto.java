package com.gsc.nerrorserver.api.mail.dto;

import com.gsc.nerrorserver.api.member.entity.BadgeType;
import lombok.Builder;
import lombok.Data;

import java.util.List;
import java.util.Set;

@Data
public class MailboxResponseDto {

    String id;
    String nickname;
    List<String> accountList;
    int totalCount;

    @Builder
    public MailboxResponseDto(String id, String nickname, List<String> accountList, int totalCount) {
        this.id = id;
        this.nickname = nickname;
        this.accountList = accountList;
        this.totalCount = totalCount;
    }
}
