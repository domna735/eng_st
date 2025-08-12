<%@ page contentType="text/html; charset=UTF-8" %>
<%
String nonce = java.util.UUID.randomUUID().toString().replace("-", "");
response.setHeader("Content-Security-Policy",
    "default-src 'self'; " +
    "script-src 'self' 'nonce-" + nonce + "' 'strict-dynamic'; " +
    "object-src 'none'; " +
    "base-uri 'none'; " +
    "form-action 'self'; " +
    "frame-ancestors 'none';");

// Get parameters passed from the parent window
String alertTitle = request.getParameter("title");
String alertMessage = request.getParameter("message");
String alertHeight = request.getParameter("height");

// Set defaults if parameters are null
if (alertTitle == null) alertTitle = "Alert";
if (alertMessage == null) alertMessage = "No message provided";
if (alertHeight == null) alertHeight = "200";
%>
<!DOCTYPE html>
<html>
<head>
    <title>International Shipment Tracking</title>
    <meta charset="UTF-8">
    <script src="/eng_st/js_client_eng_hws/popup_return.js" nonce="<%=nonce%>"></script>
    <script nonce="<%=nonce%>">
        document.addEventListener('DOMContentLoaded', function() {
            const btn = document.getElementById('returnBtn1');
            if (btn) {
                btn.addEventListener('click', function() {
                    if (window.opener && typeof window.opener.wincloseAlert === 'function') {
                        window.opener.wincloseAlert();
                    }
                    window.close();
                });
            }
        });
    </script>
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0" scroll="no">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr bgcolor="#FFCC00"><td>&nbsp;</td></tr>
        <tr bgcolor="#CC0000" valign="bottom">
            <td height="45">
                <table height="100%" width="100%" border="0">
                    <tr valign="bottom">
                        <td width="2%">&nbsp;</td>
                        <td><font color="#FFFFFF" size="+1" face="Arial"><b><%=alertTitle%></b></font></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table cellpadding="12" border="0" width="100%">
                    <tr><td><font face="Arial" size="2"><%=alertMessage%></font></td></tr>
                    <tr>
                        <td align="right">
                            <form name="back">
                                <input type="button" id="returnBtn1" name="toReturn" value="Return">
                            </form>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>
