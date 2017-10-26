<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
 	HashMap<String, Object> questionSelect = (HashMap<String, Object>) request.getAttribute("qnaSelect");
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="/trois/resources\css\answer.css">
<title>answer</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
<script>
$(document).ready(function(){
	var answer = "";

	$('#reqBox2').html($('#reqText2').html().replace(/\n/g,"<br>"));
	
	$("#inputText").keydown(function(){
		var numChar = $(this).val().length;
		var maxNum = 50;
		var charRemain = maxNum - numChar;
		$("#textSpan > em").text(charRemain);
		
			if(charRemain < 0){
				$("#submitBtn").prop("disabled", true);
			} else {
				$("#submitBtn").prop("disabled", false);
			}
	});
	
	$("#submitBtn").on("click", function(){
		initData();
		createqna();
	});
	
	function createqna(){
		$("#inputBox").empty(); 
		$("#submit").empty();
		
		$("#inputBox").append("<p id='reqText3'>" + answer + "</p>");
		$("#submit").append("<button type='button' id='backBtn'>돌아가기</button>");
 		$('#inputBox').html($('#reqText3').html().replace(/\n/g,"<br>"));
	}
	
	function initData(){
			answer = $("#inputText").val();
			
			$.ajax({
				type:"post", // post 방식으로 통신 요청
				url:"/test/answerRead", // test에서 만든 URL 호출
				data:{"answer": answer} // 파라메터로 사용할 변수 값 객체 넣기
				}).done(function(d){ // 비동기식 데이터 가져오기
			var result = JSON.parse(d); // 가져온 데이터를 JSON 형식으로 형변환 하여 result 변수에 담기.
			});
		}
	
});
</script>
</head>
<div class="trois">
            <div class="header">
                <div class="header-left">
                    <h1>logo</h1>
                </div>
                <div class="header-center">
                    <h1>Trois</h1>
                </div>
                <div class="header-right">
                    <button id="logout">로그아웃</button>
                </div>
            </div>
            <div class="center">
                <div class="center-left">
                    <p id="ad">관리자 페이지</p>
                    <ul>
                        <li><a href="#">문의내역</a></li>
                    </ul>
                </div>
                <div id="mainContent">
                    <div id="mainBox">
                            <div id="subBox1">
                                <div id="textBox1">
                                    <p>제목</p>
                                </div>
                                <div id="reqBox1">
                                    <p id="reqText1"><%= questionSelect.get("title") %></p>
                                </div>
                            </div>
                        <div id="subBox2">
                            <div id="textBox2">
                                <p>문의 내용</p>
                            </div>
                            <div id="reqBox2">
                                <p id="reqText2"><%= questionSelect.get("contents") %></p>
                            </div>
                        </div>
                    </div>
                    <form action="" method="post">
                        <div id="mainBox2">
                            <div id="subBox3">
                                <div id="textBox3">
                                    <p>답변</p>
                                </div>
                                <div id="inputBox">
                                    <textarea id="inputText" name="answer" placeholder="내용을 입력하세요"></textarea>
                                    <span id="textSpan"><em>50</em> / 50</span>
                                </div>
                                <div id="submit">
                                    <input type="submit" id="submitBtn" value="확인">
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <div class="footer"><footer>copyright</footer></div>
        </div>
</html>