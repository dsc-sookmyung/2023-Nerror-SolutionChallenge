package com.gsc.nerrorserver.api.member.service;

import com.gsc.nerrorserver.api.member.entity.Member;
import com.gsc.nerrorserver.api.member.entity.UserDetailsImpl;
import com.gsc.nerrorserver.api.member.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserDetailsServiceImpl implements UserDetailsService {

    private final MemberRepository memberRepository;

    @Override
    public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException {

        try {
            Member member = memberRepository.findById(id).orElseThrow();
            UserDetailsImpl userDetails = new UserDetailsImpl();
            userDetails.setMember(member);

            return userDetails;
        } catch (Exception e) {
            throw new RuntimeException("해당 사용자가 DB에 없습니다.");
        }
    }
}
