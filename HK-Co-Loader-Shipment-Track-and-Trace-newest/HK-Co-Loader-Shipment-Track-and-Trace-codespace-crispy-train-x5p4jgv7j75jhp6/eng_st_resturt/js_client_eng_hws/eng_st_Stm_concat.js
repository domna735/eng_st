// 外部化自 eng_st_Stm.jsp 的 concat(f) function
function concat(f, noawb) {
  console.log('concat function called with noawb:', noawb);
  console.log('Form elements:', f.elements);
  console.log('aname:', f.elements["aname"] ? f.elements["aname"].value : 'not found');
  console.log('cname:', f.elements["cname"] ? f.elements["cname"].value : 'not found');
  console.log('cphone:', f.elements["cphone"] ? f.elements["cphone"].value : 'not found');
  console.log('emailaddr:', f.elements["emailaddr"] ? f.elements["emailaddr"].value : 'not found');
  
  // Enhanced debugging for CheckStmInfo
  console.log('About to call CheckStmInfo with:', {
    aname: f.elements["aname"],
    cname: f.elements["cname"], 
    cphone: f.elements["cphone"],
    emailaddr: f.elements["emailaddr"]
  });
  
  var checkResult = CheckStmInfo(f.elements["aname"], f.elements["cname"], f.elements["cphone"], f.elements["emailaddr"]);
  console.log('CheckStmInfo result:', checkResult);
  
  if (!checkResult) {
    console.log('CheckStmInfo failed - form validation did not pass');
    return false;
  }

  f.noawb.value = noawb;
  f.awblist.value = "";
  f.rmkslist.value = "";
  var rmk_found = false;

  for (let j = 0; j < noawb; j++) {
    f.awblist.value = f.awblist.value + f["awb" + j].value + "|";
    rmk_found = false;
    for (let k = 0; k < 10; k++) {
      f.rmkslist.value = f.rmkslist.value + f["rmks" + j + "_" + k].value + "^~";
      if (!isWhitespace(f["rmks" + j + "_" + k].value)) {
        rmk_found = true;
      }
    }
    f.rmkslist.value = f.rmkslist.value + "|";
    if (rmk_found == false) {
      f["rmks" + j + "_0"].focus();
      f["rmks" + j + "_0"].select();
      console.log('Calling dhl_alert for missing remarks');
      if (typeof dhl_alert === 'function') {
        dhl_alert("Remark is missing.", "Please enter remark for each selected waybill.", 180);
      } else {
        console.error('dhl_alert function not found!');
        alert("Remark is missing. Please enter remark for each selected waybill.");
      }
      return false;
    }
  }
  // 若有 Terms & Conditions 檢查需求，請於此補上
  console.log('concat validation passed - submitting form');
  return true;
}

// Add reCAPTCHA integration for eng_st_Stm.jsp
document.addEventListener('DOMContentLoaded', function() {
  var form = document.getElementsByName('f_inp')[0];
  if (!form) return;
  
  // Get noawb value from hidden field
  var noawbField = form.querySelector('input[name="noawb"]');
  var noawb = noawbField ? parseInt(noawbField.value) : 1;
  
  // Add form submit event listener
  form.addEventListener('submit', function(e) {
    e.preventDefault();
    
    // Validate form using concat function
    if (!concat(form, noawb)) {
      return false;
    }
    
    // Execute reCAPTCHA and submit
    grecaptcha.ready(function() {
      grecaptcha.execute('6LcB8dcZAAAAAJO9mElsjCkPrWVj1rXr2SH9ML_h', {action: 'submit'}).then(function(token) {
        // Add reCAPTCHA token to form
        var recaptchaField = form.querySelector('input[name="g-recaptcha-response"]');
        if (!recaptchaField) {
          recaptchaField = document.createElement('input');
          recaptchaField.type = 'hidden';
          recaptchaField.name = 'g-recaptcha-response';
          form.appendChild(recaptchaField);
        }
        recaptchaField.value = token;
        
        // Submit form
        form.submit();
      });
    });
  });
});
