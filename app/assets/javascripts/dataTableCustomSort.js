$.extend($.fn.DataTable.ext.oSort, {
  'custom': function(a) {
    return a;
  },
  'custom-asc': function(x, y) {
    x = parseFloat(x);
    y = parseFloat(y);
    if (x < y) {
      return -1;
    } else if (x > y) {
      return 1;
    } else {
      return 0;
    }
  },
  'custom-desc': function(x, y) {
    x = parseFloat(x);
    y = parseFloat(y);
    if (x < y) {
      return 1;
    } else if (x > y) {
      return -1;
    } else {
      return 0;
    }
  }
});
