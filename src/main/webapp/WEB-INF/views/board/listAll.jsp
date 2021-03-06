<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@include file="../includes/header.jsp"%>
<link href="/resources/css/button.css" rel="stylesheet">
<link href="/resources/css/boardTable.css" rel="stylesheet">
<link href="/resources/css/elements.css" rel="stylesheet">
<style>
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
	
	.dropleft .dropdown-toggle::before {
		content: none;
	}
	
</style>
<script type="text/javascript">
	$(function(){
		var c_no = $("#c_no").val();
		$("#insertBtn").on("click",function(){
			self.location = "/board/insert?c_no="+c_no;
		})
		
		if(!$("tbody tr").length){
			var div = $("<div style='color: gray; font-weight: bold;'></div>").html("작성된 글이 없습니다. 첫 글을 남겨보세요!");
			var td = $("<td style='height: 300px; vertical-align: middle;' colspan='6' align='center'></td>").append(div);
			$("tbody").append(td);
		}

		//페이징 관련 내용
		var actionForm = $("#actionForm");

		$(".paginate_button").on("click", function(e){
			//a태그 기본 속성 제거
			e.preventDefault();
			console.log("click");
			actionForm.find("input[name='pageNum']").val($(this).children("a").attr("href"));
			actionForm.submit();
		})

		//검색 관련 form
		var searchForm = $("#searchForm");

		$("#searchBtn").on("click", function(e){
			//if(!searchForm.find("option:selected").val()){
			//	alert("검색하고자 하는 분류를 선택해주십시오.");
			//	return false;
			//}
			if(!searchForm.find("input[name='keyword']").val()){
				alert("검색어를 입력해주십시오.");
				return false;
			}
			searchForm.find("input[name='pageNum']").val("1");
			e.preventDefault();

			searchForm.submit();
		});

		$("#allBoardBtn").on("click", function(e){
			e.preventDefault();
			self.location = "/board/listAll?categoryNum="+c_no;
		});

		//유저아이디 클릭할때 나오는 메뉴창
		//진탁) 0605
		$(".userNICK").click(function(e){
			var boardCnt;
			$(".dropdownMenu").empty();
		    var userID = $(this).attr("m_id");
		    var userData = {m_id:userID};
			//유저 아이디로 총 게시물 수를 구하는 ajax 통신
			$.ajax({
				url:"/board/userTotalBoard",
				type:"GET",
				data:userData,
				success:function(result){
					boardCnt = result;
					var user = $("<button class='dropdown-item disabled' type='button'></button>").text("아이디 "+ userID);
					var totalBoard = $("<button class='dropdown-item disabled' type='button'></button>").text("작성한글  "+ boardCnt);
					var line = $("<div class='dropdown-divider'></div>");
					var searchNICK = $("<button class='dropdown-item dropdownSearch' m_id="+userID+" type='button'></button>").text("작성글 검색");
					$(".dropdownMenu").append(user,totalBoard,line,searchNICK);
				}
			})
		})

		$(document).on("click",".dropdownSearch",function(e){
			var userID = $(this).attr("m_id");
			self.location = "/board/listAll?categoryNum="+c_no+"&c_no="+c_no+"&pageNum=1&amount=30&searchField=m_id&keyword="+userID;
			
		})
	})
	
