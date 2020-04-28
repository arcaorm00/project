<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.5.0.min.js"></script>
<script type="text/javascript">
$(function(){
	$("#insertBtn").on("click",function(){
		self.location = "/goods/insert";
	})
})
</script>
	<h2>상품목록</h2>
	<hr>
	<table>
		<thead>
			<tr>
				<td>상품번호</td>
				<td>제목</td>
				<td>코드</td>
				<td>가격</td>
				<td>날짜</td>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${list }" var="goods">
				<tr>
					<td><c:out value="${goods.g_no }"></c:out></td>
					<td><a href="/goods/get?g_no=${goods.g_no }"><c:out value="${goods.g_title }"></c:out></a></td>
					<td><c:out value="${goods.gc_code }"></c:out></td>
					<td><c:out value="${goods.g_price }"></c:out></td>
					<td><c:out value="${goods.g_date }"></c:out></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<button id="insertBtn">상품등록</button>
	<hr>
</body>
</html>