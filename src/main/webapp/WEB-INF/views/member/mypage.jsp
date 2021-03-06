<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="../includes/header.jsp"%>

<style>
	.userInfo{
		text-align: center;
	}
	
    table { 
		border-collapse: collapse; 
		border-spacing: 0;		
		width: 100%; 
		table-layout: fixed;
	}
	
	td { 
		vertical-align: middle; 
		overflow:hidden;
		white-space : nowrap;
		text-overflow: ellipsis;
	 }

	td.textOverDefault {
		white-space : normal; /*기본값*/
		text-overflow: clip; /*기본값*/
	}
	
</style>
<script type="text/javascript">

	$(function(){

		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		//진탁 06/02
		//시큐리티 태그립. 현재 로그인한 유저의 아이디를 user_id 전역 변수에 담음 여러 함수에 쓰일 예정
		var user_id = "<sec:authentication property='principal.username'/>";
		var data = {m_id:user_id}
		console.log(user_id);
		var profileImage;
		var m_img = "";
		
		//유저의 정보를 요청하는 ajax
		$.ajax({
			url:"/member/getMemberInfo",
			type:"GET",
			data:data,
			success:function(result){
				var member = JSON.parse(result);
				$("#userID").html(member.m_id);
				$("#userNICK").html(member.m_nick);
				$("#userEMAIL").html(member.m_email);
				$("#userLOVE").html(member.m_lovecnt);
				$("#userHATE").html(member.m_hatecnt);

				if(member.m_img){
					m_img = member.m_img;
					//$("#imagefile").val(m_img);
					profileImage = $("<img width='120px'></img>").attr("src", "/img/profileImg/"+member.m_img);
				}else{
					profileImage = $("<img width='100px' height='100px'></img>").attr("src", "/img/userICON.png").attr("image", "none");
				}
				$("#profileImage").append(profileImage);
			}
		})	

		$("#updateMember").on("click", function(){
			$("#confirmModal").modal('show');
		});

		$("#confirmBtn").on("click", function(e){
			e.preventDefault();
			$.ajax("/member/isCorrectPwd", {data: {m_id:user_id, m_pwd: $("#m_pwd").val()}, success: function(re){
				if( re == 0 ){
					swal({
						  text: "비밀번호가 일치하지 않습니다!",
						  icon: "warning",
						  button: "확인"
						});
				}else{
					location.href="/member/get";
				}
			}});
			
		});

		$('#m_pwd').keypress(function(event){
		     if ( event.which == 13 ) {
		         $('#confirmBtn').click();
		         return false;
		     }
		});


		//진탁 06/02
		//해당 유저의 최신 게시물 8개를 가져오는 함수.
		var getMyBoard = function(){			
			$.ajax({
				url:"/member/getMypageBoard",
				data:data,
				type:"GET",
				success:function(result){
					var boardList = JSON.parse(result);
					$.each(boardList,function(idx,board){
						var date = moment(board.b_date).format("YYYY-MM-DD");
						var tr = $("<tr align='center'></tr>");
						var category = $("<td></td>").html(board.c_dist);
						var link = $("<a target='_blank'></a>").attr("href","/board/get?b_no="+board.b_no).html(board.b_title);
						var title = $("<td></td>").append(link);
						var boardDate = $("<td></td>").html(date);
						tr.append(category,title,boardDate);
						$("#userContent").append(tr);
					})
					var totalLink = $("<a target='_blank' class='badge badge-info float-right'></a>").html("전체 게시글 보기").attr("href","/board/listAll?categoryNum=9999&c_no=9999&pageNum=1&amount=30&searchField=m_id&keyword="+user_id);
					$("#linkDiv").append(totalLink);	
				}
			})
		}

		//진탁 06/02
		//해당 유저의 최신 굿즈 8개를 가져오는 함수.
		var getMyGoods = function(){			
			$.ajax({
				url:"/member/getMypageGoods",
				data:data,
				type:"GET",
				success:function(result){
					var goodsList = JSON.parse(result);
					$.each(goodsList,function(idx,goods){
						var date = moment(goods.g_date).format("YYYY-MM-DD");
						var tr = $("<tr align='center'></tr>");
						var category = $("<td></td>").html(goods.c_dist);
						var link = $("<a target='_blank'></a>").attr("href","/goods/get?g_no="+goods.g_no).html(goods.g_title);
						var title = $("<td></td>").append(link);
						var boardDate = $("<td></td>").html(date);
						tr.append(category,title,boardDate);
						$("#userContent").append(tr);
					})
					var totalLink = $("<a class='badge badge-info float-right'></a>").html("전체 굿즈글 보기").attr("href","/goods/list?member="+user_id);
					$("#linkDiv").append(totalLink);		
				}
			})
		}
		getMyBoard();

		$(document).on("click","#myBoard",function(){
			$("#userContent").empty();
			$("#linkDiv").empty();
			getMyBoard();
		})
		$(document).on("click","#myGoods",function(){
			$("#userContent").empty();
			$("#linkDiv").empty();
			getMyGoods();
		})


		//프로필 이미지
		
		$("#profileImageModal").on('hidden.bs.modal', function(e){
			self.location = "/member/mypage";
			e.stopImmediatePropagation(); 
		});

		$("#profileImage").click(function(){
			$("#profileImageModal").modal('show');
		});

		$("#updateImage").click(function(){
			$("#profileImageModal").modal('show');
		});

		$("#addPhoto").click(function(){
			$("#imagefile").click();
			return false;
		});

		var isDeleted = false;
		
		$("#deletePhote").click(function(){
			isDeleted = true;
			$("#m_img").attr("src", "");
			$("#uploadProfileImageBtn").html("삭제");
		});

		var preview = function(e){
			if(window.FileReader){
				var file = e.target.files[0];
				var reader = new FileReader();
				reader.readAsDataURL(file);
				reader.onload = function(e){
					$("#m_img").attr("src", reader.result);
				}
			}
		}

		var isUpdate = false;

		document.getElementById("imagefile").addEventListener("change", preview, false);
		
		$('#profileImageModal').on('show.bs.modal', function (event) {
			var button = $(event.relatedTarget)
			//var idx = button.data('index');
			var modal = $(this);

			var isExistImage = profileImage.attr("image");

			if(isExistImage == "none"){
				$("#uploadProfileImageBtn").html("등록");
				$("#addPhoto").html("프로필 사진 추가");
				isUpdate = false;
			}else{
				$("#m_img").attr("src", "/img/profileImg/"+m_img);
				isUpdate = true;
			}
		});
		

		$("#uploadProfileImageBtn").click(function(){
			var form = new FormData();
			console.log("deleted?: " + isDeleted);
			form.append("m_id", user_id);

			if(isDeleted){

				$.ajax({
					type: "POST",
					contentType: false,
					processData: false,
					beforeSend: function(xhr){
						xhr.setRequestHeader(header,token)	
					},
					cache: false, 
		            enctype: 'multipart/form-data',
		            url: "/member/updateProfileImage",
					data: form, 
					success: function(re){
						if(re > 0){
							swal("이미지가 삭제되었습니다.", {
							      icon: "success",
							      button: "확인"
							}).then((확인)=>{
								if(확인){
									$("#profileImageModal").modal("hide");
								}
							});
						}
						
				}});
				return false;
			}

			if($("input[name='imagefile']")[0].files[0]){
				form.append("img_file", $("input[name='imagefile']")[0].files[0]);
				
				$.ajax({
					type: "POST",
					contentType: false,
					processData: false,
					beforeSend: function(xhr){
						xhr.setRequestHeader(header,token)	
					},
					cache: false, 
		            enctype: 'multipart/form-data',
		            url: "/member/updateProfileImage",
					data: form, 
					success: function(re){
						if(re > 0){
							swal("이미지가 등록되었습니다.", {
							      icon: "success",
							      button: "확인"
							}).then((확인)=>{
								if(확인){
									$("#profileImageModal").modal("hide");
								}
							});
						}
						
				}});
			}else{
				swal({
					  text: "이미지를 등록해주세요.",
				      icon: "warning",
				      button: "확인"
				});
			}
			
		});

		$("#cancelBtn").click(function(){
			$("#profileImageModal").modal("hide");
		});
	})
