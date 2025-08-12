// DHL Alert Function - Separate JS file - v1.0
// Created to isolate popup functionality and ensure proper loading

var alertWin;

function wincloseAlert() {
  if (typeof alertWin === 'object' && alertWin && !alertWin.closed) {
    alertWin.close();
  }
  return true;
}

function dhl_alert(name, text, height = 200) {
  wincloseAlert();
  
  // URL encode the parameters to safely pass them to the JSP
  const encodedTitle = encodeURIComponent(name);
  const encodedMessage = encodeURIComponent(text);
  const encodedHeight = encodeURIComponent(height);
  
  // Open the JSP popup with parameters
  const popupUrl = `dhl_alert_popup.jsp?title=${encodedTitle}&message=${encodedMessage}&height=${encodedHeight}`;
  alertWin = window.open(popupUrl, "dhl_alert", `toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width=300,height=${height}`);
  
  return false;
}