</script>
	<div class="row">
		<div class="col">
			 <h2>애호글 전체 보기</h2>
		</div>
	    <!-- 게시물 인서트 -->
	</div>

	<div class="opacity-table">
	    <table class="table table-hover ">
	        <thead>
	            <tr align="center">
	                <th width="10%">번호</th>
	                <th width="15%">카테고리</th>
	                <th width="40%">제목</th>
	                <th width="20%">작성자</th>
	                <th width="15%">날짜</th>
	                <th width="10%">조회</th>
	                <th width="10%">Love</th>
	            </tr>
	        </thead>
	        <tbody>
	            <c:forEach items="${ list }" var="board" >
	               		<tr>
		                    <td align="center"><c:out value="${board.b_no }"/></td>
		                    <td align="center"><a href="/board/list?categoryNum=${ board.c_no }"><c:out value="${board.c_dist }"/></a></td>
		                    <td><a class="" href="/board/get?b_no=${board.b_no }"><c:out value="<span id='b_title'>${board.b_title}</span>" escapeXml="false"/><span class="badge badge-light">${board.b_replycnt }</span></a></td>
		                    <td align="center" style="overflow: visible;">
		                    	<c:if test="${board.m_img !=null}">
		                    		<div style="display: inline-block;">
		                    			<img width="30" height="30" src='/img/profileImg/${board.m_img }' style="border-radius: 50%;">
		                    		</div>
		                    	</c:if>
		                    	<div class="dropleft" style="display: inline-block;">
		                    		<a  href="#" m_id ="${board.m_id }" class="dropdown-toggle userNICK" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
		                    			<c:out value="${board.m_nick }"/>
		                    		</a>
		                    		<div class="dropdown-menu dropdownMenu">
	
									</div>
		                    	</div>
		                    </td>
		                    <td align="center"><fmt:formatDate pattern="yyyy-MM-dd" value="${board.b_date }"/></td>
		                    <td align="center"><c:out value="${board.b_hit }"/></td>
		                    <td align="center"><c:out value="${board.b_lovecnt }"/></td>
	                	</tr>
	            </c:forEach>
	        </tbody>
	    </table>
	    
	    <script>
      		var changeTitle = changeOutValue($("#b_title").val());
      		$("#b_title").val(changeTitle);
      	</script>
	    
	    <hr>
	    <!-- 게시물 검색 -->
	    <form id="searchForm" action="/board/listAll" method="get">
		    <div class="form-row align-items-center">
		    	    <input type="hidden" id="categoryNum" name="categoryNum" value="${ c_no }">
		    	    <input type="hidden" name="c_no" id="c_no" value="${c_no}">
			    	<input type="hidden" name="pageNum" id="pageNum" value="${pageMake.cri.pageNum}">
			    	<input type="hidden" name="amount" id="amount" value="${pageMake.cri.amount}">
		    	    <div class="col-sm-2 my-1">
		    	    	<select class="custom-select mr-sm-2" name="searchField">
				    		<option value="all" <c:out value="${ pageMake.cri.searchField eq 'all'?'selected':'' }"/>>전체</option>
				    		<option value="b_title" <c:out value="${ pageMake.cri.searchField eq 'b_title'?'selected':'' }"/>>제목
				    		<option value="b_content" <c:out value="${ pageMake.cri.searchField eq 'b_content'?'selected':'' }"/>>내용</option>
				    		<option value="doc" <c:out value="${ pageMake.cri.searchField eq 'doc'?'selected':'' }"/>>제목+내용</option>
				    		<option value="m_id" <c:out value="${ pageMake.cri.searchField eq 'm_id'?'selected':'' }"/>>작성자</option>
				    	</select>
		    	    </div>
					<div class="col-sm-6 my-1">
						<input type="text" class="form-control" id="keyword" name="keyword" value="${ pageMake.cri.keyword }">
					</div>
			    	
					<div class="col-sm-2 my-1">
						<button id="searchBtn" class="btn btn-outline-light mainBtn">검색</button>
					</div>
			    	
			    	<div class="col-sm-2 my-1">
			    		<button id="allBoardBtn" class="btn btn-outline-light float-right subBtn">전체글</button>
			    	</div>
		    </div>
	    </form>
		
	    <hr>
    </div>
    <!-- 페이징 -->
    <div class="float-right">
    	<ul class="pagination">
    		<c:if test="${pageMake.prev }">
				<li class="paginate_button previous">
					<a href="${pageMake.startPage -1 }">이전</a>
				</li>
				<li>&nbsp;</li>
			</c:if>
			
			<c:forEach var="num" begin="${pageMake.startPage }" end="${pageMake.endPage }">
				<li class="paginate_button ${pageMake.cri.pageNum==num ? "active": ""}">
					<a href="${num }">${num }</a>
				</li>
				<li>&nbsp;</li>
			</c:forEach>    		
			
			<c:if test="${pageMake.next }">
				<li class="paginate_button next">
					<a href="${pageMake.endPage+1 }">다음</a>
				</li>
			</c:if>
    	</ul>
    	<!-- 페이징 관련 a태그 속성 관리 -->
    	<form id="actionForm" action="/board/listAll" method="get">
    		<input type="hidden" name="pageNum" value="${pageMake.cri.pageNum }">
    		<input type="hidden" name="amount" value="${pageMake.cri.amount }">
    		<input type="hidden" name="categoryNum" value="${pageMake.cri.categoryNum }"> 
    		<input type="hidden" name="searchField" value="${ pageMake.cri.searchField }">   		
    		<input type="hidden" name="keyword" value="${ pageMake.cri.keyword }">    		
    	</form>
    </div>
    <!-- end 페이징 -->
	<br>

<%@include file="../includes/footer.jsp"%>  
