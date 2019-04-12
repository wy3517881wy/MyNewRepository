<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	String servicePath = request.getScheme() + "://"
			+ request.getServerName();
%>
<%@ include file="common.jsp"%>
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
	font-size:14px;
}
.searchRight input{ 
 	width:95%;
 }
 .formLeft{
 	width:60px;
 	float:right;
 }
</style>
 </head> 
 <body id="layout" class="easyui-layout">
	<div data-options="region:'center',border:false">
	<table id="infoDrid"></table>
	</div>
<!-- 查询条件 -->
<div data-options="region:'east',split:true,title:'信息查询',border:false" style="width:250px;padding:10px;">
	<form id="searchForm">
	<table class="searchTable">
		<tr>
			<td class="searchLeft">用户名：</td>
			<td class="searchRight">
				<input class="easyui-validatebox" name="username" id="username1">
			</td>
		</tr>
		<tr>
			<td  class="searchLeft">登录名：</td>
			<td class="searchRight">
				<input class="easyui-validatebox" name="loginname" id="loginname1">
			</td>
		</tr>
	</table>
	<div>
	<a id="searchbtn" onclick="gridLoad()" class="easyui-linkbutton" data-options="iconCls:'icon-ccSearch'" style="margin-left:50px">查询</a>
	<a id="resetbtn"  onclick="reset()" class="easyui-linkbutton" data-options="iconCls:'icon-ccReload'">重置</a>
	</div>
	</form>
</div>
<!-- dataGrid工具栏 -->
<div id="toolbar">
	<a id="search" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-ccSearch',plain:true" >查询</a>
	<a id="insert" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-ccAdd',plain:true">添加</a>
	<!-- <a id="update" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-ccEdit',plain:true" >编辑</a> -->
	<a id="delete" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-ccDelete',plain:true" >删除</a>
</div>
	<!-- 信息添加dialog -->
	<div id="addDialog">
		<form id="addForm">
			<table class="tableForm">
				<tr>
					<td class="formLeft">用户名:</td>
					<td>
						<input class="easyui-validatebox" data-options="validType:'positionCodes',required:true" name="name" id="name">
					</td>
				</tr>
				<tr>
					<td class="formLeft">职位:</td>
					<td>
						<input class="easyui-validatebox" data-options="validType:'positionCodes',required:true" name="position" id="position">
					</td>
				</tr>
				<tr>
					<td class="formLeft">密码:</td>
					<td>
						<input class="easyui-validatebox"  data-options="required:true" name="password" id="password">
					</td>
				</tr>
				<tr>
					<td class="formLeft">确认密码:</td>
					<td>
						<input class="easyui-validatebox"  data-options="required:true" name="insurepassword" id="insurepassword">
					</td>
				</tr>
				
			</table>
		</form>
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
		//信息添加dialog
		$('#addDialog').dialog({
			title: '添加登录信息',    
		    width: 300,   
		    height:400,
		    closed: true,    
		    modal: true,   
		    buttons:[{
				text:'确定',
				iconCls:'icon-ok',
				handler:function(){
					addInfo();//添加信息
                }
			},{
				text:'取消',
				iconCls:'icon-cancel',
				handler:function(){
					$('#addDialog').dialog('close');
				}
			}], 
		});
	}
	function addTab(title,url){
		parent.addTab(title,url);
	}
	//数据表格加载
	function gridLoad(){
		var width = $('#infoDrid').parent().width();
		var height = $('#infoDrid').parent().height();
		$('#infoDrid').datagrid({
			url:'/userLogin/web/getUserLoginList.json',
			queryParams:{
				username:$("#username1").val(),
				loginname:$("#loginname1").val(),
// 				password:$("#password1").val()
			},
			singleSelect:true,
			toolbar:"#toolbar",
			width:width,
			singleSelect:true,
			height:height,
			fit:true,
			border:false,
			fitColumns:true,
			striped:true,
			pagination:true,
		    columns:[[  
		        {field:'username',title:'用户名',width:200,align:'center',},    
		        {field:'field1',title:'职位',width:200,align:'center',},    
		        {field:'createtime',title:'创建时间',width:200,align:'center',formatter:function(value,row,index){
		        	return CurentDateTimeBySS(value);
				}},
		    ]],
		});
	}
	//点击事件
	function clickFunction(){
		$('#search').click(function(){
			$('#layout').layout('expand','east');
		});
		$('#insert').click(function(){
			$('#addForm')[0].reset();
			
			$('#addDialog').dialog('open');
		});
		$("#update").click(function(){
			$('#addDialog').dialog('setTitle',"编辑登录信息");
			var row = $('#infoDrid').datagrid('getSelected');
			if(row==null){
				$.messager.alert("提示","请选中一行!");
				return;
			}
			$("#id").val(row.id);
			$("#username").val(row.username);
			$("#loginname").val(row.loginname);
			$("#password").val(row.password);
			$('#addDialog').dialog('open');
			
		});
		
		$("#delete").click(function(){
			var row = $('#infoDrid').datagrid('getSelected');
			if(row==null){
				$.messager.alert("提示","请选中一行!");
				return;
			}
			$.messager.confirm('提示','确定要删除吗?',function(r){
			    if (r){
					$.ajax({
						url:'/userLogin/web/delUserLogin.do',
						type:'POST',
						data:{
							id:row.id
						},
						error:function(){
							$.messager.alert("提示","数据操作存在异常!");
						},
						success:function(data){	
							$.messager.alert("提示",data.message);
							$('#infoDrid').datagrid('load');
						}
					});
			    }
			});
		});
	}
	//添加信息
	function addInfo(){
		if($("#username").val()==null ||$("#username").val()==""){
			$.messager.alert("提示","用户名不能为空!");
			return;
		}
		if($("#loginname").val()==null ||$("#loginname").val()==""){
			$.messager.alert("提示","登录名不能为空!");
			return;
		}
		if($("#password").val()==null ||$("#password").val()==""){
			$.messager.alert("提示","登录密码不能为空!");
			return;
		}
		
		$.ajax({
			url:'/userLogin/web/addOrUpdateUserLogin.do',
			type:'POST',
			data:$("#addForm").serialize(),
			error:function(){
				$.messager.alert("提示","数据操作存在异常!");
				$('#addDialog').dialog('close');
				
			},
			success:function(data){	
				$.messager.alert("提示",data.message);
				$("#id").val("");
				$("#username").val("");
				$("#loginname").val("");
				$("#password").val("");
				$('#addDialog').dialog('close');
				$('#infoDrid').datagrid('load');
				
			}
		});
	}
	
	
	function reset(){
		$("#searchForm")[0].reset();
		gridLoad();
	}
</script>