<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@include file="../includes/header.jsp"%>
<script type="text/javascript">
	$(function(){

		//시큐리티 csrf
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		var b_no = $("#b_no").val();
		var m_id = $("#m_id").val();
		
		$("#clickheart").hide();
		$("#clickedhate").hide();

		/*var getCDist = function(c_no){
			$.ajax("/category/get",{data: {c_no: c_no}, success: function(data){
				console.log(data);
			}});
		}*/


		//회원별 이 게시물에 love를 눌렀는지 확인 function
		var isLoved = function(m_id, b_no){
			$.ajax("/board/isLoved", {data: {m_id: m_id, b_no: b_no}, success: function(re){
				if(re == 1){
					$("#clickheart").show();
					$("#heart").hide();
				}
			}});
		}
		//회원별 이 게시물에 hate를 눌렀는지 확인 function
		var isHated = function(m_id, b_no){
			$.ajax("/board/isHated", {data: {m_id: m_id, b_no: b_no}, success: function(re){
				if(re == 1){
					$("#clickedhate").show();
					$("#hate").hide();
				}
			}});
		}

		isLoved(m_id, b_no);
		isHated(m_id, b_no);
		
		$("#updateBtn").on("click",function(){
			self.location = "/board/update?b_no="+b_no;
		})
		$("#deleteBtn").on("click",function(){
			console.log(b_no);
			var re = confirm("정말로 삭제하시겠습니까?");
			if(re){
				$.ajax("/board/delete", {type: 'GET', data: {b_no: b_no}, success: function(result){
					if( result == "0"){
						alert("죄송합니다. 예기치 않은 오류가 발생했습니다. 게시물을 삭제하지 못 했습니다.");
					}else{
						alert("게시물을 성공적으로 삭제했습니다.");
						location.href="/board/list?categoryNum="+$("#c_no").val();
					}
				}});
			}
		})
		
		//댓글 목록 ajax
		$.ajax("/reply/list",{type:"GET",data:{b_no:b_no}, success: function(reply){
			reply = JSON.parse(reply);
			console.log(reply);
			$.each(reply, function(idx,r){
				var m_id = r.m_id
				console.log(m_id)
 				var tr = $("<tr class='rep'></tr>");	
				//var button= $("<button class='deleteReply'></button>").text("삭제").attr("r_no",r.r_no);
				var td1 = $("<td width=10%></td>").html(r.m_id);
				var td2 = $("<td width=50%></td>").html(r.r_content);
				//날짜 양식 맞춰야함.
				var td3 = $("<td width=20%></td>").html(r.r_date);
				var td4 = $("<td width=10%></td>").html("신고버튼");
				var td5 = $("<td width=10%></td>");
				var secStr = "";
				secStr += "<sec:authorize access='isAuthenticated()'>"
				if("<sec:authentication property='principal.username'/>"==r.m_id){
					secStr += "<button class='deleteReply btn btn-outline-dark' r_no="+r.r_no+">삭제</button>"
				}
				secStr += "</sec:authorize>"			
				td5.append(secStr);
				tr.append(td1,td2,td3,td4,td5);
				$("#replyTable").append(tr);
				
			})
		}})

		//댓글 등록 ajax
		$("#insertReply").on("click",function(){
			var r = $("#boardReply").serialize();
			var re = confirm("Ae-Ho는 클린한 웹 서비스를 위하여 댓글 수정 기능을 지원하지 않습니다. 착한 댓글을 등록하시겠습니까?")
			if(re){
				$.ajax({
					url:"/reply/insert",
					type:"POST", 
					data:r,
					beforeSend: function(xhr){
						xhr.setRequestHeader(header,token)	
					},
					cache:false,
					success:function(result){
						alert(result);
						location.href="/board/get?b_no="+b_no;
				}})
			}
		})

		//댓글 삭제 ajax 기능구현부터!
		$(document).on("click",".deleteReply",function(){
			var rno = $(this).attr("r_no");
			console.log(rno);
			var re = confirm("해당 댓글을 삭제하시겠습니까?")
			if(re){
				$.ajax({
					url:"/reply/delete",
					type:"POST",
					data:{r_no:rno, b_no:b_no},
					beforeSend: function(xhr){
						xhr.setRequestHeader(header,token)	
					},
					cache:false,
					success:function(result){
						alert(result);
						location.href="/board/get?b_no="+b_no;
				}})
			}
		})
		
		//좋아요 등록
		$(document).on("click","#heart",function(){
			if(m_id == "" || m_id == null){
				alert("로그인 후 이용해주세요.");
			}else{
				$.ajax({
					url: "/board/insertLove",
					type: "POST", 
					data: {m_id: m_id, b_no: b_no},
					beforeSend: function(xhr){
						xhr.setRequestHeader(header,token)	
					},
					cache: false, 
					success: function(result){
					//alert(result);
					if(result == 1){
						$("#clickheart").show();
						$("#heart").hide();
						$("#loveCnt").html(eval($("#loveCnt").html())+1);
					}
					
				}});
			}
		})
		
		//싫어요 등록
		$(document).on("click", "#hate", function(){
			if(m_id == "" || m_id == null){
				alert("로그인 후 이용해주세요.");
			}else{
				$.ajax({
					url: "/board/insertHate",
					type: "POST", 
					data: {m_id: m_id, b_no: b_no},
					beforeSend: function(xhr){
						xhr.setRequestHeader(header,token)	
					},
					cache: false, 
					success: function(result){
					if(result == 1){
						$("#clickedhate").show();
						$("#hate").hide();
						$("#hateCnt").html(eval($("#hateCnt").html())+1);
					}
				}});
			}
		});

		//좋아요 취소
		$(document).on("click","#clickheart",function(){
			$.ajax({
				url: "/board/deleteLove",
				type: "POST", 
				data: {m_id: m_id, b_no: b_no},
				beforeSend: function(xhr){
					xhr.setRequestHeader(header,token)	
				},
				cache: false, 
				success: function(result){
				if(result == 1){
					$("#clickheart").hide();
					$("#heart").show();
					$("#loveCnt").html(eval($("#loveCnt").html())-1);
				}
			}});
		});

		//싫어요 취소
		$(document).on("click","#clickedhate",function(){
			$.ajax({
				url: "/board/deleteHate",
				type: "POST", 
				data: {m_id: m_id, b_no: b_no},
				beforeSend: function(xhr){
					xhr.setRequestHeader(header,token)	
				},
				cache: false,
				success: function(result){
				if(result == 1){
					$("#clickedhate").hide();
					$("#hate").show();
					$("#hateCnt").html(eval($("#hateCnt").html())-1);
				}
			}});
		})
	})
