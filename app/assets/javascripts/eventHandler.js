document.addEventListener('turbolinks:request-start', function() {
  document.querySelector('.loading-container').style = 'display: block';
  NProgress.start();
});

document.addEventListener('turbolinks:render', function() {
  document.querySelector('.loading-container').style = 'display: none';
  NProgress.done(true);
});

document.addEventListener('turbolinks:load', function() {
  $('.searchable').select2();
  bulmaAccordion.attach();
  navBarEvent();
  scrollTop('scroll-top', 500);
});

document.addEventListener('click', function(e) {
  closeModal(e);
});

function navBarEvent() {
  var $navbarBurgers = Array.prototype.slice.call(
    document.querySelectorAll('.navbar-burger'), 0);
  if ($navbarBurgers.length > 0) {
    $navbarBurgers.forEach(function(el) {
      el.addEventListener('click', function() {
        var target = el.dataset.target;
        var $target = document.getElementById(target);
        el.classList.toggle('is-active');
        $target.classList.toggle('is-active');
      });
    });
  }
}

function closeModal(e) {
  if (e.target.className !== 'modal-background') return;
  document.querySelectorAll('.modal').forEach(function(modal) {
    return (modal.className = 'modal');
  });
}

function scrollTop(elem, duration) {
  var target = document.getElementById(elem);
  target.addEventListener('click', function() {
    var currentY = window.pageYOffset;
    var step = duration / currentY > 1 ? 10 : 100;
    var timeStep = (duration / currentY) * step;
    var intervalID = setInterval(scrollUp, timeStep);

    function scrollUp() {
      currentY = window.pageYOffset;
      if (currentY === 0) {
        clearInterval(intervalID);
      } else {
        scrollBy(0, -step);
      }
    }
  });
}
