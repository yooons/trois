<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!Doctype html>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<link rel="stylesheet" href="resources/css/myroom.css">
<link rel="stylesheet" href="resources/css/okquestion.css">
<title>Trois</title>
<style>
.center-right .ul-head li {
	margin: 0;
	padding-top: 35px;
	font-size: 20px;
	text-align: center;
	width: calc((100% / 6) - 7px);
	height: 50px;
	display: inline-block;
	float: left;
	border-bottom: 1px solid green;
	border-right: 1px solid green;
}

.center-right .ul-body li {
	margin: 0;
	padding-top: 16px;
	font-size: 20px;
	text-align: center;
	width: calc((100% / 6) - 7px);
	height: 50px;
	display: inline-block;
	float: left;
	border-bottom: 1px solid green;
	border-right: 1px solid green;
	cursor: pointer;
}
.button-list button.chk {
    color: #ece4d7;
    background-color: #262522;
}
.button-list button:hover {
    background-color: #656565;
    color: #f8edde;
}
</style>
<script>
	$(document).ready(function() {
		var data = []; // 데이터 담을 배열 변수 선언
		var page = 1; // 현재 페이지 값
		var viewRow = 10; // 화면에 보여질 행 갯수
		var totCnt = 0;
		
		var pageGroup = 1; // 현재 페이지 값
		var pageView = 5; // 페이징 버튼 객수
	
		var no = "";
		var index = "";
		var title = "";
		var contents = "";
		var answer = "";
			
		$("#logout").on("click", function(){
	    	location.href = "logout";
	    });
		
		$("#logo").on("click", function(){
			location.href = "main";
		});
		
		function createHtml() { // ul(부모) 태그 속에 li(자식) 태그 넣기 위한 함수
			$(".ul-body").empty(); // ul 태그의 자식들를 초기화가 필요하다.
			for(var i = 0; i < data.length; i++) {
				var tag = '<ul>'
				tag += '<li>' + (i + 1) + '</li>';
				tag += '<li>' + data[i].title + '</li>';
				tag += '<li>' + data[i].contents + '</li>';
				tag += '<li>' + data[i].date + '</li>';
				tag += '<li>';
				if (data[i].answer != null) {
					tag += data[i].answer;
				} else {
					tag += ' ';
				}
				tag += '</li>';
				tag += '<li>';
				if (data[i].answer == null) {
					tag += ' ';
				} else {
					tag	+= data[i].answercheck;
				}
				tag += '</li>';
				tag += '</ul>';
				$(".ul-body").append(tag);
			}
			 if(data.length < 1){
                var tag = "<ul style='text-align:center;'>문의한 내역이 없습니다.</ul>";
                $(".ul-body").append(tag);
       		} 
			detail();
		}

		function createPaging() {
			var paging = totCnt / viewRow;
			// 총 갯수 / 보여지는 갯수
			// 전체 행의 수 / 화면에 보여질 행 갯수 => 총 데이터 수  / 한 페이지당 보여질 행 갯수  102 / 10 = 10  페이지 갯수 11개
			// 전체의 행의 수에서 보여줄 행을 나누면 페이지의 갯수를 알 수 있다.
			
			var end = (pageView * pageGroup); // 5 * 1 = 5;
			var start = (end - pageView); // 5 - 5 = 0;

			if(paging < end){
				end = paging;
		    }

			$(".button-list").empty(); // div 태그 속에 a 태그를 초기화 한다.
			var k = 0;
			
			if(end > pageView){
				$(".button-list").append("<button type='button' id ='#myqna" + ((start+1) - pageView) + "'>&lt;</button>")
				k = 1;
			}       
	       	for(var i = start; i < end; i++){
	       		$(".button-list").append("<button type='button' id ='#myqna" + (i + 1) + "'>" + (i + 1) + "</button>");
	       		if(page == (i + 1)){
	            $(".button-list button").eq(k).addClass("chk");
	        }
	          	k++;
	        }
	       
	        if(end >= pageView && paging > end){
	        	$(".button-list").append("<button type='button' id ='#myqna" + (end + 1) + "'>&gt;</button>");
	        }
			$(".button-list button").off().on("click", function() { // 페이지 전환 이벤트를 작성 한다.
				// a 태그 중에 몇번째 페이지인지 알면 리스트 화면를 다시 보여 줄 수 있다. page 변수 활용 할것!
				page = $(this).text(); // 선택한 페이지의 text 추출
				location.hash = $(this).attr("id");
				if(page == ">"){
				   page = (pageGroup * pageView) + 1; 
				   pageGroup++;
				}else if(page == "<"){
				   page = (((pageGroup - 1) * pageView) - 4);
				   pageGroup--;
				}
				setTimeout(function() {
					initData(); // 디비에서 데이터 다시 가져 오기 위하여 함수 호출
				}, 100); // 타이머가 완료된 뒤 지정 함수가 실행 됨
			});
		}

		function initData() { // 디비에서 데이터 가져오기 위한 함수
			var hash = location.hash; // a 태그의 이벤트로 발생한 hash 값을 가져온다.
			if (hash != "") { // hash 값이 있을 경우 page 변수의 값으로 사용한다.
				page = hash.substr(6, hash.length);
				pageGroup = Math.ceil(page / pageView);
			}

			var end = (viewRow * page); // 10 * 2 = 20
			var start = (end - viewRow); // 20 - 10 = 10
			$.ajax({
				type : "post", // post 방식으로 통신 요청
				url : "myqnaData", // Spring에서 만든 URL 호출
				data : {"start" : start, "viewRow" : viewRow} // 파라메터로 사용할 변수 값 객체 넣기
			}).done(function(d) { // 비동기식 데이터 가져오기
				var result = JSON.parse(d); // 가져온 데이터를 JSON 형식으로 형변환 하여 result 변수에 담기.
				data = result.data; // JSON으로 받은 데이터를 사용하기 위하여 전역변수인 data에 값으로 넣기
				totCnt = result.totCnt.tot;
				createHtml(); // 화면에 표현하기 위하여 함수 호출
				createPaging(); // 페이지 링크 표현하기 우하여 함수 호출
			}).fail(function(d, s, x) {
				alert("fail");
			})
		}
		initData();
		
		function detail(){
			$(".ul-body ul").on("click",function(){
				if(data.length < 1){
					return false;
				}else{
					index = $(".ul-body ul").index(this);
					no = data[index].no;
					title = data[index].title;
					contents = data[index].contents;
					answer = data[index].answer;
				}
				$.ajax({
					type : "post", // post 방식으로 통신 요청
					url : "myqnaDetail", // Spring에서 만든 URL 호출 
					data : {"no" : no, "title": title, "contents": contents, "answer": answer} // 파라메터로 사용할 변수 값 객체 넣기
				}).done(function(d) { // 비동기식 데이터 가져오기
					var result = JSON.parse(d); // 가져온 데이터를 JSON 형식으로 형변환 하여 result 변수에 담기.
					data = result.data;
					title = data[0].title;
					contents = data[0].contents;
					answer = data[0].answer;
					if(answer == null){
						answer = "답변 내용이 없습니다.";
					}
					detailCreate();
					}).fail(function(d, s, x) {
					alert("fail");
				})
			});
		}
		
		function detailCreate(){
			var content = '<div id="mainBox"><div id="subBox1"><div id="textBox1"><p>'
			+ '제목</p></div><div id="reqBox1"><p id="reqText1">' + title + '</p></div></div><div id="subBox2">'
            + '<div id="textBox2"><p>문의 내용</p></div><div id="reqBox2"><p id="reqText2">' + contents + '</p>'
			+ '</div></div></div><div id="mainBox2"><div id="subBox3"><div id="textBox3"><p>답변</p></div>'
            + '<div id="reqBox3"><p id="reqText3">' + answer + '</p></div><div id="submit">'
            + '<button type="button" id="backBtn">돌아가기</button></div></div></div>';
            
            $(".center-right").empty();
            $(".center-right").addClass('mainContent');
            $(".mainContent").removeClass('center-right');
            $(".mainContent").append(content);
            
            $('#reqBox2').html($('#reqText2').html().replace(/\n/g,"<br>"));
            $('#reqBox3').html($('#reqText3').html().replace(/\n/g,"<br>"));
            
            $("#backBtn").off().on("click", function(){
            	location.reload(true);
            });
		}
	});
</script>
</head>
<body>
	<div class="trois">
		<div class="header">
			<div class="header-left">
				<img id="logo" src="resources/logo/logo.png">
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
				<ul>
					<li><a href="myroom">마이룸</a></li>
					<li><a href="question">문의하기</a></li>
					<li><a href="myqna" style="text-decoration: underline;">나의문의내역</a></li>
					<li><a href="modify">회원정보수정/탈퇴</a></li>
					<li><a href="work">작업시작하기</a></li>
				</ul>
			</div>
			<div class="center-right">
				<div class="ul-head">
					<ul>
						<li>순서</li>
						<li>제목</li>
						<li>내용</li>
						<li>날짜</li>
						<li>답변</li>
						<li>답변 체크</li>
					</ul>
				</div>
				<div class="ul-body">
				</div>
				<div class="button-list">
				
				</div>
			</div>
		</div>
		<div class="footer">
			<footer>
				상호 : Trois(주)<br> 장소 : 서울특별시 금천구 대륭테크노타운 3차 811호<br>
				 대표이사 : 공은비 김보경 김원중 박기윤 최승환 <br> Copyright (c) 2017 Trois all rights
				reserved. Trois는 안전하게 운영중입니다.
			</footer>
		</div>
	</div>
</body>
</html>