</script>
	<input type="hidden" id="b_no" value="${ board.b_no }">
	<input type="hidden" id="c_no" value="${ board.c_no }">
	<sec:authorize access="isAuthenticated()">
		<input type="hidden" id="m_id" value="<sec:authentication property="principal.username"/>">
	</sec:authorize>
	<sec:authorize access="isAnonymous()">
		<input type="hidden" id="m_id" value="">
	</sec:authorize>
	<table class="table table-bordered">
		<tr>
			<td colspan="3"><h3><c:out value="${board.b_title }"/></h3></td>
			<td>
				<img id="heart" src="/img/heart.png" width="30" height="30">
				<img id="clickheart" src="/img/clickheart.png" width="30" height="30">
				<img id="hate" src="/img/hate.png" width="30" height="30">
				<img id="clickedhate" src="/img/clickedhate.png" width="30" height="30">		
			</td>
		</tr>
		<tr>
			<td width="45%"><c:out value="${board.m_id }"/></td>
			<td width="15%"><fmt:formatDate pattern="yyyy-MM-dd" value="${board.b_date }"/></td>
			<td width="15%"><fmt:formatDate pattern="yyyy-MM-dd" value="${board.b_updatedate }"/></td>
			<td width="25%">조회 <c:out value="${board.b_hit }"/>  / Love <c:out value="<span id='loveCnt'>${ board.b_lovecnt }</span>" escapeXml="false"/> / hate <c:out value="<span id='hateCnt'>${ board.b_hatecnt }</span>" escapeXml="false"/></td>
		</tr>
		<tr>
			<td colspan="4" height="500px">
				<div>${board.b_content }</div>
			</td>
		</tr>
	</table>
	<div>			
		<sec:authentication property="principal" var="pinfo"/>
		<sec:authorize access="isAuthenticated()">
			<c:if test="${pinfo.username eq board.m_id}">
					<button id="updateBtn" class="btn btn-outline-dark">수정</button>
					<button id="deleteBtn" class="btn btn-outline-dark">삭제</button>			
			</c:if>
		</sec:authorize>		
    </div>

	<hr>
	<h4>댓글</h4>
	<table id="replyTable" class="table table-bordered">
	</table>
	<hr>
	<sec:authorize access="isAuthenticated()">
		<form id="boardReply">
			<input type="hidden" name="b_no" value="<c:out value='${board.b_no }'/>">
			<input type="text" name="m_id" value="<sec:authentication property="principal.username"/>" readonly="readonly">
			<input type="text" name="r_content" required="required">
		</form>
		<button type="submit" id="insertReply" class="btn btn-outline-dark">댓글등록</button>
	</sec:authorize>
<%@include file="../includes/footer.jsp"%>