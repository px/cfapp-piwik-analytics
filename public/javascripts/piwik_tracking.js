/* This is the sample application
 *
 *
 *
 * */

CloudFlare.require(
    ['cloudflare/console','piwik/js'],
    function(console) {

      console.log("Hello, CloudFlare!");
    }
    );

/*
 * This is Miniature Hipster
 *
 *
 * */

CloudFlare.define(
    "miniaturehipster/js",
    // be sure to keep the same order here in the modules
    [ "cloudflare/config", "cloudflare/console", "cloudflare/dom", 'cloudflare/user', "miniaturehipster/config"],

    // as you have here in the parameters
    //
    function(config, console, dom, user, _config) {

      "use strict";


      var Piwik = function Piwik(config) {
        this.piwikEl = null;
        this._config = _config;
        //   this.cookie = "__piwik_tracking_cfapp_px";

      };

      var piwik = new Piwik (_config);



      Piwik.prototype.activate = function() {
        // check to see if our configuration is correct, then run the setup.
        //  if (typeof this.config.site_id == "string" && this.config.side_id !== "") {

        // run setup() 
        this.setup();
        //  }


      };

      function noScript(){
        var test_site = this.config.piwik_receiver || "//pikwik-ssl.ns1.net/piwik.php";
        test_site += "?id="+this.config.site_id+"&amp;rec=1";
        var script = dom.createElement("noscript");
        var cursor = dom.getElementsByTagName('script', true)[0];
        cursor.parentNode.insertBefore(script, cursor);
      }

      function piwikScript(){
        var piwik_js = this.config.piwik_js || "//cdnjs.cloudflare.com/ajax/libs/piwik/1.10.1/piwik.js";
        var script = dom.createElement("script");
        // var cursor = document.getElementsByTagName('script', true)[0];
        var cursor = dom.getElementsByTagName('script', true)[0];
        // for html5 does not need type declaration
        dom.setAttribute(script, "type", "text/javascript");
        dom.setAttribute(script, "src", piwik_js);
        cursor.parentNode.insertBefore(script, cursor);
      }


      /*
       * setup()
       * Load our program into dom
       * */
      Piwik.prototype.setup = function() {
        piwikScript();
        noScript();
      };

      // does this even work here? 
      console.log("hello piwik");

      //if (!window.jasmine) {
      // activate if not in jasmine
      piwik.activate();

      console.log("piwik loaded. probably.");

      //}

      return piwik;

    }
);

