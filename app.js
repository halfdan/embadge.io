var semver = require('semver');
var express = require('express');
var request = require('request');
var app = express();

app.set('views', './views');
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

function renderBadge(res, versionString, labelText) {
  var separator = (labelText.length + 4) * 6,
      width = separator + (versionString.length + 4) * 6;

  res.setHeader('Content-Type', 'image/svg+xml');
  res.render('badge', {
    versionString: versionString,
    width: width,
    versionWidth: width - separator,
    textPosition: separator + (width - separator)/2,
    separator: separator,
    labelText: labelText,
    labelPosition: separator / 2
  });
}

app.get('/', function (req, res) {
  res.render('index');
});

app.get('/v1/badge.svg', function (req, res) {
  var versionString = buildVersionString(req.query.start, req.query.end, req.query.range),
      labelText = req.query.label || 'ember-versions';

  renderBadge(res, versionString, labelText);
});

app.get('/v1/:username/:repo/:branch/:package.svg', function (req, res) {
  var packageName = req.params.package,
      jsonFileName;

  switch (packageName) {
    case 'ember':
      jsonFileName = 'bower.json';
      break;

    case 'ember-data':
    case 'ember-cli':
      jsonFileName = 'package.json';
      break;

    default:
      res.status(400).send('Invalid package');
      return;
  }

  var jsonUrl = 'https://raw.githubusercontent.com/'
                + req.params.username + '/'
                + req.params.repo + '/'
                + req.params.branch + '/'
                + jsonFileName;
  request(jsonUrl, function (error, response, body) {
    if (!error && response.statusCode == 200) {
      var json = JSON.parse(body),
          range = (json.dependencies && json.dependencies[packageName])
                  || (json.devDependencies && json.devDependencies[packageName]),
          versionString = buildVersionString(null, null, range),
          labelText = req.query.label || packageName;

      if (!range) {
        res.status(400).send('Package ' + packageName + ' not found in ' + jsonFileName);
        return;
      }

      renderBadge(res, versionString, labelText);
    } else {
      res.status(response.statusCode).send(jsonUrl + ': ' + response.statusMessage);
    }
  });
});

app.listen(3000, function () {
  console.log('Listening on port 3000!');
});
