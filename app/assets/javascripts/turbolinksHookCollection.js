document.addEventListener('turbolinks:request-start', function() {
  document.querySelector('.loading-container').style = 'display: block';
  return NProgress.start();
});

document.addEventListener('turbolinks:render', function() {
  document.querySelector('.loading-container').style = 'display: none';
  return NProgress.done();
});

document.addEventListener('turbolinks:load', function() { $('.searchable').select2() });
