package com.gsc.nerrorserver.api.mail.repository;

import com.gsc.nerrorserver.api.mail.entity.MailAccount;
import com.gsc.nerrorserver.api.mail.entity.MailData;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MailAccountRepository extends JpaRepository<MailAccount, String> {

}
