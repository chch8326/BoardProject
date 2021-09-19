var uploadService = (function() {
	// 업로드된 파일 출력
	function getAttachFileList(data, callback, error) {
		$.getJSON("/board/getAttachFile.json", data, function(attachFileList) {
			if(callback) callback(attachFileList);
		}).fail(function(xhr, status, err) {
			if(error) error(err);
		});
	}
	
	// 업로드 할 파일을 파일 저장소에 저장
	function fileUpload(formData, callback, error) {
		$.ajax({
			type: "post",
			url: "/fileUpload",
			data: formData,
			dataType: "json",
			processData: false,
			contentType: false,
			success: function(attachFileList, status, xhr) {
				if(callback) callback(attachFileList);
			},
			error: function(xhr, status, err) {
				if(error) error(err);
			}
		});
	}
	
	// 파일 저장소에 있는 파일 삭제
	function fileInRepositoryRemove(data, callback, error) {
		$.ajax({
			type: "post",
			url: "/fileInRepositoryRemove",
			data: data,
			dataType: "text",
			success: function(result, status, xhr) {
				if(callback) callback(result);
			},
			error: function(xhr, status, err) {
				if(error) error(err);
			}
		});
	}
	
	// 데이터베이스에 있는 파일 삭제
	function fileDelete(data, callback, error) {
		$.ajax({
			type: "post",
			url: "/fileDelete",
			data: data,
			dataType: "text",
			success: function(result, status, xhr) {
				if(callback) callback(result);
			},
			error: function(xhr, status, err) {
				if(error) error(err);
			}
		});
	}
	
	return {
		getAttachFileList : getAttachFileList,
		fileUpload : fileUpload,
		fileInRepositoryRemove : fileInRepositoryRemove,
		fileDelete : fileDelete
	};
})();