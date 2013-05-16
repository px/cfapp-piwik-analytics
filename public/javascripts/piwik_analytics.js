/*
* @name      Miniature Hipster
* @version   0.0.34b
* @author    Rob Friedman
* @url       http://playerx.net
* @license   //github.com/px/cfapp-piwik-analytics/raw/master/LICENSE.txt
*/

/*
* Definition for performance module
*   provides timing method for the application
*/
CloudFlare.define('piwik_analytics/perf', ['cloudflare/console', 'piwik_analytics/config'], function(__console, __conf) {
  var fake, module, p;

  module = {};
  fake = {};
  fake.now = function() {
    return new Date().getTime();
  };
  p = window.performance || window.mozPerformance || window.msPerformance || window.webkitPerformance || fake;
  if (__conf._debug !== null) {
    CloudFlare.push({
      verbose: 1
    });
    window.localStorage.clear();
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
      __console.error(e);
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
* definition for tracker
*/


CloudFlare.define('piwik_analytics/tracker', ['cloudflare/console', 'piwik_analytics/config', 'piwik_analytics/perf'], function(__console, __conf, __perf) {
  var e, tracker;

  tracker = {};
  tracker.perfThen = __perf.now();
  tracker._debug = __conf._debug;
  tracker.isPiwik = false;
  window._paq = window._paq || [];
  /*
  # mypiwik.setTracker
  # sets the tracker for the client to use
  # will use passed _install or the default or '/piwik' as a failsafe
  */

  tracker.setTracker = function(_install) {
    if (_install == null) {
      _install = __conf.default_piwik_install || '/piwik';
    }
    tracker.perfThenJs = __perf.now();
    CloudFlare.require([unescape(_install + "/piwik.js")], tracker.isPiwik = true);
    if (tracker._debug !== null) {
      __console.log("tracker.setTracker\t Install URL \t= \"" + unescape(_install) + "\"");
    }
    window._paq.push(['setTrackerUrl', unescape(_install + "/piwik.php")]);
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
    if ((!isNaN(_SiteId)) && (_SiteId >= 1)) {
      if (tracker._debug !== null) {
        __console.log("tracker.setSiteId\t WebsiteId \t= " + _SiteId);
      }
    } else {
      if (tracker._debug !== null) {
        __console.error("tracker.setSiteId Invalid WebsiteId = \'" + _SiteId + "\' is not a number; defaulting to \'" + __conf.default_piwik_site_id + "\'");
      }
      _SiteId = __conf.default_piwik_site_id || '1';
    }
    window._paq.push(['setSiteId', unescape(_SiteId)]);
    return _SiteId;
  };
  /*
  # configure with the defaults if undefined or invalid
  */

  tracker.piwik_install = tracker.setTracker(__conf.piwik_install);
  tracker.site_id = tracker.setSiteId(__conf.site_id);
  if (tracker._debug !== null) {
    try {
      __console.log((__perf.now() - tracker.perfThen) + " ms" + "\t piwik_analytics/tracker execution time");
    } catch (_error) {
      e = _error;
      __console.error("uhoh " + e);
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


CloudFlare.define('piwik_analytics', ['cloudflare/console', 'piwik_analytics/perf', 'piwik_analytics/config', 'piwik_analytics/tracker'], function(__console, __perf, __conf, __tracker) {
  var e, myPiwik, pp,
    _this = this;

  myPiwik = {};
  myPiwik.perfThen = __perf.now();
  pp = function(ao) {
    var error, t;

    try {
      t = window._paq.push(ao);
      if (__conf._debug) {
        return __console.log("_paq.length=" + t + ",\t _paq.push " + ao + " ");
      }
    } catch (_error) {
      error = _error;
      return __console.error("uhoh! pp " + error);
    }
  };
  /*
  # myPiwik.getVisitorId
  # pushes a request for the Piwik VisitorId generated once piwik.js executes
  # sets the _visitorId to be the id, and returns it's value
  # will return the visitorId or false if piwik.js is still not loaded.
  #
  */

  myPiwik.getVisitorId = function() {
    var _visitorId;

    _visitorId = false;
    window._paq.push([
      function() {
        _visitorId = this.getVisitorId();
        if (__conf._debug !== null) {
          __console.log("Piwik.getVisitorId = " + _visitorId);
        }
        return _visitorId;
      }
    ]);
    return _visitorId;
  };
  /*
  # myPiwik.menuOpts
  */

  myPiwik.menuOpts = function() {
    var beginningcomma, doublecomma, e, fixdoublespaces, index, last, obj, option, pattern, trailingcomma, weirdcomma, wildcardZone, _i, _len, _ref;

    if (!isNaN(__conf.tracking_all_subdomains) && (__conf.tracking_all_subdomains > 1) && (__conf.tracking_all_subdomains <= 15)) {
      wildcardZone = "*." + document.domain.split(".").slice(-1 * __conf.tracking_all_subdomains).join(".");
      pp(["setCookieDomain", wildcardZone]);
    }
    if (__conf.tracking_do_not_track !== null) {
      pp(['setDoNotTrack', true]);
    } else {
      pp(['setDoNotTrack', false]);
    }
    if ((__conf.tracking_group_by_domain !== void 0) && (__conf.tracking_group_by_domain !== null)) {
      pp(["setDocumentTitle", document.domain + ' / ' + document.title]);
    }
    if ((__conf.tracking_all_aliases !== void 0) && (__conf.tracking_all_aliases !== null)) {
      try {
        pp(["setDomains", new Array(__conf.tracking_all_aliases)]);
      } catch (_error) {
        e = _error;
        __console.error("uhoh " + e);
      }
    }
    if ((__conf.paq_push !== void 0) && (__conf.paq_push !== null)) {
      index = 1;
      fixdoublespaces = /\s{2,}/g;
      doublecomma = /(\s{0,}\,){2,}/g;
      beginningcomma = /^([\,\s\S]{0,})\[/;
      trailingcomma = /\]([\,\s\S]{0,})$/;
      weirdcomma = /\s?\,\s?/g;
      pattern = /\]\s{0,}\,{0,}\s{0,}\[/;
      pattern = /\]\s{0,}\,{0,}\s{0,}\[?/;
      obj = __conf.paq_push;
      obj = obj.replace(doublecomma, ", ");
      obj = obj.replace(fixdoublespaces, ' ');
      obj = obj.replace(weirdcomma, '\, ');
      last = obj.length;
      _ref = obj.split(pattern);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        option = _ref[_i];
        if (option !== void 0 && option !== "") {
          option = option.replace(beginningcomma, '');
          option = option.replace(trailingcomma, ']');
          if (option.length > 8) {
            option = '[' + option + ']';
            try {
              pp(eval(option));
            } catch (_error) {
              e = _error;
              __console.error("uhoh! paq_push option=" + option + " (" + e + ")");
            }
          }
        }
        index++;
      }
    }
    pp(['enableLinkTracking', true]);
    pp(['trackPageView']);
    return window._paq;
  };
  try {
    myPiwik.menuOpts();
  } catch (_error) {
    e = _error;
    __console.error("uhoh " + e);
  }
  if (__conf._debug !== null) {
    __console.log((__perf.now() - myPiwik.perfThen) + " ms" + "\t piwik_ananlytics Factory execution time");
    CloudFlare.require(['piwik_analytics/showPerf']);
  }
  return myPiwik;
});

/*
#end myPiwik module
*/


/*
* definition for performance display
*/


CloudFlare.define('piwik_analytics/showPerf', ['cloudflare/console', 'piwik_analytics/config', 'piwik_analytics/perf', 'piwik_analytics/tracker'], function(__console, __conf, __perf, __tracker) {
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
          __console.log((__perf.now() - __tracker.perfThenJs) + " ms" + "\t Piwik library fetch/execute time");
        } catch (_error) {
          e = _error;
          __console.error("uhoh " + e);
        }
        try {
          __console.log((__perf.now() - __perf.perfThen) + " ms" + "\t Total execution time");
        } catch (_error) {
          e = _error;
          __console.error("uhoh " + e);
        }
        return true;
      }
    ]);
    return true;
  };
  if (module._debug !== null) {
    module.showPerf();
    __console.log((__perf.now() - module.perfThen) + " ms" + "\t piwik_analytics/showPerf Factory execution time");
  }
  return module;
});

/*
# end of perf module
*/

