//= require turbolinks

document.addEventListener("turbolinks:request-start", function(event) {
  var xhr = event.data.xhr;
  var nonce = document.querySelectorAll("meta[name='csp-nonce']")[0].content;
  xhr.setRequestHeader("X-Turbolinks-Nonce", nonce);
});
