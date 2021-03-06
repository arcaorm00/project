<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>

<head>

<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>

</head>

    <meta charset="UTF-8">
    <!-- <meta name="viewport" content="width=device-width, initial-scale=1"> -->
    <title>AE-HO!</title>
    <!-- 글꼴 -->
    <link href="https://fonts.googleapis.com/css2?family=Poor+Story&display=swap" rel="stylesheet">
    <link href="/resources/css/main.css" rel="stylesheet">
    <link href="/resources/css/header.css" rel="stylesheet">
    <link href="/resources/css/elements.css" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
        integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">
	<!-- 페이징 때문에 넣어논거 충돌나서 다시 닫음. --> 
 	<!-- <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css"> -->  
    <!-- <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap-theme.min.css"> -->
<!-- 	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"> -->
  
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="/resources/js/js.js"></script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"
        integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous">
    </script>
  
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"
        integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous">
    </script>
    
    <!-- summer note -->
    <script src="../resources/editor/summernote-lite.js"></script>
	<script src="../resources/editor/lang/summernote-ko-KR.js"></script>
	<link rel="stylesheet" href="/resources/editor/summernote-lite.css">
	
	<!-- alert창 디자인 -->
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
	
	<!-- 날짜 포맷 변환 -->
	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>
	
	<style>
		.section{
			min-height: 800px;
		}
		.containerBox{
			margin: 50px 0px 100px 0px;
		}
        .headerIconDiv{
            margin-top: 20px;
        }
        #headerTop{
        	padding-top: 5px;
        	padding-bottom: 5px;
        }
		/*#customNav{
			padding-left:200px;
			padding-right: 200px;
        }	 */
		#topIcon{
			margin-right: 30px;
    		margin-bottom: 30px;
		}
		.topPick{
			padding: 12px 18px 12px 18px;
			margin: 10px;
			border: 1.5px solid #5FEAC9;
			border-radius: 50px;
			text-align: center;
			background: rgb(255,255,255,0.7);
			opacity: 0.9;
			display: inline-block;
			color: gray;
			transition: all ease 0.2s 0s;
		}
		
		.topPick:hover{
			cursor: pointer;
			background: linear-gradient(15deg, #a3a1fc, #5FEAC9);
			color: white;
		}
		
		#topPicksLabel{
			font-weight: bold;
			color: gray;
		}
		
		#serachIcon{
			width: 150px;
			color: white;
			border-bottom: 2px solid white;
			padding: 5px;
		}
		
		#serachIcon span{ float: left; }
		
		.dropdown-toggle::after {
			content: none;
		}
		
		.boardAlarm{
			background: #FFF4D1;
		}
		
		.goodsAlarm{
			background: #FFF4D1;
		}
		
		.checkAlarm{
			background: #F4F4F4;
		}
		
		#alarmList{
			padding: 10px;
			height: 300px;
			width: 400px;
		}
		.alarmListBox{
			overflow: auto;
			height: 280px;
		}
		.userAlarm{
			padding: 10px;
			margin-bottom: 10px;
		}
		
		#alarmIcon{
			border-radius: 50%;
			padding: 5px;
		}

    </style>
    <script>    
    $(function(){

		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");
		
    	var userID = " <sec:authorize access='isAuthenticated()'><sec:authentication property='principal.username'/></sec:authorize>";
        
		//각 분류별 카테고리를 호출하는 함수.
		var menuCategory = function(categoryInfo, key){
			console.log("함수 동작중");
			$("#"+key).empty();
			$.ajax("/menuCategory",{
				data: categoryInfo,
				success:function(data){
					console.log("ajax 통신");
					var menus = JSON.parse(data)
					$.each(menus,function(idx,menu){
						console.log(menu)
						
						var categoryName;
						if(menu.c_no > 11000 ){
							 categoryName = $("<a class='dropdown-item'></a>").text(menu.c_dist).attr("href","/qnaboard/list?categoryNum="+menu.c_no);
						}else{
							categoryName = $("<a class='dropdown-item'></a>").text(menu.c_dist).attr("href","/board/list?categoryNum="+menu.c_no);
						}

						var line = $("<div class='dropdown-divider'></div>");
						$("#"+key).append(categoryName,line);
					})
					
				}
			})
		}

			$("#brodMenu").click(function(e){
				var info = {startNum:1, endNum:100};
				var key = "bMenu";
				menuCategory(info,key);
			})
			
			$("#entMenu").click(function(e){
				var info = {startNum:101, endNum:200};
				var key = "eMenu";
				menuCategory(info,key);
			})
			
			$("#movieMenu").click(function(e){
				var info = {startNum:201, endNum:300};
				var key = "mMenu";
				menuCategory(info,key);
			})
			
			$("#gameMenu").click(function(e){
				var info = {startNum:301, endNum:400};
				var key = "gMenu";
				menuCategory(info,key);
			})
			
			$("#sportMenu").click(function(e){
				var info = {startNum:401, endNum:500};
				var key = "sMenu";
				menuCategory(info,key);
			})
			
			$("#qnaBoard").click(function(e){
				var info = {startNum:11001, endNum:12000};
				var key = "qBoard";
				menuCategory(info,key);
			})
			
			//검색
			$("#mainTotalSearch").on("click", function(){
				var search_keyword = $("#mainSearch").val();
				location.href="/search/search?keyword="+search_keyword;
			});

			$('#mainSearch').keypress(function(event){
			     if ( event.which == 13 ) {
			         $('#mainTotalSearch').click();
			         return false;
			     }
			});
			
			$('#searchModal').on('show.bs.modal', function (event) {
				$("#topPicksList").empty();
				$.ajax("/search/listPicks", {success: function(data){
					console.log(data);
					$.each(data, function(idx, p){
						var keyword = $("<div class='topPick'></div>").html(p.p_keyword);
						var a = $("<a></a>").attr("href", "/search/search?keyword=" + p.p_keyword);
						a.append(keyword);
						$("#topPicksList").append(a);
					});
				}});
			});

			
			$("#mypage").on("click",function(){
				var id = ($("#userId").html()).split(":")[1];
				console.log(id);
				location.href="/member/get?m_id="+id;
			})
			var isFooter = true;
			
			$(window).scroll(function() {
				var scrollBottom = $(window).scrollTop() + $(window).height();
				var footer_top = Math.ceil($('.footer').offset().top);
				//var topIcon_height = $("#topIcon").height();
				//var userManuHam_height = $("#userManuHam").height();

				var browser_height = window.innerHeight;
				var footer = document.getElementById('footer');
				var footer_rect = footer.getBoundingClientRect();
				//console.log(footer_rect.top +"/"+browser_height);

		        if ( scrollBottom >= footer_top ) {
		        	//console.log("userManuHam_height: "+userManuHam_height);
		        	
					$("#topIconBox").css({"bottom": browser_height - footer_rect.top + 10});
					$("#userManuHam").css({"bottom": browser_height - footer_rect.top + 10});
		        }else{
		        	$("#topIconBox").css({"bottom": 10});
					$("#userManuHam").css({"bottom": 10});
			    }
		        
		    });
			
			/*
			$("#userMenu").hide();
			$("#fixedMenu").on("click",function(e){
				if($("#userMenu").attr("class").indexOf("clickedUserMenu") == -1){
					$("#userMenu").slideToggle(500);
				}else{
					$("#userMenu").hide();
					$("#userMenu").removeClass(500);
				}
			})
			*/

			var alarm = function(data){
				$("#alarmList").empty();
				$.ajax({
					url: "/listAlarm",
					data: data,
					type: "GET",
					success: function(result){
						var alarmList = JSON.parse(result);
						console.log(data)
						var alarmListBox = $("<div class='alarmListBox'></div>");
						var alarmListContain = $("<div class='mr-2'></div>");
						$.each(alarmList, function(idx, alarm){
							var alarmTitle =$("<h5 class='pointer-cursor'></h5>");
							var div = $("<div class='userAlarm'></div>").attr("a_no",alarm.a_no);
							//1번 게시물인지 굿즈인지 판별
							if(alarm.g_no == null || alarm.g_no ==""|| alarm.g_no =="null"){
								div.addClass("boardAlarm");
								div.attr("b_no",alarm.b_no);
								$.ajax({
									url:"/getBoardTitle",
									data : {b_no:alarm.b_no},
									type : "GET",
									success : function(result){
										alarmTitle.text(result);
									}	
								})
							}
							
							if(alarm.b_no == null || alarm.b_no ==""|| alarm.b_no =="null"){
								div.addClass("goodsAlarm");
								div.attr("g_no",alarm.g_no);
								$.ajax({
									url:"/getGoodsTitle",
									data : {g_no:alarm.g_no},
									type : "GET",
									success : function(result){
										alarmTitle.text(result);
									}
								})
							}
							
							if(alarm.a_check == "YES"){
								div.addClass("checkAlarm");
							}

							var content = $("<div class='userAlarmContent'></div>").append(alarmTitle);
							var msg = $("<p></p>");
							var time = moment(alarm.a_time).format('YYYY-MM-DD HH:mm:ss');
							var date = $("<p class='mb-1'></p>").append(time);
							var clickID = alarm.clickid;
							if(alarm.ac_code == 1){
								msg.html(clickID+"님이 댓글을 달았습니다.");
							}
							if(alarm.ac_code==2){
								msg.html(clickID+"님이 좋아요를 눌렀습니다.");
							} 
							if(alarm.ac_code==3){
								msg.html(clickID+"님이 싫어요를 눌렀습니다.");
							}
							//var span = $("<span></span>").append(msg);
							
							content.append(msg,date);
							div.append(content);
							alarmListContain.append(div);
							alarmListBox.append(alarmListContain);
							
						});
						$("#alarmList").append(alarmListBox);
						
					}
				});

			}
			
			//알람기능
			$("#notificationDiv").click(function(){				
				var data = {m_id:userID};
				alarm(data);
			});

			
			var checkNewAlarm = function(data){
				$.ajax({
					url: "/listAlarm",
					data: {m_id:data},
					type: "GET",
					success: function(result){
						var list = JSON.parse(result);
						var count = 0;
						$.each(list, function(idx, alarm){
							if(alarm.a_check == "NO"){
								count = count + 1;
							}
						})
						if(count>0){
							$("#alarmImg").attr("src","/img/bell_new.png");
							$("#alarmCount").html(count);
						}
					}
				})
				
			}
			checkNewAlarm(userID);
			
			setInterval(function(){
				checkNewAlarm(userID);
			},3000);

			var updateCheck = function(no){
				var a_no = no;
				$.ajax({
					url: "/updateCheck",
					type: "POST",
					data: {a_no:a_no},
					beforeSend : function(xhr){
						xhr.setRequestHeader(header,token)
					},
					cache : false,
					success:function(result){
					}
				})
			}

			$(document).on("click",".boardAlarm",function(e){
				var b_no = $(this).attr("b_no");
				var a_no = $(this).attr("a_no");
				if($(this).attr('class').indexOf('checkAlarm')<=-1){
					updateCheck(a_no);
				}
				
				location.href="/board/get?b_no="+b_no;
				
			})
			$(document).on("click",".goodsAlarm",function(e){
				var g_no = $(this).attr("g_no");
				var a_no = $(this).attr("a_no");
				if($(this).attr('class').indexOf('checkAlarm')<=-1){
					updateCheck(a_no);
				}
				location.href="/goods/get?g_no="+g_no;
			})

		})
    </script>
