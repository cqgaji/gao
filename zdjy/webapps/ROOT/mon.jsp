
<%@ page language="java" pageEncoding="UTF-8"  contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.util.Date"%>
<%@ page import="javax.naming.Context"%>
<%@ page import="javax.naming.InitialContext"%>
<%@ page import="javax.sql.DataSource"%>


<jsp:directive.page import="java.sql.ResultSet" />
<jsp:directive.page import="java.sql.SQLException" />
<jsp:directive.page import="java.sql.PreparedStatement"/>
<jsp:directive.page import="java.text.SimpleDateFormat"/>
<jsp:directive.page import="java.sql.Timestamp"/>

<!DOCTYPE HTML >
<html>
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8">
<title>卓咪云状态监控</title>
</head>
<%!
 public String filterstr(String aa){//过滤	  
		String sr=aa;

			sr=sr.replaceAll("◆","") ;
	  		sr=sr.replaceAll(":","") ;
	  		sr=sr.replaceAll(";","") ;
	  		sr=sr.replaceAll("=","") ;
	  		sr=sr.replaceAll(">","") ;
	  		sr=sr.replaceAll("<","") ;
			sr=sr.replaceAll("$","") ;
			sr=sr.replaceAll("%","") ; 
		
	  		return sr;	
	  			
}

%>
<%
	request.setCharacterEncoding("UTF-8");
	
	String id = request.getParameter("id");
	String pass = request.getParameter("pass");
	//id = filterstr(id);
	//pass = filterstr(pass);

	
	//如果账户为空，则显示登录页面
	if (id ==null || pass == null ) {
%>


<body>
<p>请输入卓咪云帐号和密码进行登录！</p>
<form action="mon.jsp" method="post">

<p>卓咪云帐号：<input type="text" name="id" value=""></p>
<p>登录密码：<input type="password" name="pass" value=""></p>
<p><input type="submit" value="登录"/>
</form>


</body>
</html>
<%
}
else
{
	//首先对账户进行合法性验证
	String sql;
	Connection conn = null;
	Statement stmt = null;
	int result = 0;
	try{
		Context initContext = new InitialContext(); //实例化一个空间
		  Context envContext  = (Context)initContext.lookup("java:/comp/env");//获取所有资源
		  DataSource ds = (DataSource)envContext.lookup("jdbc/zdjy");//获取jndi数据源
		  conn = ds.getConnection(); //申请一个连接
		  stmt =conn.createStatement(); //创建statement
		sql = "SELECT id_nick FROM account Where id_account='"+id+"' and id_password='"+pass+"'"; 
       		ResultSet rs1 = stmt.executeQuery(sql);
		 if (rs1.isAfterLast()==rs1.isBeforeFirst() ){
       		 out.print("账户验证失败"); 
       		 }
		else{
			rs1.next();
			String name=rs1.getString("id_nick");
			rs1.close();
			Date date = new Date();
    			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    			String today = df.format(date);
			out.print("欢迎您："+name+"    ,在这里你可以监看卓咪程序的运行情况，页面每2分钟自动更新！   更新时间:"+today); 
	
			sql = "SELECT traninfo,sysset,gulist,gdlb,timestampdiff(minute,timeup,now()) as diftt FROM moniter Where account='"+id+"'"; 
       			ResultSet rs = stmt.executeQuery(sql);

			if (rs.isAfterLast()==rs.isBeforeFirst() ){
       			out.print("<br>卓咪程序可能未运行或者运行出错，请检查！"); 
				rs.close();
       			 }
			else{
				rs.next();
				String isok="正常";
				String info=rs.getString("traninfo");
				String sysset=rs.getString("sysset");
				String gulist=rs.getString("gulist");
				String gdlb=rs.getString("gdlb");
				int diftt=rs.getInt("diftt");
				rs.close();
				if ( diftt>4){ isok="<font color=red>异常</font>";}
				//下面输出页面
%>
<table  align=center border=1 bordercolor="#000000" style="border-collapse: collapse" cellpadding="2" cellspacing="2">
<tr>
<Td align=center>系统运行：<%=isok%></td>
</tr>
<tr>
<Td align=center>系统参数：<%=sysset%></td>
</tr>
<tr>
<Td align=center>运行日志：<%=info%></td>
</tr>

<tr>
<Td align=center>
	<table  align=center border=1 bordercolor="#000000" style="border-collapse: collapse" cellpadding="1" cellspacing="1">
	<tr><Td align=left>股票代码</td><Td align=left>股票名称</td><Td align=left>持仓数量</td><Td align=left>总成本</td><Td align=left>收益</td><Td align=left>买入时间</td><Td align=left>TOT标志</td><Td align=left>TOT成本</td><Td align=left>标志符号</td>
			</tr>
	<%

		String[] jilu=null;
		String[] shuju=null;
		jilu=gulist.split(";");
		for(int num=0;num<jilu.length;num++)
       		{ 	
			if(jilu[num].length()>20){
			shuju=jilu[num].split("#");
	%>
			<tr>
			<Td align=left><%=shuju[0]%></td><Td align=left><%=shuju[1]%></td><Td align=left><%=shuju[2]%></td><Td align=left><%=shuju[3]%></td><Td align=left><%=shuju[4]%></td><Td align=left><%=shuju[5]%></td><Td align=left><%=shuju[6]%></td><Td align=left><%=shuju[7]%></td><Td align=left><%=shuju[8]%></td>
			</tr>
	<%			
						}		
		}
	%>
	</table>
</td>
</tr>

<tr>
<Td align=center>
	<table  align=center border=1 bordercolor="#000000" style="border-collapse: collapse" cellpadding="1" cellspacing="1">
	<tr><Td align=left>状态</td><Td align=left>买卖</td><Td align=left>代码</td><Td align=left>名称</td><Td align=left>价格</td><Td align=left>时间</td><Td align=left>咪币</td><Td align=left>发布人</td>
			</tr>
	<%

		String[] jilu2=null;
		String[] shuju2=null;
		jilu2=gdlb.split(";");
		for(int num=0;num<jilu2.length;num++)
       		{ 	
			if(jilu2[num].length()>20){
			shuju2=jilu2[num].split("#");
	%>
			<tr>
			<Td align=left><%=shuju2[0]%></td><Td align=left><%=shuju2[1]%></td><Td align=left><%=shuju2[2]%></td><Td align=left><%=shuju2[3]%></td><Td align=left><%=shuju2[4]%></td><Td align=left><%=shuju2[5]%></td><Td align=left><%=shuju2[6]%></td><Td align=left><%=shuju2[7]%></td>
			</tr>
	<%			
						}		
		}
	%>
	</table>
</td>
</tr>
</table>
			
<%




			}
		}


	}catch(SQLException e){	e.printStackTrace();return;}finally{if(stmt != null)	stmt.close();if(conn != null)	conn.close();}
		

	

}

%>
<script type="text/javascript">
	setInterval(function () {
		window.location.href="http://127.0.0.1:8080/mon.jsp?id=<%=id%>&pass=<%=pass%>";
		window.location.reload;
	}, 120000);	// 单位: 毫秒, 1000 = 1 秒
</script>

</html>


