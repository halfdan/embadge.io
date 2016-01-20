var semver = require('semver');
var express = require('express');
var app = express();

app.set('views', './views')
app.set('view engine', 'jade');
app.use(express.static('public'));
app.disable('x-powered-by');

function buildVersionString(start, end, range) {
  var versionString;

  if (start && semver.valid(start)) {
    versionString = start;
    if (end && semver.valid(end) && semver.lt(start, end)) {
      versionString = versionString + ' - ' + end;
    } else if (end && (!semver.valid(end) || !semver.lt(start, end))) {
      versionString = 'Invalid';
    } else {
      versionString = versionString + '+';
    }
  } else if (range && semver.validRange(range)) {
    versionString = semver.validRange(range);
  } else {
    versionString = 'Invalid';
  }

  return versionString;
}

app.get('/', function (req, res) {
  res.send('Hello World!');
});

app.get('/v1/badge.svg', function (req, res) {
  var versionString = buildVersionString(req.query.start, req.query.end, req.query.range),
      width = 178;

  if (versionString.length - 8 > 0) {
    width += (versionString.length - 8) * 6;
  }  

  res.setHeader('Content-Type', 'image/svg+xml');
  res.render('badge', {
    versionString: versionString,
    width: width,
    versionWidth: width - 102,
    textPosition: 102 + (width - 102)/2 
  });
});

app.listen(3000, function () {
  console.log('Example app listening on port 3000!');
});

