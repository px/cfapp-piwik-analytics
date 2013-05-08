// Generated by CoffeeScript 1.6.2
/*
#*  @name      Miniature Hipster
#*  @version   0.0.29b
#*  @author    Rob Friedman <px@ns1.net>
#*  @url       <http://playerx.net>
#*  @license   //github.com/px/cfapp-piwik-analytics/raw/master/LICENSE.txt
*/

/*
 CloudFlare.push( {
  paths: {
   'piwik_analytics':
   '//labs.variablesoftware.com/test/miniature-hipster/public/javascripts/'
    } } );
*/

/*
# CloudFlare.push( { verbose:1 } );
*/

/*
* definition for performance
*/
CloudFlare.define('piwik_analytics/perf', ['cloudflare/console'], function(__console) {
  var module;

  module = {};
  /*
  # now()
  #  return the window.performance.now()
  #  or the getTime() for less precision on
  #  browsers which are older
  */

  module.now = function() {
    var e, fake, p;

    fake = {};
    fake.now = function() {
      return new Date().getTime();
    };
    p = window.performance || window.mozPerformance || window.msPerformance || window.webkitPerformance || fake;
    try {
      return p.now();
    } catch (_error) {
      e = _error;
      window.console.log(e);
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
* definition for setup
*/


CloudFlare.define('piwik_analytics/setup', ['cloudflare/console', 'piwik_analytics/config', 'piwik_analytics/perf'], function(__console, __conf, __perf) {
  var e, setup, __defaultConf, __devConf;

  setup = {};
  setup.perfThen = __perf.now();
  __defaultConf = {
    _debug: false,
    default_debug: true,
    piwik_install: '/piwik',
    default_piwik_install: '/piwik',
    site_id: '',
    default_piwik_site_id: 1,
    paq_push: "",
    tracking_all_subdomains: true,
    tracking_do_not_track: false
  };
  if (__conf === void 0) {
    __conf = __defaultConf;
  }
  if (window.document.location.hostname === "js.cloudflare.com") {
    __console.error("js.cloudflare.com sandbox DETECTED! Using developer testing config.");
    __devConf = __defaultConf;
    __devConf._debug = true;
    __devConf.piwik_install = '//piwik-ssl.ns1.net';
    __devConf.default_piwik_install = '//piwik-ssl.ns1.net';
    __devConf.site_id = 'a';
    __devConf.default_piwik_site_id = 28;
    __conf = __devConf;
  }
  window._paq = window._paq || [];
  setup.setDefault = function(v, d, m) {
    var e3;

    try {
      if (v === void 0 || v === "") {
        __console.error("Invalid " + m + " = \"" + v + "\", using default " + m + " = \"" + d + "\" ");
        v = d;
      }
      return v;
    } catch (_error) {
      e3 = _error;
      v = d;
      __console.error(e3);
      return v;
    }
  };
  setup.site_id = __conf.site_id;
  setup.default_piwik_site_id = __conf.default_piwik_site_id;
  setup.piwik_install = __conf.piwik_install;
  setup.default_piwik_install = __conf.default_piwik_install;
  setup._debug = __conf._debug;
  setup.paq_push = __conf.paq_push;
  if (setup._debug != null) {
    CloudFlare.push({
      verbose: 1
    });
    window.localStorage.clear();
  }
  __console.log("END piwik_analytics/setup");
  try {
    __console.log((__perf.now() - setup.perfThen) + " ms" + "\t piwik_analytics/setup execution time");
  } catch (_error) {
    e = _error;
    __console.error("uhoh " + e);
  }
  return setup;
});

/*
# end of setup module
*/


/*
* definition for tracker
*/


CloudFlare.define('piwik_analytics/tracker', ['cloudflare/console', 'piwik_analytics/setup', 'piwik_analytics/perf'], function(__console, __conf, __perf) {
  var e, tracker;

  tracker = {};
  tracker.perfThen = __perf.now();
  tracker._debug = __conf._debug;
  /*
  # tracker.setSiteId()
  #
  #   checks for a null value, not a number, and assign's SiteId to default
  */

  tracker.setSiteId = function(_SiteId) {
    __conf.setDefault(_SiteId, __conf.default_piwik_site_id, "WebsiteId");
    if ((!isNaN(_SiteId)) && (_SiteId >= 1)) {
      if (__conf._debug != null) {
        __console.log("tracker.setSiteId\t = " + _SiteId);
      }
    } else {
      if (tracker._debug != null) {
        __console.error("Invalid WebsiteId = \'" + _SiteId + "\' is not a number; defaulting to \'" + __conf.default_piwik_site_id + "\'");
      }
      _SiteId = __conf.default_piwik_site_id;
    }
    window._paq.push(['setSiteId', unescape(_SiteId)]);
    return _SiteId;
  };
  /*
  # mypiwik.setTracker
  # sets the tracker for the client to use
  */

  tracker.setTracker = function(_install) {
    _install = __conf.setDefault(_install, __conf.default_piwik_install, "Install");
    if (tracker._debug != null) {
      __console.log("tracker.setTracker\t = \"" + unescape(_install) + "\"");
    }
    window._paq.push(['setTrackerUrl', unescape(_install + "/piwik.php")]);
    /*
    #return _install
    */

    return _install;
  };
  /*
  # configure with the defaults if undefined or invalid
  */

  tracker.piwik_install = tracker.setTracker(__conf.piwik_install);
  try {
    tracker.site_id = tracker.setSiteId(__conf.site_id);
  } catch (_error) {
    e = _error;
    __console.error("uhoh " + e);
  }
  if (tracker._debug != null) {
    CloudFlare.push({
      verbose: 1
    });
    window.localStorage.clear();
  }
  try {
    __console.log((__perf.now() - tracker.perfThen) + " ms" + "\t piwik_analytics/tracker execution time");
  } catch (_error) {
    e = _error;
    __console.error("uhoh " + e);
  }
  return tracker;
});

/*
# end of tracker module
*/


/*
* definition for piwik_js
*/


CloudFlare.define('piwik_analytics/piwik_js', ['piwik_analytics/tracker', 'cloudflare/console', 'piwik_analytics/perf'], function(__tracker, __console, __perf) {
  var e, module;

  module = {};
  module._isPiwik = false;
  module.perfThen = __perf.now();
  CloudFlare.require([unescape(__tracker.piwik_install + "/piwik.js")], module.isPiwik = true);
  try {
    __console.log((__perf.now() - module.perfThen) + " ms" + "\t piwik_analytics/piwik_js execution time");
  } catch (_error) {
    e = _error;
    __console.error("uhoh " + e);
  }
  return module;
});

/*
* end of piwik_js module
*/


/*
# piwik_analytics module definition
# REQUIRE:
#   -- defaults to {} and will assign test defaults
#  cloudflare/console for output to console
*/


CloudFlare.define('piwik_analytics', ['cloudflare/console', 'piwik_analytics/perf', 'piwik_analytics/setup', 'piwik_analytics/piwik_js'], function(__console, __perf, __setup, __js) {
  var e, myPiwik, __config, _debug;

  try {
    if (__setup._debug != null) {
      __console.log((__perf.now() - __setup.perfThen) + " ms" + "\t since \"piwik_analytics/setup\" Factory execution time");
    }
  } catch (_error) {
    e = _error;
    __console.error("uhoh " + e);
  }
  __config = {};
  _debug = __setup._debug || true;
  myPiwik = {};
  myPiwik.perfThen = __perf.now();
  window._paq = window._paq || [];
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
        if (_debug != null) {
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
    var wildcardZone;

    if (__config.tracking_all_subdomains === "true" || __config.tracking_all_subdomains === void 0) {
      wildcardZone = "*" + document.domain.split(".").slice(-2).join(".");
      window._paq.push(["setCookieDomain", wildcardZone]);
    }
    if (__config.tracking_do_not_track === "true" || __config.tracking_do_not_track === void 0) {
      window._paq.push(['setDoNotTrack', true]);
    } else {
      window._paq.push(['setDoNotTrack', false]);
    }
    return window._paq;
  };
  /*
  # myPiwik.paqPush()
  #     take options from a Piwik configuration
  #       We could have multiple trackers someday! TODO
  #      It's easy, just not supported in this App.
  #    push our Piwik options into the window._paq array
  #     send a trackPageView to the TrackerUrl
  */

  myPiwik.paqPush = function() {
    if ((!__config.paq_push) && (__config.paq_push !== void 0) && (__config.paq_push !== "")) {
      window._paq.push(unescape(__config.paq_push));
    }
    window._paq.push(['enableLinkTracking', true]);
    window._paq.push(['trackPageView']);
    return window._paq;
  };
  try {
    myPiwik.menuOpts();
  } catch (_error) {
    e = _error;
    __console.error("uhoh " + e);
  }
  try {
    myPiwik.paqPush();
  } catch (_error) {
    e = _error;
    __console.error("uhoh " + e);
  }
  if (_debug != null) {
    __console.log((__perf.now() - myPiwik.perfThen) + " ms" + "\t piwik_ananlytics Factory execution time");
    CloudFlare.require(['piwik_analytics/showPerf']);
    try {
      myPiwik.getVisitorId();
    } catch (_error) {
      e = _error;
      __console.error("uhoh " + e);
    }
  }
  return myPiwik;
});

/*
#end myPiwik module
*/


/*
* definition for performance
*/


CloudFlare.define('piwik_analytics/showPerf', ['cloudflare/console', 'piwik_analytics/setup', 'piwik_analytics/perf', 'piwik_analytics/piwik_js'], function(__console, __setup, __perf, __js) {
  var module;

  module = {};
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
          __console.log((__perf.now() - __js.perfThen) + " ms" + "\t Piwik library fetch/execute time");
        } catch (_error) {
          e = _error;
          __console.error("uhoh " + e);
        }
        try {
          __console.log((__perf.now() - __setup.perfThen) + " ms" + "\t Total execution time");
        } catch (_error) {
          e = _error;
          __console.error("uhoh " + e);
        }
        return true;
      }
    ]);
    return true;
  };
  if (__setup._debug != null) {
    module.showPerf();
  }
  return module;
});

/*
# end of perf module
*/

