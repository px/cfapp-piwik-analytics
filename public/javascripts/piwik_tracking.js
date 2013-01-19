/* This is the sample application
 *
 *
 *
 * */

CloudFlare.require(
    ['cloudflare/console','piwik'],
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
    "piwik_analytics",
    // be sure to keep the same order here in the modules
    [ "cloudflare/config", "cloudflare/console", "cloudflare/dom", 'cloudflare/user', "piwik_analytics/config"],

    // as you have here in the parameters
    //
    function(config, console, dom, user, _config) {
      // re-enable strict someday!
      //"use strict";


      var paq_push="";
      paq_push+='var _paq=_paq || []';
      paq_push+='_paq.push(["setTrackerUrl",'+ this._config.piwik_reciever + ']);';
      paq_push+='_paq.push(["setSiteId",'+ this._config.site_id + ']);';
      paq_push+='_paq.push(["enableLinkTracking",'+this._config.link_tracking + ']);';
      paq_push+='_paq.push(["trackPageView"]);';

      /* 
         var _paq=_paq||[];
         var pkBaseURL="https://piwik-ssl.ns1.net/";
         _paq.push(['setSiteId',6]);
         _paq.push(['setTrackerUrl',pkBaseURL+'piwik.php']);
         _paq.push(['setDocumentTitle',document.title]);
         _paq.push(['setLinkTrackingTimer',500]);
         _paq.push(['setDomains','*.ns1.net','ns1.net','beta.ns1.net']);
         _paq.push(['setCookieDomain','*.ns1.net','ns1.net','beta.ns1.net']);
         _paq.push(['setDoNotTrack',true]);
         _paq.push(['redirectFile','http://ns1.net']);
         _paq.push(['setCountPreRendered',true]);
         _paq.push(['setHeartBeatTimer',30,60]);
         _paq.push(['setVisitorCookieTimeout',946080000]);
         _paq.push(['setSessionCookieTimeout',900]);
         _paq.push(['enableLinkTracking',true]);
         _paq.push(['trackPageView']);
         try{
         var d=document,g=d.createElement('script'),s=d.getElementsByTagName('script')[0];
         g.type='text/javascript';
         g.defer=true;
         g.async=true;
         g.src=pkBaseURL+'piwik.js';
         s.parentNode.insertBefore(g,s);
         }
         catch(err){}

*/

      var Piwik = function Piwik(_config) {
        this.piwikEl = null;
        this._config = _config;

        //   this.cookie = "__piwik_tracking_cfapp_px";

      };

      var piwik = new Piwik (_config);



      Piwik.prototype.activate = function() {
        // check to see if our configuration is correct, then run the setup.
        //  if (typeof this.config.site_id == "string" && this.config.side_id !== "") {
        if (typeof this.config.piwik_receiver !== "string" || this.config.piwik_receiver === "") {
          CloudFlare.require(["cloudflare/console"],function(c){
            c.error("PIWIKANALYTICS: Invalid receiver.");
          });
        } else if (typeof this.config.site_id !== "string" || this.config.site_id === "" ) {
          CloudFlare.require(["cloudflare/console"],function(c){
            c.error("PIWIKANALYTICS: Invalid site_id ");
          });

        } else {

          // run setup() 
          this.setup();

        }
      };

      function noScript(){
        var test_site = this._config.piwik_receiver || "//pikwik-ssl.ns1.net/piwik.php";
        test_site += "?id="+this._config.site_id+"&amp;rec=1";
        var script = dom.createElement("noscript");
        var cursor = dom.getElementsByTagName('script', true)[0];
        cursor.parentNode.insertBefore(script, cursor);
      }

      function piwikScript(){
        var piwik_js = this._config.piwik_js || "//cdnjs.cloudflare.com/ajax/libs/piwik/1.10.1/piwik.js";
        var script = dom.createElement("script");
        // var cursor = document.getElementsByTagName('script', true)[0];
        var cursor = dom.getElementsByTagName('script', true)[0];
        // for html5 does not need type declaration
        dom.setAttribute(script, "type", "text/javascript");
        dom.setAttribute(script, "src", piwik_js);
        cursor.parentNode.insertBefore(script, cursor);
      }

      function piwikPush(){
        var script = dom.createElement("script");
        var cursor = dom.getElementsByTagName('script', true)[0];
        dom.setAttribute(script, "type", "text/javascript");
        script.innerHTML = this._config.paq_push || paq_push_default;
        cursor.parentNode.insertBefore(script, cursor);

      }

      /*
       * setup()
       * Load our program into dom
       * */
      Piwik.prototype.setup = function() {
        piwikPush();
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

