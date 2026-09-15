(function() {
  var dayInMilliseconds = 24 * 60 * 60 * 1000;
  var timer;
  var dismissedInMemory = {};
  var storageAvailable = true;

  function storageKey(notice) {
    return 'abilitysheet:delareco-notice:v1:' + notice.dataset.userId;
  }

  function readDismissedAt(key) {
    if (!storageAvailable) return dismissedInMemory[key];
    try {
      return window.localStorage.getItem(key);
    } catch (error) {
      storageAvailable = false;
      return dismissedInMemory[key];
    }
  }

  function writeDismissedAt(key, value) {
    dismissedInMemory[key] = value;
    if (!storageAvailable) return;
    try {
      if (value === null) {
        window.localStorage.removeItem(key);
      } else {
        window.localStorage.setItem(key, value);
      }
    } catch (error) {
      // Keep the controls usable when browser storage is unavailable.
      storageAvailable = false;
    }
  }

  function syncNotice() {
    window.clearTimeout(timer);
    var notice = document.getElementById('delareco-notice');
    if (!notice) return;

    var dismissedAt = Number(readDismissedAt(storageKey(notice)));
    var elapsed = Date.now() - dismissedAt;
    var collapsed = dismissedAt > 0 && elapsed >= 0 && elapsed < dayInMilliseconds;
    notice.open = !collapsed;
    if (collapsed) {
      timer = window.setTimeout(syncNotice, dayInMilliseconds - elapsed);
    }
  }

  document.addEventListener('click', function(event) {
    var summary = event.target.closest('#delareco-notice summary');
    if (!summary) return;

    event.preventDefault();
    var notice = summary.parentElement;
    writeDismissedAt(storageKey(notice), notice.open ? String(Date.now()) : null);
    syncNotice();
  });

  document.addEventListener('turbolinks:load', syncNotice);
  document.addEventListener('turbolinks:before-cache', function() {
    window.clearTimeout(timer);
  });
  document.addEventListener('visibilitychange', function() {
    if (!document.hidden) syncNotice();
  });
  window.addEventListener('storage', function(event) {
    var notice = document.getElementById('delareco-notice');
    if (notice && (event.key === null || event.key === storageKey(notice))) syncNotice();
  });
})();
