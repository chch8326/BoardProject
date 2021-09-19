package com.choi.board.security.model;

import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import com.choi.board.model.AuthVO;

public class CustomUserDetails implements UserDetails {
	
	private static final long serialVersionUID = 1L;
	private String uid; // 사용자 아이디
	private String upassword; // 사용자 비밀번호 
	private String uname; // 사용자 이름
	private String uemail; // 사용자 이메일
	private Date registerDate; // 가입일
	private List<AuthVO> authList; // 권한 리스트
	
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return getAuthList().stream()
				.map(auth -> new SimpleGrantedAuthority(auth.getAuth()))
				.collect(Collectors.toList());
	}
	
	@Override
	public String getUsername() {
		return uid;
	}
	
	public void setUsername(String uid) {
		this.uid = uid;
	}
	
	@Override
	public String getPassword() {
		return upassword;
	}
	
	public void setPassword(String upassword) {
		this.upassword = upassword;
	}
	
	@Override
	public boolean isAccountNonExpired() {
		return true;
	}
	
	@Override
	public boolean isAccountNonLocked() {
		return true;
	}
	
	@Override
	public boolean isCredentialsNonExpired() {
		return true;
	}
	
	@Override
	public boolean isEnabled() {
		return true;
	}
	
	public String getUname() {
		return uname;
	}
	
	public void setUname(String uname) {
		this.uname = uname;
	}
	
	public String getUemail() {
		return uemail;
	}
	
	public void setUemail(String uemail) {
		this.uemail = uemail;
	}
	
	public Date getRegisterDate() {
		return registerDate;
	}
	
	public void setRegisterDate(Date registerDate) {
		this.registerDate = registerDate;
	}
	
	public List<AuthVO> getAuthList() {
		return authList;
	}
	
	public void setAuthList(List<AuthVO> authList) {
		this.authList = authList;
	}

}
