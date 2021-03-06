<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="../includes/header.jsp"%>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.5.0.min.js"></script>
<link href="/resources/css/button.css" rel="stylesheet">
<link href="/resources/css/boardTable.css" rel="stylesheet">
<link href="/resources/css/elements.css" rel="stylesheet">

<script type="text/javascript">

var c_no;
var keyword;
var gc_code=0;
var searchKeyword;
var searchField;

var dto;

function listGoods(gc_code,keyword,pageNum,searchField,searchKeyword){
	//	c_no를 강제로 넣어주기 위해 카테고리 설정시에만 글쓰기 버튼 보이게 / 검색을 위해 searchKeyword 추가
	if(keyword == null || gc_code == null){
		$("#insertBtn").css("visibility","hidden");
	}
	else{
		$("#insertBtn").css("visibility","visible");
	}
	
	
	$("#goodsList").empty();
	
	$.ajax("/goods/listGoods",{data:{gc_code:gc_code,keyword:keyword,pageNum:pageNum,searchField:searchField,searchKeyword:searchKeyword}, success:function(result){
	//리스트 가져오기
		var list = JSON.parse(result.list)
		$.each(list, function(idx,item){

			var g = item;

			var changeTitle = changeOutValue("g_title: " +g.g_title);
			console.log("changeTitle"+changeTitle);
			
			var div = $("<div class='goodsBox mb-5'></div>");
			var con = g.g_content;
			var image = $("<img></img>");
			$.ajax("/goods/listFileByGno", {data: {g_no: g.g_no}, success: function(result){
				var list = JSON.parse(result);
				console.log(list);
				if(result!="null"){
					var gf = list[0];
					console.log("파일 있음")
					var src = "/goodsImage/"+gf.uuid+"_"+gf.filename;
					image.attr("src", src).addClass("rounded goodsImg mb-3");
				}else{
					console.log("파일 없음")
					image.attr("src","/img/no_image.png").addClass("rounded goodsImg mb-3");
				}
			}});
			
			/*
			if(con.indexOf("<img src=") != -1){
				img = $(con.substring(con.indexOf("<img src="), con.indexOf("style"))+"></img>").addClass("rounded goodsImg mb-3");
			}else{
				img = $("<img src='/img/no_image.png' class='rounded goodsImg mb-3'></img>");
			}
			*/
		
			var gc_dist = $("<small class='text-muted'></small>");
			if(g.gc_code == 1)
				gc_dist.html("[팝니다] ");
			else
				gc_dist.html("[삽니다] ");
			
			var title = $("<b></b>").html(g.g_title);
			var writer = $("<p class='mb-2'></p>").html(g.m_nick);
			var price = $("<p class='mb-2'></p>").html(g.g_price + "원");
			var g_date = moment(item.g_date).format('YYYY-MM-DD');
			var date = $("<p></p>").html(g_date);
			//var replyCnt = $("<span class='badge badge-light'></span>").html(g.g_replycnt);
			
			var a = $("<a></a>").attr("href","/goods/get?g_no="+g.g_no).append(title);
			var img_a = $("<a></a>").attr("href","/goods/get?g_no="+g.g_no).append(image);
			var li = $("<li></li>").append(img_a, "<br>", gc_dist, a, "&nbsp;", writer, price, date);
			div.append(li);
			$("#goodsList").append(div);
			
			
			/*
			//상품번호,제목,코드,가격,날짜
			var td1=$("<td align='center'></td>").html(item.g_no);
			var td2=$("<td align='center'></td>").html(gc_dist);
			//var a=$("<a>"+item.g_title+"["+item.g_replycnt+"]"+"</a>").attr("href","/goods/get?g_no="+item.g_no)
			var a=$("<a>"+item.g_title+"</a>").attr("href","/goods/get?g_no="+item.g_no)
			var replyCnt=$("<span class='badge badge-light'></span>").html(item.g_replycnt)
			a.append(replyCnt);
			var td3=$("<td></td>").html(a);
			//console.log("닉:"+item.m_nick)
			var td4=$("<td align='center'></td>").html(item.m_nick);
			var td5=$("<td align='center'></td>").html(item.g_price);
			
			
			
			var td6=$("<td align='center'></td>").html(g_date);
			var tr = $("<tr></tr>").append(img, td1,td2,td3,td4,td5,td6);
			$("#tb").append(tr);
			*/
		});
	
		//페이징
		dto=result.dto;
		
		$(".pagination").empty();
		if(dto.prev){
			var a=$("<a>이전</a>").attr("href","#");
			var li = $("<li class='paginate_button btn btn-outline-light previous'></li>").append(a);
			$(li).on("click",function(){
				listGoods(gc_code,keyword,(dto.startPage)-1, searchField, searchKeyword);
			})
			var nbsp=$("<li>&nbsp;/&nbsp;</li>");
			$(".pagination").append(li,nbsp);
		}
		for(i=dto.startPage; i<=dto.endPage; i++){
			var a=$("<a class='pageNum'>"+i+"</a>").attr("href","#");
			var li=$("<li class='paginate_button btn btn-outline-light'></li>").attr("id", "goodsPage"+i).append(a);
			$(li).on("click",function(){
				listGoods(gc_code,keyword,$(this).children("a").html(), searchField, searchKeyword);
			})
			var nbsp=$("<li>&nbsp;</li>");
			$(".pagination").append(li,nbsp);
		}
		if(dto.next){
			var a=$("<a>다음</a>").attr("href","#");
			var li = $("<li class='paginate_button btn btn-outline-light next'></li>").append(a);
			$(li).on("click",function(){
				listGoods(gc_code,keyword,(dto.endPage)+1, searchField, searchKeyword);
			})
			$(".pagination").append(li);
		}

		var presentPage = dto.cri.pageNum; //현재 페이지
		console.log(presentPage);
		$("#goodsPage"+presentPage).addClass("active");
	}})
}

