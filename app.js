var semver = require('semver');
var express = require('express');
var expressSession = require('express-session');
var bodyParser = require('body-parser');
var cookieParser = require('cookie-parser');
var passport = require('passport');
var GitHubStrategy = require('passport-github2');
passport.use(new GitHubStrategy({
    clientID: process.env.CLIENT_ID,
    clientSecret: process.env.CLIENT_SECRET,
    callbackURL: process.env.HOST_URL + '/callback',
  },
  function(accessToken, refreshToken, profile, done) {
    console.log(JSON.stringify(profile));
    done(null, profile);
  }
));

var app = express();
app.use(express.static('public'));
app.use(cookieParser());
app.use(bodyParser());
app.use(expressSession({ secret: 'keyboard cat' }));
app.use(passport.initialize());
app.use(passport.session());

app.set('views', './views');
app.set('view engine', 'jade');
app.disable('x-powered-by');

app.get('/login',
  passport.authenticate('github', { scope: [ 'user:email' ] }));

app.get('/callback', 
  passport.authenticate('github', { failureRedirect: '/login' }),
  function(req, res) {
    // Successful authentication, redirect home.
    res.redirect('/');
  });

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
  res.render('index');
});

app.get('/v1/badge.svg', function (req, res) {
  var versionString = buildVersionString(req.query.start, req.query.end, req.query.range),
      labelText = req.query.label || 'ember-versions',
      width,
      separator;

  separator = (labelText.length + 4) * 6;
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
});


app.listen(3000, function () {
  console.log('Listening on port 3000!');
});
