//= require rails-ujs
//= require jquery
//= require activestorage
//= require jquery-ui/ui/widgets/datepicker
//= require jquery-ui/ui/i18n/datepicker-ja
//= require peek
//= require peek/views/performance_bar
//= require peek/views/rblineprof
//= require datatables-all/media/js/jquery.dataTables.min
//= require datatables-all/media/js/dataTables.uikit.min
//= require uikit/dist/js/uikit.min
//= require uikit/dist/js/components/notify.min
//= require uikit/dist/js/components/accordion.min
//= require select2/dist/js/select2.min
//= require nprogress/nprogress
//= require turbolinks
//= require_tree .

document.addEventListener('turbolinks:load', function() {
  scrollTop('scroll-top', 500);
});

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
