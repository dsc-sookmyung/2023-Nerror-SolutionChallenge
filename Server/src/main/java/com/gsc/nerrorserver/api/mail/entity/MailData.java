package com.gsc.nerrorserver.api.mail.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import lombok.*;

import javax.persistence.*;
import java.awt.*;
import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;

@Entity
@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class MailData {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "mail_id")
    private Long id;
    @Column(length = 10000)
    private String subject; // 제목

    @Column(length = 1000)
    private String sender; // 발신자

    @Lob
    private String contents; // 내용
    private Date receivedDate;
    private Long attachmentSize;

    @ElementCollection
    @CollectionTable
    private Collection<File> attachments = new ArrayList<>(); // 첨부파일

    @JsonBackReference
    @ManyToOne
    @JoinColumn(name = "username", nullable = false)
    private MailAccount mailAccount;

    @Builder
    public MailData(MailAccount account, String subject, String sender, String contents, Date receivedDate, Long attachmentSize) {
        this.mailAccount = account;
        this.subject = subject;
        this.sender = sender;
        this.contents = contents;
        this.receivedDate = receivedDate;
        this.attachmentSize = attachmentSize;
    }
}
