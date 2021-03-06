<%@page import="java.util.HashMap"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.List"%>
<%@page import="data.dao.OrderDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src='https://kit.fontawesome.com/a076d05399.js'></script>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
<title>Insert title here</title>
<style type="text/css">
body{
font-family: 'Noto Sans KR', Arial, sans-serif;
}
.ordlistall{
	margin: auto;
	width: 1100px;
	margin-top: 30px;
}
.ordlist .ordlthead tr th{
	text-align: center;
	background-color: #f6c244;
}
.ordlist .ordlthead tr{
	height: 50px;
}
.ordlist .ordltbody tr{
	height: 150px;
	border-bottom: 1px solid #ddd;
}
.ordlist .ordltbody tr td{
	vertical-align: middle;
}
.ordlist .ordltbody tr td .ordlmenu{
	margin-left: 30px;
}
.ordlist .ordltbody tr td .ordlphoto{
	width: 120px;
	height: 120px;
	margin-right: 30px;
}
.orddel{
	font-size: 24px;
	color: #bbb;
	cursor: pointer;
}
#ordlr{float: right;}
#allp{font-size: 27px; float: left; margin-right: 30px;}
.ordlbtn{float: left;}

.img-cover{position: absolute;height: 100%;width: 100%;background-color: rgba(0, 0, 0, 0.4);z-index:1;}
.sub_visual .txt{position: absolute;top:50%;left:50%;transform: translate(-50%, -50%);color: white;z-index: 2;text-align: center;}
.sub_visual .txt h1:after{display:block;width:40px;height:3px;margin:32px auto;background:white;content:'';}
.sub_visual .txt p{font-size: 14pt; font-weight: 300;}
.sub_visual{position: relative;background-image: url(./image/coffee-5132832_1920.jpg);height: 400px;background-size:cover;background-position:center;

</style>
<script type="text/javascript">
$(function(){
	$("#allcheck").click(function(){
		var a=$(this).is(":checked");
		if(a){
			$(".ordernum").prop("checked",true);
		}else{
			$(".ordernum").prop("checked",false);
		}
	});
	
	$("div.ordlmenu").click(function(){
		var menunum=$(this).attr("menunum");
		location.href="index.jsp?main=order/orderpage.jsp?menunum="+menunum;
	});
	
	//?????????????????? ?????? ?????????
	$("#btnorddel").click(function(){
		//????????? ?????? ?????? ?????????
		var cnt = $(".ordernum:checked").length;
		if(cnt==0){
			alert("????????? ????????? ??????????????????");
			return; //????????????
		}
		
		$(".ordernum:checked").each(function(i, element){
			var ordernum=$(this).attr("ordernum");
			//console.log(ordernum);
			
			//????????? ?????????????????? ?????? ??????
			del(ordernum);
		});
		//??????????????? ????????????
		location.reload();
	});
	
	// X ?????? ?????? ?????????
	$(".orddel").click(function(){
		var ordernum=$(this).attr("ordernum");
		var a=confirm("?????????????????????????")
		if(a){
			del(ordernum);
			location.reload();
		}
	});
	
	$(".ordlbtn").click(function(){
		var cnt = $(".ordernum:checked").length;
		if(cnt==0){
			alert("????????? ????????? ??????????????????");
			return;
		}
		$(".ordernum:checked").each(function(i, element){
			var ordernum=$(this).attr("ordernum");
			
			$.ajax({
				type:"get",
				url:"order/finishlist.jsp",
				dataType:"html",
				data:{"ordernum":ordernum},
				success:function(data){
					
				}
			});
		});
		location.href="index.jsp?main=order/orderfinish.jsp";
	});
});//$function end --

//????????? ??????
//?????? ?????????
function del(ordernum)
{
	$.ajax({
		type:"get",
		url:"order/orderdelete.jsp",
		dataType:"html",
		data:{"ordernum":ordernum},
		success:function(data){
			
		}
	});
}
</script>
</head>
<%
	//???????????? ????????? ??????
	String id = (String)session.getAttribute("myid");
	
	//orderdao??????
	OrderDao dao = new OrderDao();
	
	//???????????? ?????? ??????
	List<HashMap<String,String>> list = dao.getOrderList(id);
	
%>
<body>
<div class="sub_visual bg-menu">
    <div class="txt">
        <h1>????????????</h1>
        <p>?????? ????????????????????? ???????????? ??? ?????? ???????????? ???????????????.</p>
    </div>
    <div class="img-cover"></div>
</div>
<div class="ordlistall">
<input type="hidden" name="orderid" value="<%=id%>">
<h3 class="myid"><%=id %>?????? ????????????</h3>
<!-- <h3 class="myid">admin?????? ????????????</h3> -->
<table class="ordlist" style="width: 1100px;">
	<thead class="ordlthead">
	<tr>
		<th style="width: 10%;"><input type="checkbox" id="allcheck"></th>
		<th style="width: 45%;">????????????</th>
		<th style="width: 15%;">?????? ??????</th>
		<th style="width: 15%;">??????</th>
		<th style="width: 15%;"></th>
	</tr>
	</thead>
	<%
	int allp=0;
	NumberFormat nf = NumberFormat.getInstance();
	for(int i=0; i<list.size(); i++){
		HashMap<String,String> map = list.get(i);
		String photo = map.get("menuphoto");
		int p = Integer.parseInt(map.get("menuprice"));
		allp+=p;
	%>
		<tbody class="ordltbody">
			<tr>
				<td align="center" style="vertical-align: middle;">
					<input type="checkbox" name="ordernum" class="ordernum" ordernum="<%=map.get("ordernum")%>" value="<%=map.get("ordernum")%>">
				</td>
				<td>
					<div menunum="<%=map.get("menunum")%>" class="ordlmenu">
					<img src="menusave/<%=photo%>" class="ordlphoto">
					<input type="hidden" name="mnname" value=<%=map.get("menuname") %>>
					<b><%=map.get("menuname") %></b>
					</div>
				</td>
				<td style="text-align: center;">
					<input type="hidden" name="size" value="<%=map.get("size")%>">
					<input type="hidden" name="temp" value="<%=map.get("temp")%>">
					<input type="hidden" name="takeout" value="<%=map.get("takeout")%>">
					<input type="hidden" name="orderdate" value="<%=map.get("orderdate")%>">
					<span style="margin: 0;"><%=map.get("size") %> / <%=map.get("temp") %> / <%=map.get("takeout")%></span><br>
					<span style="color: #bbb; margin: 0;"><%=map.get("orderdate") %></span>
				</td>
				<td style="text-align: center;">
					<input type="hidden" name="orderprice" value="<%=p%>">
					<span style="margin: 0;"><%=nf.format(p) %>&nbsp;???</span>
				</td>
				<td class="del" style="text-align: center;">
					<i class='orddel fas fa-times' ordernum="<%=map.get("ordernum")%>"></i>
				</td>
			</tr>
		</tbody>
		<%}%>
		<tr style="height: 100px;">
			<td colspan="5">
			<button type="button" class="btn btn-outline-warning" id="btnorddel">??????????????????</button>
			<div id="ordlr">
				<div id="allp">??? ?????? ?????? <b style="color: #00979f;"><%=nf.format(allp) %></b>&nbsp;???</div>
				<button type="button" class="ordlbtn btn btn-warning">????????????</button>
			</div>
			</td>
		</tr>
</table>
</div>
</body>
</html>