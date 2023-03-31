package com.gsc.nerrorserver.api.mail.repository;

import com.gsc.nerrorserver.api.mail.entity.MailAccount;
import com.gsc.nerrorserver.api.mail.entity.MailData;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface MailDataRepository extends JpaRepository<MailData, Long> {

    // @return 특정 mail account 에서 가장 최근 receivedDate
    MailData findTopByMailAccountOrderByReceivedDateDesc(MailAccount mailAccount);

    // 메일 중복 저장 방지
    MailData findByMailAccountAndReceivedDate(MailAccount account, Date receivedDate);

    boolean existsMailDataByMailAccountAndReceivedDate(MailAccount account, Date ReceivedDate);

    // Smart Scan 대상 메일 데이터 분류
    List<MailData> findAllByMailAccount(MailAccount account);

    // Id 일치하는 메일 데이터 가져오기
}