$(function(){

   var member = $("#member").val();

   $.ajax("/category/goodsCateList",{success:function(result){
//      console.log(result)
      var b=$("<button id='tot' class='btn btn-outline-light mr-2 list-mintBtn list-mintBtnActive'></button>").html('전체보기');
      $(b).on("click",function(){
    	  $(".list-mintBtn").removeClass("list-mintBtnActive");
    	  $(this).addClass("list-mintBtnActive");
    	  var nokey;	//keyword에 null을 넣어주기 위한 변수 (null로 대입하면 적용안됨)
    	  keyword=nokey;
    	  listGoods(gc_code,keyword,1,searchField,searchKeyword);
      })
      $("#goodsType").append(b);
      result=JSON.parse(result);
      $.each(result,function(idx,item){
         var c_dist= $("<button type='button' class='btn btn-outline-light list-mintBtn'></button>").html(result[idx].c_dist);
         var nbsp="  ";
         $("#goodsType").append(c_dist,nbsp);
         $(c_dist).on("click",function(){
            $(".list-mintBtn").removeClass("list-mintBtnActive");
            keyword=$(this).text();
            c_no=result[idx].c_no;
            $(this).addClass("list-mintBtnActive");
            listGoods(gc_code,keyword,1,searchField,searchKeyword);
         })
      })
      
   }})
   $("#insertBtn").on("click",function(){
//      console.log(c_no);
      self.location = "/goods/insert?c_no="+c_no+"&gc_code="+gc_code;
   })
   $(".typeBtn").on("click",function(){
	   $(".typeBtn").removeClass("typeBtnActive");
		var noCode;
	   $(this).addClass("typeBtnActive");
		if($(this).val()==0)
			gc_code= noCode;
		else
			gc_code = $(this).val();
		console.log(gc_code,keyword,searchKeyword,searchField);
		listGoods(gc_code,keyword,1,searchField,searchKeyword);
	})
	//검색처리
	$("#searchBtn").on("click", function(e){
		e.preventDefault();
		searchKeyword = $("#searchKeyword").val();
		searchField = $("#searchField").val();
		console.log(searchKeyword, searchField);
		
		listGoods(gc_code,keyword,1,searchField,searchKeyword);
	});

   $("#allBoardBtn").on("click", function(e){
		e.preventDefault();
		self.location = "/goods/list";
	});

   if(typeof member == "undefined" || member == 'null' || member == ""){
	   listGoods(0);
	}else{
		
		$("#goodsList").empty();
		$("#searchKeyword").val(member);
		$("#searchField").val("m_id");
		//listGoods(0,"",1,"m_id",member);
		$("#searchBtn").click();
		
	}
	
})
</script>
	<input type="hidden" id="member" value=<%= request.getParameter("member") %>>
	
	<h2>상품목록</h2><div id=state></div>
	<p>상품 등록을 원하시면 카테고리를 선택해주세요.</p>
	<hr>
	
	<button id="allBtn" type="button" class="btn btn-outline-light typeBtn typeBtnActive" value="0">전체보기</button>
	<button id="buyBtn" type="button" class="btn btn-outline-light typeBtn" value="2">삽니다</button>
	<button id="sellBtn" type="button" class="btn btn-outline-light typeBtn" value="1">팝니다</button>
	<br><br>
	
	<div>
		<div id="goodsType" style="display: inline-block;">
			<h4>상품 종류별 보기</h4>
		</div>
		<div style="display: inline-block; float: right;">
			<button id="insertBtn" type="button" class="btn btn-outline-light mainBtn">상품등록</button>
		</div>
	</div>
	<hr>
	<div id="goodsDiv" class="goodsDiv" align="center">
		<ul id="goodsList" class="mt-5 goodsList">

		</ul>
	</div>
	<!--  
	<table class="table table-hover">
	   <thead>
	      <tr align="center">
	         <td width="10%">상품번호</td>
	         <td width="10%">구분</td>
	         <td width="50%">제목</td>
	         <td width="10%">작성자</td>
	         <td width="10%">가격</td>
	         <td width="10%">날짜</td>
	      </tr>
	   </thead>
	   <tbody id="tb">
	      
	   </tbody>
	</table>
	-->
	<hr>
	<!-- 게시물 검색 -->
	<form id="searchForm" method="get">
	    <div class="form-row align-items-center">
	    	    <input type="hidden" id="categoryNum" name="categoryNum" value="${ c_no }">
	    	    <input type="hidden" name="c_no" id="c_no" value="${c_no}">
		    	<input type="hidden" name="pageNum" id="pageNum" value="${pageMake.cri.pageNum}">
		    	<input type="hidden" name="amount" id="amount" value="${pageMake.cri.amount}">
	    	    <div class="col-sm-2 my-1">
	    	    	<select id="searchField" class="custom-select mr-sm-2" name="searchField">
			    		<!-- <option value="all" class="sf">전체보기</option>-->
						<option value="g_title" class="sf">제목</option>
						<option value="g_content" class="sf">내용</option>
						<option value="m_id" class="sf">작성자</option>
						<option value="doc" class="sf">제목+내용</option>
			    	</select>
	    	    </div>
				<div class="col-sm-6 my-1">
					<input type="text" class="form-control" id="searchKeyword" name="searchKeyword" value="${ pageMake.cri.keyword }">
				</div>
		    	
				<div class="col-sm-2 my-1">
					<button id="searchBtn" class="btn btn-outline-light mainBtn">검색</button>
				</div>
		    	
		    	<div class="col-sm-2 my-1">
		    		<button id="allBoardBtn" class="btn btn-outline-light float-right subBtn">전체글</button>
		    	</div>
	    </div>
    </form>
    
    <!-- 
	<select id="searchField">
		<option value="all" class="sf">전체보기</option>
		<option value="g_title" class="sf">제목</option>
		<option value="g_content" class="sf">내용</option>
		<option value="m_id" class="sf">작성자</option>
		<option value="doc" class="sf">제목+내용</option>
	</select>
	<input type="text" id="searchKeyword" name="searchKeyword">
	<button id="searchBtn" class="btn btn_outline-dark">검색</button>
	-->
	<hr>
	 <!-- 페이징 -->
	<div class="float-right">
		<ul class="pagination">
			
		</ul>
	</div>
	<!-- paging end -->
	
<%@include file="../includes/footer.jsp"%>