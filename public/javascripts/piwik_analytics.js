// Generated by CoffeeScript 1.4.0
/*
* This is Miniature Hipster
*  @name      Miniature Hipster
*  @version   0.0.18a
*  @author    Rob Friedman <px@ns1.net>
*  @url       <http://playerx.net>
*  @license   https://github.com/px/cfapp-piwik-analytics/raw/master/LICENSE.txt
*  @todo      TODO: this is probably from my testapp. meh
*               there is a weird difference between Chrome and Safari with
*                null in Cloudflare is undefined on Chrome
*                null in CloudFlare is null on Safari
*                null in CloufFlare is undefined in Firefox
*/

var conserr, consl, fixScheme, loadScript, p, _debug;

p = window._pk_loaded = {
  stuff: "stuff"
};

/*
* simple stylized console output for my app
*/


consl = function(m) {
  return window.console.log("_px_> " + m);
};

/*
* simple stylized console error output for my app
*/


conserr = function(m) {
  return window.console.error("*px**> " + m);
};

try {
  _debug = window.__CF.AJS.piwik_analytics._debug;
} catch (e) {
  conserr("Where is CloudFlare?");
  _debug = true;
}

_debug = true;

window._paq = window._paq || [];

window._paq.push([
  function() {
    return window._pk_visitor_id = this.getVisitorId();
  }
]);

fixScheme = function(url) {
  var url2;
  if (_debug) {
    consl("fixScheme(" + url + ")");
  }
  if (_debug) {
    consl("window.location.protocol=" + window.location.protocol);
  }
  url2 = url;
  if (/^(http).*/.test(url)) {
    url2 = url;
  } else {
    url2 = "https:" + url;
  }
  return url2;
};

/*
* loadScript(f)
* use CloudFlare.require to load the javascript f requested
* and then execute the callback c
*/


loadScript = function(f, callback) {
  if (_debug) {
    consl("loadScript via CloudFlare.require( [" + f + "], " + callback(+")"));
  }
  return CloudFlare.require([f], callback);
};

/*
# piwik_analytics module definition
#
# Requires piwik_analytics/config FIXME not true, reads from embedded
#     CDATA from CloudFlare currently; Hopefully will fix to use param arguments
# 
# TODO: Debating putting logic to call for piwik.js above so that way it can be loaded
#     sooner most likely.
# stick with commas for sep
*/


