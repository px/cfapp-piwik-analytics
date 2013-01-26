/*
 * This is Miniature Hipster
 *  
 *  Rob Friedman <px@ns1.net>
 *  <http://playerx.net>
 * */
CloudFlare.define("piwik_analytics",
    [ "piwik_analytics/config" ],
    function( _config ) {

      "use strict";
      //var window = window || [];
      //var document = document || [];

      // because sometimes a delay is needed. FIXME because I'm sure we can do without.
      var _delay=2;

      // var _debug = false;
           var _debug = true;

      var piwik_version_default = "1.10.1";
      // define it up here
      var _visitor_id;

      /* be sure to keep the same order here in the modules
       * as you have here in the parameters
       *
       * re-enable strict someday!
       */

      var d=document;
      var protocol = window.location.protocol != "https:" ? "http:" : "https:";

      var Piwik = function Piwik(config) {
        this.config = config;
        /* use configuration version, or use the current default version of piwik */
        this.config.piwik_version = this.config.piwik_version || piwik_version_default;

        /* set some 'sane' defaults  */
        //       this.config.js_host = this.config.js_host || protocol + '//piwik-ssl.ns1.net';
        //       this.config.js_path = this.config.js_path || '/'; 
        //       this.config.js_file = this.config.js_file || 'piwik.js';

        //       this.config.site_id.a = this.config.site_id.a || '10001';
        //        this.config.site_id.b = this.config.site_id.b || '10002';
        //        this.config.paq_push.a = this.config.paq_push.a || '';
        //        this.config.paq_push.b = this.config.paq_push.b || '';

        /* default set_do_not_track to 'true'
         * This will need work. */

        //        this.config.set_do_not_track = this.config.set_do_not_track.a || this.config.set_do_not_track.b || true;

        /* default to no link_tracking, seto to 'false'
         * this will need work */

        //        this.config.link_tracking = this.config.link_tracking.a || this.config.link_tracking.b || false;

        if ( _debug ) { 
          try {
            consl("DEBUG OUTPUT ENABLED -- options follow");
            consl("js_url="+this.config.js_url);

            consl("set_do_not_track="+this.config.set_do_not_track);
            consl("link_tracking="+this.config.link_tracking);

            /* iterate through the site_id */

            for ( var index in this.config.site_id) {

              consl("SiteID."+index+"="+this.config.site_id[index]);
              consl("TrackerURL."+index+"="+this.config.tracker[index]);

              consl("paq_push."+index+"="+this.config.paq_push[index]);

              /* iterate through the configured goals */
              for ( var goalIndex in this.config.goal[index] ) {

                consl("goal."+index+"."+goalIndex+"="+this.config.goal[index][goalIndex]);

              } 

            }
          } catch (e) {
            conserr("_debug error in config "+e);

          }
        }
      };


      // initialize and configure a new instance of the piwik
      var piwik = new Piwik (_config);



      // console logging made easy
      function consl(o){
        CloudFlare.require(["cloudflare/console"],function(c){
          c.log("px: "+o);
        });
      }
      if (_debug) consl("testing out the log");

      // console error logging made easy
      function conserr(o){
        CloudFlare.require(["cloudflare/console"],function(c){
          c.error("px: "+o);
        });
      }
      if (_debug) conserr("testing out the error") ;






      Piwik.prototype.activate = function() {
        if (_debug) consl("Piwik.prototype.activate");
        var runSetup = false;

        try {
          /* iterate through the configured site_id */
          for ( var index in piwik.config.site_id ) {

            /* check to see if our configuration is correct, then run the setup.
            */
            if (typeof piwik.config.tracker[index] !== "string" || piwik.config.tracker[index] === "") 
            {
              conserr("Invalid tracker "+ piwik.config.tracker[index]);
            }
            else if (typeof piwik.config.site_id[index] !== "string" || piwik.config.site_id[index] === "" )
            {
              conserr("Invalid site_id "+piwik.config.site_id[index]);
            } else if (typeof piwik.config.paq_push[index] !== "string" || piwik.config.paq_push[index] === "" )

            {
              conserr ("site id \""+index+ "\" has Invalid paq_push \""+piwik.config.paq_push[index]+"\"");
              piwik.config.paq_push[index]="";
            } 
            else {
              runSetup=true;
            }

          }
        } catch (e) {
          conserr("errors -- condition met "+e);

        }


        if ( runSetup ) {
          piwik.setup();
        }
        else {
          conserr("prototype.activate else condition met");
        }

      };


      /* update an element on our test page with the visitor id */
      /* some how we need to wait until the piwik.js is asynchronously loaded to ideally determine the _visitor_id */

      function app_change () {
        try {
          //    var _paq = _paq || [];
          //    var _visitor_id;   
          _paq.push([ function() { _visitor_id = this.getVisitorId(); }]); 
          window.document.getElementById("app_change").innerHTML = "app_change -- getVisitorId="+ _visitor_id ;


      /* rudimentary test to see if the piwik.js loads
       * if it does, then it will generate a VisitorId
       * */


          if ( _visitor_id === undefined ) {

            conserr(" no _visitor_id piwik maybe failed to load!!! Oh Noe :( :( :(  ): ): ): ");

          } else if ( typeof _visitor_id == "string" && _visitor_id !== "" ) {

            consl("piwik loaded... probably maybe. check for valid _visitor_id, and tracker hit.");
          }


        } catch (e) {
          conserr("app_change() " +e );
        }
      }

      function noScript(){
        if (_debug) consl("noScript");
        var test_site = piwik.config.tracker || "//pikwik-ssl.ns1.net/piwik.php";
        test_site += "?id="+piwik.config.site_id+"&amp;rec=1";

        if (_debug) consl("noScript| test_site="+test_site);

        var script = d.createElement("noscript");
        var cursor = d.getElementsByTagName('script', true)[0];
        cursor.parentNode.insertBefore(script, cursor);
      }
      /*
       * paqPush(index)
       * function to push information into the _paq global array
       *
       * */
      function paqPush(index){
        if (_debug) consl("paqPush");
        try {
          var prog = "_paq = _paq || []; ";
          prog += "_paq.push(['setSiteId', "+piwik.config.site_id[index] + "]);";
          prog += "_paq.push(['setTrackerUrl', '"+piwik.config.tracker[index] + "']);";

          if (piwik.config.link_tracking[index] === "true") {
            prog += "_paq.push(['enableLinkTracking',true]);";
          } else {
            prog += "_paq.push(['enableLinkTracking',false]);";
          }

          if (piwik.config.set_do_not_track[index] === "true" ) {
            prog += "_paq.push(['setDoNotTrack',true]);";
          } else {
            prog += "_paq.push(['setDoNotTrack',false]);";
          }

          /* pass the options */
          prog += "_paq.push("+piwik.config.paq_push[index]+");";

          // make the magic happen, track the page view, trackPageView
          prog += "_paq.push(['trackPageView']);";

          if (_debug) consl(prog);
          var scriptEl = document.createElement("script");
          scriptEl.type='text/javascript';
          scriptEl.innerHTML = prog;

          document.getElementsByTagName("head")[0].appendChild(scriptEl);
        } catch (e) {
          conserr("paqPush(index) error" +e );
        }
      }

      function loadScript(f){
        if (_debug) consl("loadScript '"+f+"'");
        var scriptEl = document.createElement("script");
        scriptEl.type='text/javascript';
        scriptEl.defer=true;
        scriptEl.async=true;
        scriptEl.src=f;
        scriptEl.onload="document.getElementById('app_change').innerHTML = 'app_change getVisitorId22222='+ _visitor_id;";
        document.getElementsByTagName("head")[0].appendChild(scriptEl);
      }

      function loader(f){

        var scriptEl = document.createElement("script");
        scriptEl.type='text/javascript';
        scriptEl.defer=true;
        scriptEl.async=true;

        scriptEl.innerHTML = "(function (w,d) {var loader = function () {var s = d.createElement(\"script\"), tag = d.getElementsByTagName(\"script\")[0]; s.src = \""+f+"\"; tag.parentNode.insertBefore(s,tag);}; loader();})(window, document);";
        document.getElementsByTagName("head")[0].appendChild(scriptEl);

      }


      /*
       * setup()
       * Load our program into dom
       * */
      Piwik.prototype.setup = function() {
        if (_debug) consl("Piwik.prototype.setup");
        try {
          for ( var index in piwik.config.site_id) {

            paqPush(index);

          }

          /* use the cdnjs piwik if enabled */
          if ( piwik.config.use_cdnjs === true ) {
            loader(piwik.config.piwik_js_default);

            //:
            //loadScript(piwik.config.piwik_js_default);
          } else {
            /* use our own js url */
            loader(piwik.config.js_url);
            //      
            //         loadScript(piwik.config.js_url);
          }

          /* noScript();
           *
           *  as Picard would say 'resistence is futile'
           *  ideally a noscript tag should be embedded within CF proxying FIXME
           */ 
        } catch (e) {

          conserr("prototype.setup error "+ e);
        }
      };



      // _paq = _paq || [];
      // does this even work here? 
      if (_debug) consl("hello Piwik CloudFlare App");

      // activate if not in jasmine
      piwik.activate();
      //      loader(piwik.config.piwik_js_default);

      // ugh, needs a delay!!!! very small,  >50 <75
      //
      //
      // var timerSec=0.5;
      //
      // var myVar = setInterval( function() { myTimer(); } , timerSec*1000 );
      //
      //
      // function myTimer()
      // {
      //   update_status(document, piwikConfig);
      //   }
      //

       setTimeout(app_change,_delay*1000);
      var timerSec=1;
      var myVar = setInterval( function() { myTimer(); } , timerSec*1000 );
      function myTimer()
      {
   //     app_change();
      }
      /* rudimentary test to see if the piwik.js loads
       * if it does, then it will generate a VisitorId
       * */

      //      _paq.push([ function() { _visitor_id = this.getVisitorId(); }]); 
      //      window.document.getElementById("app_change").innerHTML = "app_change i111 getVisitorId="+ _visitor_id ;

      return piwik;
    }

);





