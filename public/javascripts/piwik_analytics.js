/*
* @name      Miniature Hipster
* @author    Rob Friedman
* @url       http://playerx.net
* @copyright 2013 Rob Friedman
* @license   //github.com/px/cfapp-piwik-analytics/raw/master/LICENSE.txt
*/

/*
* Definition for performance module
*   provides timing method for the application
*/
CloudFlare.define('piwik_analytics/perf', ['cloudflare/console', 'piwik_analytics/config'], function(__cons, __conf) {
  var fake, module, p, windowAlias;

  module = {};
  fake = {};
  fake.now = function() {
    return new Date().getTime();
  };
  windowAlias = window;
  p = windowAlias.performance || windowAlias.mozPerformance || windowAlias.msPerformance || windowAlias.webkitPerformance || fake;
  if (__conf._debug !== null) {
    CloudFlare.push({
      verbose: 1
    });
    windowAlias.localStorage.clear();
  }
  /*
  # now()
  #  return the window.performance.now()
  #  or the getTime() for less precision on
  #  browsers which are older
  */

  module.now = function() {
    var e;

    try {
      return p.now();
    } catch (_error) {
      e = _error;
      __cons.error(e);
      return fake.now();
    }
  };
  module.perfThen = module.now();
  return module;
});

/*
# end of perf module
*/


/*
* definition for tracker module
*   attempts to:
*     determine a valid installation root
*     fetch and load the piwik.js library
*/


CloudFlare.define('piwik_analytics/tracker', ['cloudflare/console', 'piwik_analytics/config', 'piwik_analytics/perf'], function(_con, _cfg, _perf) {
  var e, tracker, windowAlias;

  tracker = {};
  tracker.perfThen = _perf.now();
  tracker._debug = _cfg._debug;
  tracker.isPiwik = false;
  windowAlias = window;
  windowAlias._paq = windowAlias._paq || [];
  /*
  # mypiwik.setTracker
  # sets the tracker for the client to use
  # will use passed _install or the default or '/piwik' as a failsafe
  */

  tracker.setTracker = function(_install) {
    if (_install == null) {
      _install = _cfg.default_piwik_install || '/piwik';
    }
    tracker.perfThenJs = _perf.now();
    windowAlias = window;
    CloudFlare.require([unescape(_install + "/piwik.js")], tracker.isPiwik = true);
    if (tracker._debug !== null) {
      _con.log("Piwik Install\t=\"" + (unescape(_install)) + "\"");
    }
    windowAlias._paq.push(['setTrackerUrl', unescape(_install + "/piwik.php")]);
    /*
    #return _install
    */

    return _install;
  };
  /*
  # tracker.setSiteId()
  #
  #   checks for a number value
  #   and a number >=1
  #   a null value, not a number, and assign's SiteId to default or '1'
  */

  tracker.setSiteId = function(_SiteId) {
    var defaultSiteId;

    defaultSiteId = _cfg.default_piwik_site_id || '1';
    if ((!isNaN(_SiteId)) && (_SiteId >= 1)) {
      if (tracker._debug !== null) {
        _con.log("Piwik WebsiteId\t=\"" + _SiteId + "\"");
      }
    } else {
      if (tracker._debug !== null) {
        _con.error(("Invalid WebsiteId\t=\"" + _SiteId + "\" is not a number;") + (" defaulting to \'" + defaultSiteId + "\'"));
        _SiteId = defaultSiteId;
      }
    }
    windowAlias._paq.push(['setSiteId', unescape(_SiteId)]);
    return _SiteId;
  };
  /*
  # configure with the defaults if undefined or invalid
  */

  tracker.piwik_install = tracker.setTracker(_cfg.piwik_install);
  tracker.site_id = tracker.setSiteId(_cfg.site_id);
  if (tracker._debug !== null) {
    try {
      _con.log(("" + (_perf.now() - tracker.perfThen) + " ms\t") + "\"piwik_analytics/tracker\" time");
    } catch (_error) {
      e = _error;
      _con.error("uhoh " + e);
    }
  }
  return tracker;
});

/*
# end of tracker module
*/


/*
# piwik_analytics module definition
# REQUIRE:
#   -- defaults to {} and will assign test defaults
#  cloudflare/console for output to console
*/


