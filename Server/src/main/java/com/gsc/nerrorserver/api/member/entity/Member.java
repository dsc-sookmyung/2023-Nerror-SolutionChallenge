package com.gsc.nerrorserver.api.member.entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.gsc.nerrorserver.api.mail.entity.MailAccount;
import com.gsc.nerrorserver.global.entity.BaseTimeEntity;
import lombok.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import javax.persistence.*;
import java.util.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class Member extends BaseTimeEntity implements UserDetails {

    @Id
    @Column(name = "member_id")
    private String id;

    private String password;
    private String nickname;

    private int deletedCount;
    private int currentLevel;
    private int totalCount;

    @JsonManagedReference
    @OneToMany(mappedBy = "member", cascade = CascadeType.ALL)
    private List<MailAccount> mailAccount = new ArrayList<>();

    @ElementCollection
    @CollectionTable
    private Set<BadgeType> badge;

    @ElementCollection
    @CollectionTable
    private Set<String> attendance; // 출석부는 중복 xx


    // 회원가입용
    @Builder
    public Member(String id, String password, String nickname) {
        this.id = id;
        this.password = password;
        this.nickname = nickname;
        this.attendance = new HashSet<>();
        this.badge = new HashSet<>();
    }


    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return null;
    }

    @Override
    public String getPassword() {
        return this.password;
    }

    @Override
    public String getUsername() {
        return this.id;
    }

    // 계정 만료되었는지 (true - 만료 안됨)
    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    // 계정 잠겨있는지 (true - 안잠김)
    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    // 계정 비밀번호 만료되었는지 (true - 만료 X)
    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    // 계정 활성화 상태인지 (true - 활성화)
    @Override
    public boolean isEnabled() {
        return true;
    }

}
