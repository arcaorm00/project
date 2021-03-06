<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="../includes/header.jsp"%>
<link href="/resources/css/button.css" rel="stylesheet">
<link href="/resources/css/boardTable.css" rel="stylesheet">
<link href="/resources/css/elements.css" rel="stylesheet">

	<h2>상품수정</h2>
	<form id="updateForm" method="post" enctype="multipart/form-data">
	<input type="hidden" id="g_no" name="g_no" value="${goods.g_no}">
	<table class="table table-bordered opacity-table">
		<tr>
			<td>상품 제목</td>
			<td><input type="text" id="g_title" name="g_title" required="required" value="${goods.g_title }"></td>
		</tr>
		<tr><!--  
			<td>삽니다/팝니다</td>
			<td><input type="number" name="gc_code" required="required" value="${goods.gc_code }"></td>
			-->
			<td>삽니다/팝니다</td>
			<td><select name="gc_code">
				<option value="0" disabled="disabled">=선택=</option>
				<option value="1" <c:if test="${goods.gc_code eq '1' }">selected</c:if>>팝니다</option>
				<option value="2" <c:if test="${goods.gc_code eq '2' }">selected</c:if>>삽니다</option>
			</select>
			</td>
		</tr>
		<tr>
			<td>작성자</td>
			<td><input type="text" name="m_id" readonly="readonly" value="${goods.m_id }"></td>
		</tr>
		<tr>
			<td>가격</td>
			<td><input type="number" name="g_price" required="required" value="${goods.g_price }"></td>
		</tr>
		<tr>
			<td>내용</td>
			<td><textarea id="g_content" class="text_content" name="g_content" rows="30%" cols="100%">${goods.g_content }</textarea></td>
		</tr>
	</table>
	<button type="submit" id="updateBtn" class="btn btn-outline-light mainBtn">수정</button>
	<button id="cancelBtn" class="btn btn-outline-light grayBtn">취소</button>
	</form>
	<script>
	//summernote 적용
	$(function(){
		var fileList = [];
		var uploadFileList = [];

		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		//이미지 파일 유효성 검사
		var imgCheck = new RegExp("^(image)/(.*?)");
		var maxSize = 10485760;
		
		$("#g_content").summernote({
			height: 700,
			minHeight:null,
			maxHeight:null,
			focus:true,
			lang:"ko-KR",
			placeholder:"본문 내용을 입력해주세요.",
			toolbar: [
			    ['style', ['style']],
			    ['font', ['fontsize','bold', 'italic', 'underline', 'clear']],
			    ['color', ['color']],
			    ['insert', ['picture','video']],
			    ['para', ['ul', 'ol', 'paragraph']],
			    ['table', ['table']]
			    
			 ],
			callbacks:{
				onImageUpload : function(files){
					$.each(files,function(idx,file){
						uploadSummernoteImageFile(file,$("#g_content"));
					})
				}	
			}
		})
		
		//파일
		function uploadSummernoteImageFile(file, editor) {
			data = new FormData();
			data.append("file", file);
			console.log(file);
			//이미지 파일인지에 대한 유효성 검사.
			if(!imgCheck.test(file.type)){
				alert("이미지 파일만 업로드 해주세요! ^3^");
				return false;
			}
			//이미지 파일 최대 용량에 대한 유효성 검사 최대 10mb로 제한
			if(file.size>maxSize){
				alert("파일의 용량이 너무 큽니다... -ㅅ-!");
				return false;
			}
			
			$.ajax({
				data : data,
				type : "POST",
				url : "/goods/testUpload",
				beforeSend: function(xhr){
					xhr.setRequestHeader(header,token)
				},
				contentType : false,
				processData : false,
				success : function(data) {
	            	//항상 업로드된 파일의 url이 있어야 한다.
					$(editor).summernote('insertImage', data.url);
					//리스트에 담기.
					fileList.push(data);
					console.log(fileList);
				}
			});
		}
		
		//클릭이벤트()
		$("#updateBtn").on("click",function(e){
			e.preventDefault();
 			var g_title = $("#g_title").val();
			var changeTitle = xssChange(g_title);
			$("#g_title").val(changeTitle);
			
			var myInsert = $("#updateForm").serialize();
			var date = new Date();
			var year = date.getYear()+1900;
			var month = date.getMonth()+1;
			if( month < 10 ) {
				month = "0"+month;
			}
			$.ajax({
				data : myInsert,
				type : "POST",
				beforeSend: function(xhr){
					xhr.setRequestHeader(header,token)
				},
				url : "/goods/update",
				success : function(goodsNum){
					console.log(goodsNum);
					if(goodsNum>0){
						$.each(fileList,function(idx,f){
							var url = f.url;
							var src = url.substring(12);
							var myUpload = {
								uuid : src.split("_")[0],
								filename : src.split("_")[1],
								g_no : goodsNum,
								uploadpath : "C:\\\aehoUpload\\goods\\"
							}
							uploadFileList.push(myUpload)
						})
						console.log(uploadFileList);
						$.ajax({
							data : JSON.stringify(uploadFileList),
							dataType : "json",
							beforeSend: function(xhr){
								xhr.setRequestHeader(header,token)
							},
							contentType:"application/json; charset=utf-8",
							type: "POST",
							url:"/goods/fileDBupload",
							success : function(msg){
								location.href="/goods/get?g_no="+goodsNum;
							}
						})
					}
				}
			})
		})

		$("#cancelBtn").click(function(e){
			e.preventDefault();
			location.href= "/goods/get?g_no="+$("#g_no").val();
		});
	})
	</script>
<%@include file="../includes/footer.jsp"%>