CloudFlare.define('piwik_analytics', ['cloudflare/console', 'piwik_analytics/perf', 'piwik_analytics/config', 'piwik_analytics/tracker'], function(_con, _perf, _cfg, _tracker) {
  var e, mp, myPiwik, paqPush, wa, _err,
    _this = this;

  myPiwik = {};
  mp = myPiwik;
  mp.perfThen = _perf.now();
  wa = window;
  _err = "uhoh! ";
  paqPush = function(ao) {
    var error, size;

    wa = window;
    try {
      size = 0;
      switch (typeof ao) {
        case "object":
          size = wa._paq.push(ao);
          break;
        case "string":
          size = wa._paq.push([ao]);
          break;
        default:
          _con.error("" + _err + " -- not sure what type this is " + (typeof ao));
      }
      if (_cfg._debug) {
        return _con.log("_paq.length=" + size + ",\t" + ao);
      }
    } catch (_error) {
      error = _error;
      return _con.error("" + _err + " pp (" + error + ")");
    }
  };
  /*
  # mp.getVisitorId
  # pushes a request for the Piwik VisitorId generated once piwik.js executes
  # sets the _visitorId to be the id, and returns it's value
  # will return the visitorId or false if piwik.js is still not loaded.
  #
  */

  mp.getVisitorId = function() {
    var _visitorId;

    _visitorId = false;
    wa = window;
    wa._paq.push([
      function() {
        _visitorId = this.getVisitorId();
        if (_cfg._debug !== null) {
          _con.log("Piwik.getVisitorId = " + _visitorId);
        }
        return _visitorId;
      }
    ]);
    return _visitorId;
  };
  /*
  # mp.advMenuOpts
  */

  mp.advMenuOpts = function() {
    var beginningcomma, doublecomma, e, evileval, fixdoublespaces, index, m, obj, option, pattern, trailingcomma, weirdcomma, _i, _len, _paq_push, _ref;

    wa = window;
    m = "ADVANCED FEATURES ";
    if (_cfg._debug != null) {
      _con.log(m + "BEGIN");
    }
    _paq_push = _cfg.paq_push;
    if ((_paq_push !== void 0) && (_paq_push !== null)) {
      index = 1;
      fixdoublespaces = /\s{2,}/g;
      doublecomma = /(\s{0,}\,){2,}/g;
      beginningcomma = /^([\,\s\S]{0,})\[/;
      trailingcomma = /\]([\,\s\S]{0,})$/;
      weirdcomma = /\s?\,\s?/g;
      evileval = /eval\s{0,}\(.+\)/g;
      pattern = /\]\s{0,}\,{0,}\s{0,}\[?/;
      obj = _paq_push;
      obj = obj.replace(doublecomma, ", ");
      obj = obj.replace(fixdoublespaces, ' ');
      obj = obj.replace(weirdcomma, '\, ');
      _ref = obj.split(pattern);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        option = _ref[_i];
        if (option !== void 0 && option !== "") {
          if (/eval\s{0,}\(.+\)/g.test(option)) {
            _con.error("" + _err + " -- sorry buddy eval() usage is not allowed.");
            continue;
          }
          option = option.replace(beginningcomma, '');
          option = option.replace(trailingcomma, ']');
          if (option.length > 8) {
            option = '[' + option + ']';
            try {
              paqPush(eval(option));
            } catch (_error) {
              e = _error;
              _con.error("" + _err + " paq_push option=" + option + " (" + e + ")");
            }
          }
        }
        index++;
      }
    }
    if (_cfg._debug != null) {
      _con.log(m + "END");
    }
    return wa._paq;
  };
  /*
  # mp.menuOpts
  #   the basic menu options
  */

  mp.menuOpts = function() {
    var e, tmp, wildcardZone;

    paqPush(['enableLinkTracking', true]);
    if (_cfg.tracking_do_not_track !== null) {
      paqPush(['setDoNotTrack', true]);
    } else {
      paqPush(['setDoNotTrack', false]);
    }
    tmp = _cfg.tracking_group_by_domain;
    if ((tmp !== void 0) && (tmp !== null)) {
      paqPush(["setDocumentTitle", "" + document.domain + " / " + document.title]);
    }
    tmp = _cfg.tracking_all_subdomains;
    if (!isNaN(tmp) && (tmp > 1) && (tmp <= 15)) {
      wildcardZone = "." + document.domain.split(".").slice(-1 * tmp).join(".");
      paqPush(["setCookieDomain", wildcardZone]);
    }
    tmp = _cfg.tracking_all_aliases;
    if ((tmp !== void 0) && (tmp !== null)) {
      try {
        paqPush(["setDomains", new Array(tmp)]);
      } catch (_error) {
        e = _error;
        _con.error("" + _err + " tracking_all_aliases=" + tmp + " \(" + e + "\)");
      }
    }
    if ((_cfg.advMenu !== void 0) && (_cfg.advMenu !== null)) {
      mp.advMenuOpts();
    }
    paqPush(['trackPageView']);
    return wa._paq;
  };
  try {
    mp.menuOpts();
  } catch (_error) {
    e = _error;
    _con.error("" + _err + " Main " + e);
  }
  if (_cfg._debug !== null) {
    _con.log(("" + (_perf.now() - mp.perfThen) + " ms\t") + "\"piwik_analytics\" time");
  }
  return mp;
});

/*
#end myPiwik module
*/


/*
* definition for performance display
*/


CloudFlare.define('piwik_analytics/showPerf', ['cloudflare/console', 'piwik_analytics/config', 'piwik_analytics/perf', 'piwik_analytics/tracker'], function(__cons, __conf, __perf, __tracker) {
  var module;

  module = {};
  module.perfThen = __perf.now();
  module._debug = __conf._debug;
  /*
  # showPerf
  #   Use the _paq array to push functions which
  #   display performance metrics
  #   with the Javascript console once piwik.js is loaded.
  */

  module.showPerf = function() {
    window._paq.push([
      function() {
        var e;

        try {
          __cons.log((__perf.now() - __tracker.perfThenJs) + " ms" + "\tPiwik library fetch/exec time");
        } catch (_error) {
          e = _error;
          __cons.error("uhoh " + e);
        }
        try {
          __cons.log((__perf.now() - __perf.perfThen) + " ms" + "\tTotal exec time");
        } catch (_error) {
          e = _error;
          __cons.error("uhoh " + e);
        }
        return true;
      }
    ]);
    return true;
  };
  if (module._debug !== null) {
    module.showPerf();
    __cons.log((__perf.now() - module.perfThen) + " ms" + "\t\"piwik_analytics/showPerf\" time");
  }
  return module;
});

/*
# end of perf module
*/

