var replyService = (function() {
	// 댓글 출력
	function getReplyList(param, callback, error) {
		var bno = param.bno;
		var page = param.page || 1;
		
		$.getJSON("/replies/" + bno + "/" + page + ".json", function(data) {
			if(callback) callback(data.replyCount, data.replyList);
		}).fail(function(xhr, status, err) {
			if(error) error(err);
		});
	}
	
	// 댓글 작성
	function register(reply, callback, error) {
		$.ajax({
			type: "post",
			url: "/replies/new",
			data: JSON.stringify(reply),
			contentType: "application/json; charset=utf-8",
			success: function(result, status, xhr) {
				if(callback) callback(result);
			},
			error: function(xhr, status, err) {
				if(error) error(err);
			}
		});
	}
	
	// 댓글 조회
	function view(rno, callback, error) {
		$.get("/replies/" + rno + ".json", function(result) {
			if(callback) callback(result);
		}).fail(function(xhr, status, err) {
			if(error) error(err);
		});
	}
	
	// 댓글 수정
	function modify(reply, callback, error) {
		$.ajax({
			type: "put",
			url: "/replies/" + reply.rno,
			data: JSON.stringify(reply),
			contentType: "application/json; charset=utf-8",
			success: function(result, status, xhr) {
				if(callback) callback(result);
			},
			error: function(xhr, status, err) {
				if(error) error(err);
			}
		});
	}
	
	// 댓글 삭제
	function remove(rno, replyer, callback, error) {
		$.ajax({
			type: "delete",
			url: "/replies/" + rno,
			data: JSON.stringify({ rno:rno, replyer:replyer }),
			contentType: "application/json; charset=utf-8",
			success: function(result, status, xhr) {
				if(callback) callback(result);
			},
			error: function(xhr, status, err) {
				if(error) error(err);
			}
		});
	}
	
	// 댓글 작성 시간 출력
	function displayTime(time) {
		var today = new Date();
		var gap = today.getTime() - time;
		var dateObj = new Date(time);
		
		if(gap < (1000 * 60 * 24 * 24)) {
			var HH = dateObj.getHours();
			var mm = dateObj.getMinutes();
			var ss = dateObj.getSeconds();
			
			return [(HH > 9 ? '' : '0') + HH, ':', (mm > 9 ? '' : '0') + mm, ':', 
					(ss > 9 ? '' : '0') + ss].join('');
		} else {
			var yyyy = dateObj.getFullYear();
			var MM = dateObj.getMonth() + 1;
			var dd = dateObj.getDate();
			
			return [yyyy, '/', (MM > 9 ? '' : '0') + MM, '/', 
					(dd > 9 ? '' : '0') + dd].join('');
		}
	}
	
	return {
		getReplyList : getReplyList,
		register : register,
		view : view,
		modify : modify,
		remove : remove,
		displayTime : displayTime
	};
})();