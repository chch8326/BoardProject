package com.choi.board.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.choi.board.mapper.AttachMapper;
import lombok.AllArgsConstructor;
import lombok.Setter;

@Service
@AllArgsConstructor
public class AttachServiceImpl implements AttachService {
	
	@Setter(onMethod_ = @Autowired)
	private AttachMapper attachMapper;
	
	@Override
	public int uploadedFileDelete(String uuid) {
		return attachMapper.deleteFile(uuid);
	}

}