</head>

<body>
    <!--header-->
    <div class="mb-0 p-3" id="headerTop" style="background-color: rgb(163, 161, 252);">
    	<div class="container">
            <div class="row">
            
            	<div class="col-sm nav-item dropdown" align="left">
            		<sec:authorize access="isAuthenticated()">            		
					<div id="notificationDiv" class="headerIconDiv ml-5 pointer-cursor nav-link dropdown-toggle" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
               			<p id="alarmIcon">
               				<img id="alarmImg" src="/img/bell.png" width="35px" height="35px">
               				<span class="badge badge-danger" id="alarmCount"></span>
               			</p>
                	</div>
                	</sec:authorize>
                	<div id="alarmList" class="dropdown-menu" aria-labelledby="navbarDropdown">		        				         	
					</div>
            	</div>
            
            	
                <div class="col-sm" align="center">
<!--                     <a href="/aeho">
                        <img src="/img/ma.png" width="200px" height="120px">
                    </a> -->
                    <a href="/aeho">
	                    <div class="sign">
	                    	<span class="fast-flicker">-</span>AE?HO!<span class="flicker">-</span>
				    		<!-- <span class="fast-flicker">Ae</span>?<span class="flicker">Ho</span>! -->
					    </div>

				    </a>
                </div>
                <div class="col-sm" align="right">
                	<div id="searchDiv" class="headerIconDiv">
                		<!-- <button type="button" class="btn btn-primary" > -->
                			<p id="serachIcon" data-toggle="modal" data-target=".bd-example-modal-lg">
                				<span>SEARCH</span>
                				<img src="/img/search_icon.png" width="20px" height="20px">
                			</p>
                		<!-- </button> -->
                	</div>
                </div>
            </div>
        </div>
    </div>
