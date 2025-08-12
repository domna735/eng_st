<%@ page import="hkapps.shipment_tracking.*"%>
<%@ page import="com.hkapps.util.*"%>
<%
String nonce = java.util.UUID.randomUUID().toString().replace("-", "");
response.setHeader("Content-Security-Policy",
    "default-src 'self'; " +
    "script-src 'self' 'nonce-" + nonce + "' 'strict-dynamic' https://www.recaptcha.net https://www.gstatic.com; " +
    "object-src 'none'; base-uri 'none'; form-action 'self'; frame-ancestors 'none'; " +
    "frame-src 'self' https://www.recaptcha.net; " +
    "connect-src 'self' https://www.recaptcha.net; " +
    "img-src 'self' data: https://www.recaptcha.net https://www.gstatic.com; " +
    "style-src 'self' 'unsafe-inline' https://www.gstatic.com/recaptcha/; " +
    "upgrade-insecure-requests; block-all-mixed-content;");
%>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Page</title>
    <!-- Include eng_st_FormCheck.js for validation -->
    <script src="/eng_st/js_client_eng_hws/eng_st_FormCheck.js" nonce="<%=nonce%>"></script>
    <!-- Include dhl_alert.js for popup functionality -->
    <script language="JavaScript" src="/eng_st/js_client_eng_hws/dhl_alert.js?v=<%=System.currentTimeMillis()%>" nonce="<%=nonce%>"></script>
    <!-- Include popup_return.js for return button functionality -->
    <script src="/eng_st/js_client_eng_hws/popup_return.js?v=<%=System.currentTimeMillis()%>" nonce="<%=nonce%>"></script>
</head>
<body>
    <h1>Test Page</h1>
    <form id="testForm">
        <button id="returnBtn" type="button">Return</button>
    </form>
    <script nonce="<%=nonce%>">
        document.addEventListener('DOMContentLoaded', function() {
            const returnBtn = document.getElementById('returnBtn');
            if (returnBtn) {
                returnBtn.addEventListener('click', function() {
                    dhl_alert('Test Alert', 'This is a test alert message.', 200);
                });
            }
        });
    </script>
</body>
</html>
