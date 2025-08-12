// Enhanced popup return functionality with global wincloseAlert support
// Ensure wincloseAlert is available globally
if (typeof window.wincloseAlert === 'undefined') {
  window.wincloseAlert = function() {
    if (typeof alertWin !== 'undefined' && alertWin && !alertWin.closed) {
      alertWin.close();
    }
    return true;
  };
}

document.addEventListener('DOMContentLoaded', function() {
  var btn = document.getElementById('returnBtn');
  if (btn) {
    btn.addEventListener('click', function() {
      if (typeof alertWin !== 'undefined' && alertWin && !alertWin.closed) {
        alertWin.close(); // Close the dhl_alert window if it is open
      }
    });
  }
});
