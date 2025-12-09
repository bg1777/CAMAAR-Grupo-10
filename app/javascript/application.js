// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
// import "bootstrap"

window.add_fields = function(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  
  // Insere o novo campo ANTES do botão clicado
  link.insertAdjacentHTML('beforebegin', content.replace(regexp, new_id));
}