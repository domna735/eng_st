<%@ page import="hkapps.shipment_tracking.*"%>
<%@ page import="com.hkapps.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.lang.*"%>
<%@ page import="java.lang.reflect.Array"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>

<html>

<head>
<title>Shipment Tracing</title>
</head>

<script language="JavaScript" src="../js_client_eng_hws/eng_st_FormCheck.js"></script>

<%
String referpage = request.getHeader("referer");

Common common = new Common();

if (referpage == null) {
   response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
   if(true){return;}
}

URL referurl = new URL(referpage);
if (!common.isValidProtocol(referurl.getProtocol(),request.getServerPort())) {
   response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
   if(true){return;}
}

if (!common.isValidHost(referurl.getHost())) {
   response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
   if(true){return;}
}

if (!referurl.getPath().equals("/eng_st/eng_track.jsp")) {
   response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
   if(true){return;}
}


if (request.getQueryString() != null) {
   response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
   if(true){return;}
}


if ((request.getParameter("hidawb") == null) || (request.getParameter("hidawb").equals("")) || (request.getParameter("hidawb").equals("undefined"))) {
   response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
   if(true){return;} 
} else {
  
  String hidawb=request.getParameter("hidawb");
  String[] awblist=hidawb.split("\\|");
  int noawb=Array.getLength(awblist);  
  String t = "";
  
  if ((noawb <= 0) || (noawb > 10)) {
	  response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
      if(true){return;}
  }
  
  DataTypeUtil dtu = new DataTypeUtil();
  
  boolean chk_awb = true;
  for (int p = 0 ; p < noawb ; p++) {
	  if (!dtu.isAwb(awblist[p])) {
	    chk_awb = false;
        p=noawb;
      }
  } 
  
  if (!chk_awb) {
    response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
	if(true){return;}
  }
  
  String freq_awb = "";
  boolean awb_too_freq = false;
  Shipment_tracking ship_track = new Shipment_tracking();
  Properties prop=new Properties();
  FileInputStream ip=new FileInputStream(System.getProperty("catalina.base")+"/webapps/config.properties");
  prop.load(ip);
  
  for (int f = 0 ; f < noawb ; f++) {
	  awb_too_freq = ship_track.chk_too_freq2(awblist[f],"TRC",Integer.parseInt(prop.getProperty("trc_chkday")));
	  if (awb_too_freq) {
	    freq_awb = freq_awb + "<br>" + awblist[f];
      }
  }
  
  
  if (!freq_awb.equals("")) {
	//out.println("<blockquote><font size='2' face='Frutiger, Arial'><b>This following shipment(s) has/have trace case created in past " + prop.getProperty("trc_chkday") + " days.<br>" + freq_awb + "</b></font></blockquote>");	  
	out.println("<blockquote><font size='2' face='Frutiger, Arial'><b><br>Dear Customer,");
	out.println("<br><br>According to our records, you have enquired the following shipment(s) earlier.<br>" + freq_awb);
	out.println("<br><br>Kindly refer to the previous email communication and reply to us if there is anything that we can be of assistance.");
	//out.println("<br><br>For any other questions, please email to <a href='mailto:hk.wsc@dhl.com'>hk.wsc@dhl.com</a>");
	out.println("<br><br>Thank you for your kind attention.<br><br>Regards,<br><br>Customer Service Division</b></font></blockquote>");
	
  } else {
  
  
  out.println("<script>function concat(f) {");
  out.println("  if (!CheckStmInfo(f.elements[\"aname\"], f.elements[\"cname\"], f.elements[\"cphone\"], f.elements[\"emailaddr\"]))");
  out.println("  return false;");

  out.println("f.noawb.value="+noawb+";");
  out.println("f.awblist.value=\"\";");
  out.println("f.rmkslist.value=\"\";");
  out.println("var rmk_found=false;");
  
  for (int j = 0 ; j < noawb ; j++) {
    t="f.awblist.value=f.awblist.value+f.awb"+j+".value + \"|\";";
    out.println(t);
	
	out.println("rmk_found=false;");
    for (int k = 0; k < 10; k++) {
    
    	t="f.rmkslist.value=f.rmkslist.value+f.rmks"+j+"_"+k+".value + \"^~\";";
    	out.println(t);
		t="if (!isWhitespace(f.rmks"+j+"_"+k+".value)) {";
		out.println(t);
		out.println("  rmk_found=true;");
		out.println("}");
    }
	
    t="f.rmkslist.value=f.rmkslist.value+ \"|\";";
    out.println(t);
	out.println(" if (rmk_found == false) {");
	t="f.rmks"+j+"_0.focus();";
	out.println(t);	
	t="f.rmks"+j+"_0.select();";
	out.println(t);
	out.println("   dhl_alert(\"Remark is missing.\", \"Please enter remark for each selected waybill.\", 180 );");
	out.println("   return false;");
	out.println(" }");
	
    out.println(t);
  }

/*
out.println("if (f.agreetc.checked == false) {");
out.println("   f.agreetc.focus();");
out.println("   f.agreetc.select();");
out.println("   dhl_alert(\"Terms and Conditions\", \"Please tick the box if you have read and accept the Terms and Conditions, and Privacy Notice.\", 180 );");
out.println("   return false;");
out.println("} else {");
out.println("return true;");
out.println("}");
*/

out.println("}");
out.println("</script>");
%>

<body bgcolor=#ffffff>
<blockquote>

<p><img src="../images/invest_banner.gif"></p>

<form NAME="f_inp" method="post" action="eng_st_SendTrace.jsp" onsubmit="return concat(f_inp);" >
 <INPUT type="hidden" name="awblist">
 <INPUT type="hidden" name="rmkslist">
 <INPUT type="hidden" name="noawb" value="1">
  <table BORDER="0">

    <tr VALIGN="middle">
      <td WIDTH="40%"><font SIZE="2" face="Frutiger, Arial" color="#a60018"><b>Company Contact Person:</b></font></td>
      <td><font SIZE="2" face="Frutiger, Arial" color="#9C0000">
      <input type="text" name="aname" size="30" maxlength="20"></font></td>
    </tr>

    <tr>
      <td WIDTH="40%"><font SIZE="2" face="Frutiger, Arial" color="#a60018"><b>Company Name:</b></font></td>
      <td><font SIZE="2" face="Frutiger, Arial">
      <input type="text" name="cname" size="30" maxlength="30"></font></td>
    </tr>

    <tr>
      <td WIDTH="40%"><font SIZE="2" face="Frutiger, Arial" color="#a60018"><b>Company Contact Phone:</b></font></td>
      <td><font SIZE="2" face="Frutiger, Arial" color="#9C0000">
	 <input type="text" name="cphone" size="18" maxlength="18"></font></td>
    </tr>

    <tr>
      <td WIDTH="40%"><font SIZE="2" face="Frutiger, Arial" color="#a60018"><b>Company Contact E-mail:</b></font></td>
      <td><font SIZE="2" face="Frutiger, Arial">
	  <input type="text" name="emailaddr" size="30" maxlength="50"></font>
      </td>
    </tr>

    <tr>
      <td><br>
      </td>
    </tr>

  </table>

<hr>

  <font SIZE="2" face="Frutiger, Arial">
  Please type your question(s) about shipment status in the following box <b><u>in English</u></b>.<br>
  An example of question is shown below for your reference. Please feel <br>
  free to change the example's wording to suit your query.</font>

<br>
  
<%
    for (int i = 0; i < noawb; i++) { 
     out.println("<table>\n");
     out.println("<tr>\n");
     out.println("<td><font SIZE=\"2\" face=\"Frutiger, Arial\" color=\"#a60018\">\n");
     out.println("<b>Airwaybill Number:</b></font></td>\n");
     out.println("<td><font size=\"2\" face=\"Frutiger, Arial\"><b>"+awblist[i]+" </b>\n");
     out.println("<input type=\"hidden\" name=\"awb"+i+"\" value=\""+awblist[i]+"\"></font></td>\n");
     out.println("</tr>\n\n");
     out.println("</table>");
     out.println("<table>");
     out.println("<tr valign=top>\n");
     out.println("<td><font size=\"2\" face=\"Frutiger, Arial\" color=#a60018>\n");
     out.println("<b>Remarks<br>(maximum 600<br>characters):</b></font></td>\n");
     out.println("<td>");
 
     //print 10 textboxes with maxlength of 60.
     //out.println("<input type=textbox name=rmks"+i+"_0 size=60 maxlength=60 value=\"Please check shipment delivery details\"><br>");
     out.println("<input type=textbox name=rmks"+i+"_0 size=60 maxlength=60 value=\"Please input your question.\"><br>");
     for (int tb = 1; tb < 10; tb++) {
        out.println("<input type=textbox name=rmks"+i+"_"+tb+" size=60 maxlength=60><br>");     	
     }

     out.println("</tr>\n\n");
     out.println("</table>");
     
    }
%>

   <br>
  <table> 
  <tr>
   <td>
<font SIZE="2" face="Frutiger, Arial">
<!--
&#60 &#60 note 1 - this URL is reserved for the enquiry and case registration of shipment under coloader's Hong Kong 63 account. &#62 &#62
<br>
&#60 &#60 note 2 - case can be registered after 24 hrs of pick up scan for shipment. &#62 &#62
<br><br>
Please kindly <a href="mailto:net012@dhl.com?cc=vicky.chan@dhl.com">email to net012@dhl.com cc to vicky.chan@dhl.com</a> if your enquiry belongs to following scenarios: <br>
1.  You had enquired the shipment before and now it is already over 30 days since your last enquiry. <br>
2.  Shipment already sent out or sent out over 90 calendar days, and you cannot see any shipment status via the URL. <br>
3.  You had registered a request for two days but there is without any acknowledgement response from DHL agent. <br>
4.  In case of top urgent issue that require DHL's immediate follow up but case cannot be registered over the web due to the time constraint. <br>
<br>
-->
Please read and agree <a href="https://apps.dhl.com.hk/statement/eng_hk/pics.html" target="_blank" rel="noopener noreferrer">Personal Information Collection Statement</a> before submission.

</font>
    </td>
    </tr>
    <tr><td><br>
      <input type=submit value="Send Request" onclick="return concat(f_inp);">&nbsp;&nbsp;
      <input type=reset value="Clear">
   </td>
      </tr>
    </table>


</form>

</blockquote>
<SCRIPT LANGUAGE="javascript" SRC="../js_client/copyright_r.js"></SCRIPT>
</body>

<%
  }
}
%>

</html>

