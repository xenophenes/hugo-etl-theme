// Copyright (c) 2017 Yihui Xie & 2018 Vincent Tam under MIT

(function() {
  var toc = document.getElementById('TableOfContents');
  if (!toc) return;
  do {
    var li, ul = toc.querySelector('ul');
    if (ul.childElementCount !== 1) break;
    li = ul.firstElementChild;
    if (li.tagName !== 'LI') break;
    // remove <ul><li></li></ul> where only <ul> only contains one <li>
    ul.outerHTML = li.innerHTML;
  } while (toc.childElementCount >= 1);
})();
