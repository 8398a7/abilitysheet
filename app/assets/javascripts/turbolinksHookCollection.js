document.addEventListener('turbolinks:request-start', function() {
  document.querySelector('.loading-container').style = 'display: block';
  NProgress.start();
});

document.addEventListener('turbolinks:render', function() {
  document.querySelector('.loading-container').style = 'display: none';
  NProgress.done(true);
  UIkit.offcanvas.hide([force = false]);
});

document.addEventListener('turbolinks:load', function() { $('.searchable').select2() });
