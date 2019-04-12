<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ include file="common.jsp"%>
<%@ page language="java" import="java.sql.*,java.io.*,java.util.*,java.util.Date,java.text.SimpleDateFormat,java.text.*"%>

<%
String loginname = request.getParameter("loginname")==null?"":request.getParameter("loginname");
String signdate = request.getParameter("signdate")==null?"":request.getParameter("signdate");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
.searchTable{
	margin:20px 2px;
	width:100%;
}
.searchTable tr{
	height:40px;
}
.searchLeft{
	height:30px;
	width:35%;
	font-family:"微软雅黑";
	font-size:13px;
}
 .formLeft{
 	width:60px;
 	float:right;
 }
 .searchRight input {
	width: 150px;
}
</style>
 </head> 
 <body id="layout" class="easyui-layout">
	<div data-options="region:'center',border:false">
		<table id="infoDrid"></table>
	</div>
<!-- 查询条件 -->
<div data-options="region:'east',split:true,title:'信息查询',border:false" style="width:250px;padding:5px;">
<form id="searchForm">
	<table class="searchTable">
		<tr>
			<td class="searchLeft">合同名称：</td>
			<td class="searchRight">
				<input class="easyui-validatebox" name="username" id="usernameSearch">
			</td>
		</tr>
		<tr>
			<td  class="searchLeft">合同编号：</td>
			<td class="searchRight">
				<input class="easyui-validatebox" name="loginname" id="loginnameSearch" value='<%=loginname%>'>
				<input id="signdate" type="hidden" value="<%=signdate%>">
			</td>
		</tr>
		<tr>
			<td class="searchLeft">开始时间：</td>
			<td class="searchRight">
				<input class="easyui-datetimebox" name="stattime" id="stattimeSearch">
			</td>
		</tr>
		<tr>
			<td  class="searchLeft">结束时间：</td>
			<td class="searchRight">
				<input class="easyui-datetimebox" name="endtime" id="endtimeSearch">
			</td>
		</tr>
	</table>
	<div>
	<a id="searchbtn" class="easyui-linkbutton" data-options="iconCls:'icon-ccSearch'" style="margin-left:50px">查询</a>
	<a id="resetbtn"   class="easyui-linkbutton" data-options="iconCls:'icon-ccReload'">重置</a>
	</div>
	</form>
</div>
<!-- dataGrid工具栏 -->
<div id="toolbar">
	<a id="search" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-ccSearch',plain:true" >查询</a>
	<!-- <a id="export" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-ccExport',plain:true" >导出</a> -->
	<a id="track" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-ccSearch',plain:true" >查看订单</a>
	</div>
</body>
</html>

<script>
	$(function(){
		//页面初始化
		layoutLoad();
		//数据表格加载
		gridLoad();	
		//点击事件
		clickFunction();
	});
	//页面初始化
	function layoutLoad(){
		$('#layout').layout('collapse','east');
	}
	//数据表格加载
	function gridLoad(){
		console.log($('#signdate').val()==""?null:new Date($('#signdate').val()));
		var width = $('#infoDrid').parent().width();
		var height = $('#infoDrid').parent().height();
		var data = {
				username:$('#usernameSearch').val(),
				loginname:$('#loginnameSearch').val(),
				signdate1:$('#signdate').val(),
				starttime:$('#stattimeSearch').datetimebox('getValue'),
				endtime:$('#endtimeSearch').datetimebox('getValue'),
		}
		$('#infoDrid').datagrid({
			url:'/sign/web/searchByCondition.json',
			toolbar:"#toolbar",
			width:width,
			height:height,
			queryParams:data,
			fit:true,
			border:false,
			singleSelect:true,
			//nowrap:false,
			fitColumns:true,
			striped:true,
			pagination:true,
/* 			frozenColumns:[[  
				{field:'username',title:'合同编号',width:100,align:'center',},    
				{field:'loginname',title:'合同名称',width:100,align:'center',}, 
				{field:'deptname',title:'合同金额',width:200,align:'center',},
				{field:'signdate',title:'打卡日期',width:100,align:'center',formatter:function(value,row,index){
					return CurentDateBySS(value);
				}},
				{field:'signtime',title:'打卡时间',width:100,align:'center',formatter:function(value,row,index){
					return CurentTimeBySS(value);
				}},
		    ]], */
		    columns:[[  
		        {field:'signadress',title:'区域',align:'center',width:200},
				{field:'mobiletype',title:'甲方名称',align:'center',width:200},
		        {field:'remark',title:'中标单位',align:'center',width:200},  
		        {field:'imei',title:'合同编号',align:'center',width:200},
		        {field:'mobilename',title:'合同名称',align:'center',width:200},
		        {field:'ssid',title:'合同金额',align:'center',width:200},
		        {field:'longitude',title:'创建日期',align:'center',width:200},
		    ]],
		});
	}
	//点击事件
	function clickFunction(){
		$('#search').click(function(){
			$('#layout').layout('expand','east');
		});
		$('#export').click(function(){
			window.location.href="";
		});
		//点击查询
		$('#searchbtn').click(function(){
			gridLoad();
		});
		$('#resetbtn').click(function(){
			$('#searchForm')[0].reset();
			$("#loginnameSearch").val('');
			$("#signdate").val('');
			$('#stattimeSearch').datetimebox('setValue','');
			$('#endtimeSearch').datetimebox('setValue','');
			gridLoad();
		});
		$('#export').click(function(){
			window.location.href="/sign/web/exportInfo.json?username="+$('#usernameSearch').val()
					+"&loginname="+$('#loginnameSearch').val()
					+"&signdate1="+$('#signdate').val()
					+"&starttime="+$('#stattimeSearch').datetimebox('getValue')
					+"&endtime="+$('#endtimeSearch').datetimebox('getValue');
		});
		//查看足迹
		$('#track').click(function(){
			var date =$('#signdate').val()==""?new Date():new Date($('#signdate').val());
			parent.addTab('查看足迹',"/view/map.jsp?username="+$('#usernameSearch').val()
					+"&loginname="+$('#loginnameSearch').val()
					+"&signdate1="+$('#signdate').val()
					+"&starttime="+$('#stattimeSearch').datetimebox('getValue')
					+"&endtime="+$('#endtimeSearch').datetimebox('getValue'))
		});
	}
</script>