CloudFlare.define("piwik_analytics", ["piwik_analytics/config"], function(_config) {
  "use strict";

  var myPiwik, _default_piwik_version, _delay;
  myPiwik = {};
  _config = _config || {};
  try {
    _config = window.__CF.AJS.piwik_analytics || {};
  } catch (e) {
    conserr("The CloudFlare _config is broken!!!");
  }
  /* because sometimes a minor delay is needed, in seconds.
  * FIXME because I'm sure we can do without.
  */

  _delay = 0.11;
  _default_piwik_version = "1.10.1";
  if (_debug) {
    consl("Hello from the Piwik CloudFlare App! Object?->" + _config);
    consl("window.localStorage.clear() === undefined? " + window.localStorage.clear());
  }
  /*
    # myPiwik.isPiwik()
    * pushes a request for the Piwik VisitorId generated once piwik.js executes
    * performs a rudimentary test to see if the piwik.js loads
    * if it does, then it will return a yes, other no
    *
  */

  myPiwik.isPiwik = function() {
    if (_debug) {
      consl("isPiwik() loaded?");
    }
    window._paq = window._paq || [];
    try {
      window._paq.push([
        function() {
          return window._pk_visitor_id = this.getVisitorId();
        }
      ]);
    } catch (e) {
      if (_debug) {
        conserr("There is an issue with window._paq; " + e);
      }
    }
    try {
      if (window._pk_visitor_id === void 0 || window._pk_visitor_id === "") {
        if (_debug) {
          conserr(" no window._pk_visitor_id piwik maybe failed to load!!! Oh Noe. ");
        }
        return false;
      } else if (typeof window._pk_visitor_id === "string" && window._pk_visitor_id !== "") {
        if (_debug) {
          consl("Piwik loaded... probably maybe. window._pk_visitor_id='" + window._pk_visitor_id + "', and tracker hit.");
        }
        return true;
      }
    } catch (e) {
      conserr("isPiwik() " + e);
    }
    return false;
  };
  /*
  * myPiwik.activate()
  * TODO: break this into three different methods
  *         one; which determines the tracking library URL to load
  *         two; determines a valid SiteId
  *         three; another which determines a valid TrackerURL
  * This will currently:
  *     fixup a missing siteId to be id=1
  *     determine how to load and activate the piwik.js from desired location
  *     FIXME; will not fixup the tracker url for missing scheme on file:// url locations
  */

  myPiwik.activate = function() {
    var _js, _site_id;
    if (_debug) {
      consl("myPiwik.activate() started");
    }
    _js = _config.default_piwik_js;
    if (_debug) {
      if ((_config.use_cdnjs === true) && (_config.use_cdnjs !== null || _config.use_cdnjs !== void 0)) {
        consl("_config.use_cdnjs=" + _config.use_cdnjs);
      } else {
        conserr("_config.use_cdnjs=" + _config.use_cdnjs);
      }
    }
    if (_config.piwik_js !== null && _config.piwik_js !== void 0 && _config.use_cdnjs === null || _config.use_cdnjs === void 0) {
      if (_debug) {
        consl("attempting to use configured piwik_js=" + _config.piwik_js);
      }
      _js = _config.piwik_js;
    } else if (_config.use_cdnjs === true) {
      if (_debug) {
        consl("use_cdnjs is enabled; " + _config.default_piwik_js);
      }
      _js = _config.default_piwik_js;
    } else {
      if (_debug) {
        consl("failsafe default to cdnjs " + _config.default_piwik_js);
      }
    }
    loadScript(unescape(_js), "myPiwik.isPiwik()");
    _site_id = _config.default_site_id;
    if (_config.site_id !== null || _config.site_id !== void 0 && !isNaN(_config.site_id) && _config.site_id !== "") {
      if (_debug) {
        consl("Using valid site_id from _config " + _config.site_id);
      }
      _site_id = _config.site_id;
    } else {
      if (_debug) {
        conserr("Invalid site_id; defaulting to " + _config.default_site_id);
      }
    }
    if (_config.piwik_tracker === null || _config.piwik_tracker === void 0) {
      _config.piwik_tracker = _config.default_piwik_tracker;
    } else {
      if (_debug) {
        consl("myPiwik.activate() completed");
      }
    }
    return true;
  };
  /*
  * myPiwik.paqPush()
  *   take options from a Piwik configuration
  *     We could have multiple trackers someday! TODO
  *     It's easy, just not supported in this App.
  *   push our Piwik options into the window._paq array
  *   send a trackPageView to the TrackerUrl
  */

  myPiwik.paqPush = function() {
    if (_debug) {
      consl("myPiwik.paqPush()");
    }
    window._paq = window._paq || [];
    window._paq.push([
      function() {
        return window._pk_visitor_id = this.getVisitorId();
      }
    ]);
    window._paq.push(['setSiteId', unescape(_config.site_id)]);
    window._paq.push(['setTrackerUrl', unescape(_config.piwik_tracker)]);
    if (_config.link_tracking === true) {
      window._paq.push(['enableLinkTracking', true]);
    } else {
      window._paq.push(['enableLinkTracking', false]);
    }
    if (_config.set_do_not_track === true) {
      window._paq.push(['setDoNotTrack', true]);
    } else {
      window._paq.push(['setDoNotTrack', false]);
    }
    if ((!_config.paq_push) && (_config.paq_push !== void 0) && (_config.paq_push !== "")) {
      window._paq.push(_config.paq_push);
    }
    window._paq.push(['trackPageView']);
    if (_debug) {
      consl("paqPush() finished ok! _paq=" + window._paq);
    }
    return window._paq;
  };
  /*
  * noScript()
  * this is kind of a waste as it will never get run if javascript is not enabled
  */

  myPiwik.noScript = function() {
    var cursor, script, test_site;
    if (_debug) {
      consl("myPiwik.noScript()");
    }
    test_site = fixScheme(unescape(_config.piwik_tracker));
    test_site += "?id=" + _config.site_id + "&amp;rec=1";
    if (_debug) {
      consl("noScript| test_site=" + test_site);
    }
    script = document.createElement("noscript");
    cursor = document.getElementsByTagName("script", true)[0];
    cursor.parentNode.insertBefore(script, cursor);
    return true;
  };
  /*
  * do stuff to get the party started
  */

  myPiwik.activate();
  myPiwik.paqPush();
  /*
  * instantiate and configure a new instance of Piwik module when it is returned
  * Something like below
  * # myPiwik = new Piwik(_config)
  */

  return myPiwik;
});

/*
* Require our piwik_analytics module to be loaded, and our configuration.
*/


window._pk_loaded = CloudFlare.require(["piwik_analytics"], function(_config) {
  return true;
});

/*
* CloudFlare has .then methods for performing other actions once a module has been required.
* We're not using them, but they're here.
*/


window._pk_loaded.then(function() {
  return modules({
    modules: modules
  }, function() {
    return error({
      console: console
    });
  });
});
