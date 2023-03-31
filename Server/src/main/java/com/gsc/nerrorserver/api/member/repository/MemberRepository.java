package com.gsc.nerrorserver.api.member.repository;

import com.gsc.nerrorserver.api.member.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Repository
public interface MemberRepository extends JpaRepository<Member, String> {
    public boolean existsMemberById(String id);
    public boolean existsMemberByNickname(String nickname);
    public Member findMemberById(String id);

}
