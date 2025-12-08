// app/assets/javascripts/form_fields.js

document.addEventListener('DOMContentLoaded', function() {
  window.add_fields = function(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");
    var new_fields = content.replace(regexp, new_id);
    
    var container = link.closest('form').querySelector("#fields-container");
    if (container) {
      var temp = document.createElement('div');
      temp.innerHTML = new_fields;
      container.appendChild(temp.firstElementChild);
    }
    
    return false;
  };
});
