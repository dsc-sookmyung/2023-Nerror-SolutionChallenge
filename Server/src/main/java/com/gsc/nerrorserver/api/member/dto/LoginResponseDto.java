package com.gsc.nerrorserver.api.member.dto;

import com.gsc.nerrorserver.api.mail.entity.MailAccount;
import com.gsc.nerrorserver.api.member.entity.BadgeType;
import lombok.Builder;
import lombok.Data;

import java.util.List;
import java.util.Set;

@Data
public class LoginResponseDto {

    String id;
    String nickname;
    List<String> accountList;
    Set<BadgeType> badge;
    int currentLevel;
    int deletedCount;
    int totalCount;

    @Builder
    public LoginResponseDto(
            String id, String nickname, int deletedCount, List<String> accountList, Set<BadgeType> badge, int currentLevel, int totalCount) {
        this.id = id;
        this.nickname = nickname;
        this.accountList = accountList;
        this.badge = badge;
        this.currentLevel = currentLevel;
        this.deletedCount = deletedCount;
        this.totalCount = totalCount;
    }
}
