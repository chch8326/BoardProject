package com.choi.board.security;

import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import com.choi.board.mapper.MemberMapper;
import com.choi.board.model.AuthVO;
import com.choi.board.security.model.CustomUserDetails;
import lombok.Setter;

public class CustomUserDetailsService implements UserDetailsService {

	@Setter(onMethod_ = @Autowired)
	private MemberMapper memberMapper;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		CustomUserDetails user = memberMapper.getUserById(username);
		
		if(user == null) {
			throw new InternalAuthenticationServiceException(username);
		}
		
		return user;
	}
	
	public void signUp(CustomUserDetails user) {
		String username = user.getUsername();
		List<AuthVO> authList = null;
		AuthVO auth = null;
		
		/*
		 * 아이디에 admin이 있을 경우 ROLE_ADMIN, ROLE_USER 권한을 부여
		 * 아이디에 admin이 없을 경우 ROLE_USER 권한만 부여
		 */
		if(username.contains("admin")) {
			authList = new ArrayList<AuthVO>();
			auth = new AuthVO();
			
			auth.setUid(username);
			auth.setAuth("ROLE_ADMIN");
			authList.add(auth);
			user.setAuthList(authList);
			memberMapper.create(user);
			memberMapper.authSet(auth);
			
			auth.setUid(username);
			auth.setAuth("ROLE_USER");
			authList.add(auth);
			user.setAuthList(authList);
			memberMapper.authSet(auth);
		} else {
			authList = new ArrayList<AuthVO>();
			auth = new AuthVO();
			
			auth.setUid(username);
			auth.setAuth("ROLE_USER");
			authList.add(auth);
			user.setAuthList(authList);
			memberMapper.create(user);
			memberMapper.authSet(auth);
		}
	}

}