</script>
 	<div class="row">
	    <div class="col-lg-4">
	      <div class="card shadow mb-4">
	        <!-- Card Body -->
	        <div class="card-body">
	        	<div id="userBox">
	        		<div>
	        			<div align="center">
	        				<div id="profileImage" class="rounded-circle" style="width: 120px; height: 120px; border: 3px solid #F4F4F4; overflow: hidden; cursor: pointer;">
	        					<!-- <img src="/img/userICON.png" width="100px" height="100px"> -->
	        				</div>
<%-- 	        			<c:if test="${member.m_img == null }">
	        					
	        				</c:if>
	        				<c:if test="${member.m_img !=null }">
	        					<img src="/upload/profile/${member.m_img }">
	        				</c:if> --%>
	        			</div>
	        			<div>
		        			<ul class="list-group list-group-flush">
		        				<li class="list-group-item" >
		        					<h6><span class="badge badge-secondary">회원ID</span></h6>
		        					<div class="userInfo" id="userID"></div>
		        				</li>
		        				<li class="list-group-item">
		        					<h6><span class="badge badge-secondary">닉네임</span></h6>
		        					<div class="userInfo" id="userNICK"></div>
		        				</li>
		        				<li class="list-group-item">
		        					<h6><span class="badge badge-secondary">메일주소</span></h6>
		        					<div class="userInfo" id="userEMAIL"></div>
		        				</li>
		        				<li class="list-group-item">
		        					<h6><span class="badge badge-danger">누적 좋아요</span></h6>
		        					<div class="userInfo" id="userLOVE"></div>
		        				</li>
		        				<li class="list-group-item">
		        					<h6><span class="badge badge-danger">누적 싫어요</span></h6>
		        					<div class="userInfo" id="userHATE"></div>
		        				</li>
		        			</ul>
	        			</div>
	        		</div>
	        		<button id="updateImage" type="button" class="btn btn-light">프로필 사진</button>
	        		<button id="updateMember" type="button" class="btn btn-light float-right">회원 정보 수정</button>
	        	</div>
	        </div>
	      </div>
	    </div>
	    
	    <div class="col-lg-8">
	      <div class="card shadow mb-4">
	        <!-- Card Body -->
	        <div class="card-body" id="serachPickDiv">
	        	<div>
	        		<button type="button" class="btn btn-light float-right" id="myGoods">내가 올린 애호품</button>
	        		<button type="button" class="btn btn-light float-right" id="myBoard">내가 올린 애호글</button>
	        	</div>
	        	<div>
	        		<table class="table table-hover">
	        			<thead>
	        				<tr align="center">
	        					<th width="20%">카테고리</th>
	        					<th width="40%">제목</th>
	        					<th width="20%">날짜</th>	        					
	        				</tr>
	        			</thead>
	        			<tbody id="userContent">
	        			
	        			</tbody>
	        		</table>   	
	        	</div>
	        	<div id="linkDiv">
	        	
	        	</div>
	        </div>
	      </div>
	    </div>
	 </div>
	

	<!-- 개인정보 수정 Modal -->
	<div class="modal fade" id="confirmModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modalheader" style="padding: 20px;">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h5 class="modal-title" id="myModalLabel" align="center">비밀번호 확인</h5>
				</div>
				<form id="form" name="form">
					<div class="modal-body mb-3" style="padding: 20px 50px 0px 50px;">
						<div id="password" class="form-group">
						    <label for="m_pwd">비밀번호를 확인해주십시오.</label>
						    <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
						    <input type="password" class="form-control" id="m_pwd" name="m_pwd" required>
						</div>
					</div>
					<div class="modal-footer" style="background: #F4F4F4; border: 2px solid #F4F4F4;">
						<button id="confirmBtn" type="button" class="btn btn-dark" style="width: 300px; float:none; margin:0 auto;">확인</button>				
					</div>
				</form>
			</div>
		</div>
	</div>
	<!-- end Modal -->
	
	<!-- 프로필 사진 수정 Modal -->
	<div class="modal fade" id="profileImageModal" tabindex="-1" role="dialog" aria-labelledby="modalTitle" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modalheader" style="padding: 20px;">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h5 class="modal-title" id="modalTitle" align="center">프로필 이미지</h5>
				</div>
				<div class="modal-body mb-3" style="padding: 20px 50px 0px 50px; " align="center">
					<div id="imageBox" class="mb-3" align="center" style="display:inline-block; width: 300px; height: 300px; margin:0 auto; overflow: hidden; border: 8px solid #F0F0F0; border-radius: 50%;">
						<img id='m_img' style='width:300px;'/>
					</div>
					<br>
					<div>
						<button type="button" id="addPhoto" class="addPhoto btn btn-outline-dark">프로필 사진 수정</button>
						<button type="button" id="deletePhote" class="addPhoto btn btn-outline-dark">프로필 사진 삭제</button><br>
						<input type="file" name="imagefile" id="imagefile" style="visibility: hidden;" >
					</div>
				</div>
				<div class="modal-footer" style="background: #F4F4F4; border: 2px solid #F4F4F4;">
					<button id="uploadProfileImageBtn" type="button" class="btn btn-dark" style="width: 200px; float:none; margin:0 auto;">수정</button>				
					<button id="cancelBtn" type="button" class="btn btn-secondary" style="width: 200px; float:none; margin:0 auto;">취소</button>				
				</div>
			</div>
		</div>
	</div>
	<!-- end Modal -->
	
<%@include file="../includes/footer.jsp"%>