<%--<div class="mb-0" id="headerTop" style="background-color: rgb(163, 161, 252);">
    	<div class="container">
            <div class="row">
                <div class="col-3">
                    <a href="/aeho">
                        <img src="/img/ma.png" width="200px" height="120px">
                    </a>
                </div>
                <div class="col-6">
                	<form class="form-group">
                		<div class="input-group mt-5">
	                		<input type="text" class="form-control" id="mainSearch" placeholder="애호하는 것을 검색하세요!">
	                		<div class="input-group-append">
	                			<button type="button" id="mainTotalSearch">
			            	    	<img src="/img/search.png" width="20px" height="20px">
			              		</button>
	                		</div>
                		</div>
               	 	</form>
                </div>
         		<div class="col-3">
         			<div align="center" class="p-4">
         				<!-- side menu -->
						<input type="checkbox" id="menuicon">
						<label for="menuicon">
							<span></span>
							<span></span>
							<span></span>
						</label>
	         			<div>
	         				<sec:authorize access="hasRole('ROLE_MASTER')">
	         					<!-- <span class="badge badge-pill badge-warning">관리자가 로그인하였습니다.</span> -->
		         				<a href="/admin/admin" class="badge badge-pill badge-warning">관리자 페이지</a>
		         			</sec:authorize>
	         			</div>
						<div>
							<sec:authorize access="isAnonymous()">
								<br><br>
								<a href="/loginCustom" class="badge badge-light">로그인</a>
								<a href="/member/insert" class="badge badge-light">회원가입</a>
							</sec:authorize>
						</div>
						<div>
							<sec:authorize access="isAuthenticated()">
								<img src="/img/userICON.png" width="40" height="40" id="mypage"><br>
								<!-- 유저아이디 -->
								<span class="badge badge-pill badge-dark">
									<div id="userId">ID :<sec:authentication property="principal.username"/></div>
								</span>
								<a href="/logout" class="badge badge-light">로그아웃</a>   
							</sec:authorize>
						</div>
         			</div>

         		</div>
            </div>
        </div>
    </div> --%>
    <!--end header-->



    <!--menu -->
    <nav class="navbar justify-content-center" id="customNav" style="background-color: #D4F2F2">
    	<div>
	    	<div>
	            <ul class="nav">
	                <li class="nav-item"><a href="/main/notice?categoryNum=10000" class="nav-link text-secondary">공지사항</a></li>
	                <li class="nav-item"><a href="/board/listAll?categoryNum=9999" class="nav-link text-secondary">전체보기</a></li>
	                <li class="nav-item"><a href="/category/category" class="nav-link text-secondary">카테고리</a></li>
	                <li id="brodMenu" class="nav-item dropdown">
				        <a class="nav-link dropdown-toggle text-secondary" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				          	방송
				        </a>
				        <div id="bMenu" class="dropdown-menu" aria-labelledby="navbarDropdown">		        				         	
				        </div>
     				</li>
	                <li id="entMenu" class="nav-item dropdown">
				        <a class="nav-link dropdown-toggle text-secondary" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				          	연예
				        </a>
				        <div id="eMenu" class="dropdown-menu" aria-labelledby="navbarDropdown">		        				         	
				        </div>
     				</li>
	                <li id="movieMenu" class="nav-item dropdown">
				        <a class="nav-link dropdown-toggle text-secondary" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				          	영화
				        </a>
				        <div id="mMenu" class="dropdown-menu" aria-labelledby="navbarDropdown">			        				         	
				        </div>
     				</li>
	                <li id="gameMenu" class="nav-item dropdown">
				        <a class="nav-link dropdown-toggle text-secondary" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				          	게임
				        </a>
				        <div id="gMenu" class="dropdown-menu" aria-labelledby="navbarDropdown">		        				         	
				        </div>
     				</li>
	                <li id="sportMenu" class="nav-item dropdown">
				        <a class="nav-link dropdown-toggle text-secondary" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				          	스포츠
				        </a>
				        <div id="sMenu" class="dropdown-menu" aria-labelledby="navbarDropdown">			        				         	
				        </div>
     				</li>
	                <li class="nav-item"><a href="/goods/list" class="nav-link text-secondary">굿즈</a></li>
	                <li class="nav-item"><a href="/vote/vote" class="nav-link text-secondary">투표</a></li>
	                <li id="qnaBoard" class="nav-item dropdown">
				        <a class="nav-link dropdown-toggle text-secondary" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				          	Q&A
				        </a>
				        <div id="qBoard" class="dropdown-menu" aria-labelledby="navbarDropdown">			        				         	
				        </div>
     				</li>
	            </ul>
	        </div>
    	</div>
    </nav>
    <!--end menu -->
	
	<a id="topIconBox" style = "display:scroll; position:fixed; bottom:10px; right:10px; z-index: 1000" href="#" title="맨위로">
		<img width=60 height=60 id='topIcon' src="/img/topIcon2.png">
	</a>

	<div id="userManuHam" style="position: fixed; bottom: 10px; left: 10px; z-index: 1000">
		<!-- side menu -->
		<div style="margin-left: 30px; margin-bottom: 30px;">
			<!-- 
			<div id="userMenu" class="">
				<div id="login_out" class="userMenuBtn mb-1">로그인</div>
				<div id="login_out" class="userMenuBtn mb-1">마이페이지</div>
			</div>
			-->
			<div class="row">
				<div class="col">
					<div class="collapse" id="collapseBox">
						<div id="userMenu">
							<sec:authorize access="hasRole('ROLE_MASTER')">
	         					<!-- <span class="badge badge-pill badge-warning">관리자가 로그인하였습니다.</span> -->
		         				<div id="admin_page" class="userMenuBtn" onclick="location.href='/admin/admin'">관리자 페이지</div>
		         			</sec:authorize>
							<sec:authorize access="isAnonymous()">
								<div id="login" class="userMenuBtn" onclick="location.href='/loginCustom'">로그인</div>
								<div id="sign_up" class="userMenuBtn" onclick="location.href='/member/insert'">회원가입</div>
							</sec:authorize>
							<sec:authorize access="isAuthenticated()">
								<div id="my_page" class="userMenuBtn mb-1" onclick="location.href='/member/mypage'">
									<img src="/img/userICON.png" width="30" height="30" id="mypageImg">
									<span id="userId"> <sec:authentication property="principal.username"/></span>
								</div>
								<div id="logout" class="userMenuBtn mb-1" onclick="location.href='/logout'">로그아웃</div>
							</sec:authorize>
							<sec:authorize access="isAuthenticated()">
	         					<div id="chat_page" class="userMenuBtn" onclick="location.href='/room'">채팅</div>
		         			</sec:authorize>
							
							<!-- <div id="login_out" class="userMenuBtn mb-1">로그인</div>
							<div id="mypage" class="userMenuBtn mb-1">마이페이지</div> -->
						</div>
					</div>
				</div>
			</div>
			
			<div id="fixedMenu" data-toggle="collapse" href="#collapseBox" role="button" aria-expanded="false" aria-controls="collapseBox">
				<input type="checkbox" id="menuicon">
				<label for="menuicon">
					<span></span>
					<span></span>
					<span></span>
				</label>
			</div>
			
		</div>
	</div>


	<!-- Modal -->
	<div class="modal fade bd-example-modal-lg" id="searchModal" tabindex="-1" role="dialog"
		aria-labelledby="myLargeModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content p-5 searchModal-content" align="center">
 				<div class="serachBox">
					<!-- <h1 id="serachBoxH1">Search</h1> -->
					<br>
					<form>
						<input type="text" id="mainSearch"  name="" placeholder="AE-HO하는 것을 검색해주세요!">
						<input id="mainTotalSearch" name="" value="Search">
					</form>
					<br><br><br>
					<div>
						<h5 id="topPicksLabel" class="mb-3">인기검색어</h5>
					</div>
					<div id="topPicksList"></div>
				</div>
			</div>
		</div>
	</div>
	<!-- end Modal -->
	
    <!--content-->
    <div class="container pt-3 section">
    	<div class="containerBox">
    