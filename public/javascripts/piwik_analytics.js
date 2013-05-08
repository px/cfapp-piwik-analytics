// Generated by CoffeeScript 1.6.2
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
# piwik_analytics module definition
# stick with commas for sep
# REQUIRE:
#  piwik_analytics/config
#   -- defaults to {} and will assign test defaults
#  cloudflare/console for output to console
#  piwik.js library -- needs logic :(
*/
CloudFlare.define('piwik_analytics', ['piwik_analytics/config', 'cloudflare/console'], function(__config, __console) {
  var default_debug, default_piwik_install, default_piwik_site_id, myPiwik, now, perfThen, setDefault, _isPiwik, _linkTracking, _visitorId;

  if (__config == null) {
    __config = {};
  }
  /*
  # now()
  #  return the window.performance.now()
  #  or the getTime() for less precision on
  #  browsers which are older
  */

  now = function() {
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
  perfThen = now();
  window._paq = window._paq || [];
  myPiwik = {};
  _isPiwik = false;
  _visitorId = false;
  _linkTracking = true;
  default_debug = true;
  default_piwik_install = "/piwik";
  default_piwik_site_id = "1";
  if (window.document.location.hostname === "js.cloudflare.com") {
    default_debug = true;
    default_piwik_install = "//piwik-ssl.ns1.net";
    default_piwik_site_id = "28";
  }
  /*
  #
  */

  setDefault = function(v, d, m) {
    var e3;

    try {
      if (v === void 0) {
        v = d;
        __console.log("Using test default " + m + " \t = " + d);
      }
      return v;
    } catch (_error) {
      e3 = _error;
      v = d;
      __console.error(e3);
      return v;
    }
  };
  __config._debug = setDefault(__config._debug, default_debug, "Debug");
  __config.piwik_install = setDefault(__config.piwik_install, default_piwik_install, "Install");
  __config.site_id = setDefault(__config.site_id, default_piwik_site_id, "WebsiteId");
  if (__config._debug != null) {
    CloudFlare.push({
      verbose: 1
    });
    __console.log("Hello from the Piwik Analytics CloudFlare App!");
    __console.log((now() - perfThen) + " ms" + "\t Module begin execution time");
    window.localStorage.clear();
  }
  /*
  # myPiwik.fetch
  #   uses CloudFlare.require to fetch files specified
  #   by a passed array
  */

  myPiwik.fetch = function(u) {
    return CloudFlare.require(u);
  };
  /*
  # overload for callback functionality
  */

  myPiwik.fetch = function(u, r) {
    return CloudFlare.require(u, r);
  };
  /*
  # myPiwik.getVisitorId
  # pushes a request for the Piwik VisitorId generated once piwik.js executes
  # sets the _visitorId to be the id, and returns it's value
  # will return the visitorId or false if piwik.js is still not loaded.
  #
  */

  myPiwik.getVisitorId = function() {
    window._paq.push([
      function() {
        _visitorId = this.getVisitorId();
        if (__config._debug != null) {
          __console.log("_visitorId = " + _visitorId);
        }
        return _visitorId;
      }
    ]);
    return _visitorId;
  };
  /*
  # myPiwik.perf
  #   Use the _paq array to push performance metrics to the
  #     Javascript console once piwik.js is loaded.
  */

  myPiwik.perf = function() {
    var perfThen_piwik_js;

    perfThen_piwik_js = now();
    window._paq.push([
      function() {
        __console.log((now() - perfThen_piwik_js) + " ms" + "\t Piwik library fetch/load time");
        __console.log((now() - perfThen) + " ms" + "\t Total execution time");
        return true;
      }
    ]);
    return true;
  };
  /*
  # myPiwik.setSiteId()
  #
  #   checks for a null value, not a number, and assign's SiteId to default
  */

  myPiwik.setSiteId = function(_SiteId) {
    if (_SiteId == null) {
      _SiteId = default_piwik_site_id;
    }
    if (!isNaN(_SiteId)) {
      if (__config._debug != null) {
        __console.log("myPiwik.setSiteId\t = " + _SiteId);
      }
    } else {
      if (__config._debug != null) {
        __console.error("myPiwik.setSiteId -- Invalid Website Id = " + _SiteId + " ; defaulting to " + default_piwik_site_id);
      }
      _SiteId = default_piwik_site_id;
    }
    window._paq.push(['setSiteId', unescape(_SiteId)]);
    return _SiteId;
  };
  /*
  # mypiwik.setInstall
  # sets the tracker for the client to use
  */

  myPiwik.setInstall = function(_install) {
    if (_install == null) {
      _install = default_piwik_install;
    }
    if (__config._debug != null) {
      __console.log("myPiwik.setInstall\t = \"" + unescape(_install) + "\"");
      myPiwik.perf();
    }
    myPiwik.fetch([unescape(_install + "/piwik.js")]);
    window._paq.push(['setTrackerUrl', unescape(_install + "/piwik.php")]);
    /*
    #return _install
    */

    return _install;
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
  /*
  window.CloudFlare.require(['https://cdnjs.cloudflare.com/ajax/libs/piwik/1.11.1/piwik.js'], function() {
  window.console.log("piwik.js Module execution time =")
  window.console.log(now() - window.perfThen)
  }
  );
  */

  myPiwik.setInstall(__config.piwik_install);
  myPiwik.setSiteId(__config.site_id, __config.default_site_id);
  myPiwik.menuOpts();
  myPiwik.paqPush();
  if (__config._debug != null) {
    __console.log((now() - perfThen) + " ms" + "\t Module execution time");
  }
  return myPiwik;
});

/*
#end myPiwik module
*/

