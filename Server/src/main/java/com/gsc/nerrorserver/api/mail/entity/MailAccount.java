package com.gsc.nerrorserver.api.mail.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.gsc.nerrorserver.api.member.entity.Member;
import com.gsc.nerrorserver.global.entity.BaseTimeEntity;
import lombok.*;

import javax.persistence.*;
import java.util.Collection;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MailAccount extends BaseTimeEntity {

    @Id
    private String username;

    private String password;

    private String host;

    private int port;
    private int mailCount;

    @JsonManagedReference
    @OneToMany(mappedBy = "mailAccount", cascade = CascadeType.ALL)
    private Collection<MailData> mailData;

    @JsonBackReference
    @ManyToOne
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @Builder
    public MailAccount(Member member, String username, String password, String host, int port) {
        this.member = member;
        this.username = username;
        this.password = password;
        this.mailCount = 0;
        this.host = host;
        this.port = port;
    }
}
