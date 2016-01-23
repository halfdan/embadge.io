(function() {
  var elements = document.getElementsByClassName('embadge'),
      url = '//embadge.io/v1/badge.svg';
  for (i=0; i < elements.length; i++) {
    var img = document.createElement('img'),
        el = elements[i];
    if (el.dataset.range) {
      img.src = url + '?range=' + el.dataset.range;
    } else {
      img.src = url + '?start=' + el.dataset.start;
      if (el.dataset.end) {
        img.src += '&end=' + el.dataset.end;
      }
    }
    el.appendChild(img);
  };
})();
