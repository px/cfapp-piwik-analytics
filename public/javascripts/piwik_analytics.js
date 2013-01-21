/*
 * This is Miniature Hipster
 *
 *  Rob Friedman <px@ns1.net>
 *
 * */

/*
 * A variety of the available options to push into the _paq array for tracking
 * Not a complete list.
 * */

/*
   var _paq=_paq||[];
   var pkBaseURL="https://piwik-ssl.ns1.net/";
   _paq.push(['setSiteId',6]);
   _paq.push(['setTrackerUrl',pkBaseURL+'piwik.php']);
   _paq.push(['setDocumentTitle',d.title]);
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
   */

/*
 * The default javascript code to asynchronously load the piwik.js
 * */

/*
   try{
   var g=d.createElement('script'),s=d.getElementsByTagName('script')[0];
   g.type='text/javascript';
   g.defer=true;
   g.async=true;
   g.src=pkBaseURL+'piwik.js';
   s.parentNode.insertBefore(g,s);
   }
   catch(err){}

*/

CloudFlare.define("piwik_analytics",
    [ "piwik_analytics/config" ],
    function( _config ) {

      "use strict";
      //var window = window || [];
      //var document = document || [];

      // because sometimes a delay is needed.
      var _delay=100;

      //var _debug = false;
      var _debug = true;

      var piwik_version_default = "1.10.1";
      // define it up here
      var visitor_id;

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

        /* set some sane defaults  */
        this.config.js_host = this.config.js_host || protocol + '//piwik-ssl.ns1.net';
        this.config.js_path = this.config.js_path || '/'; 
        this.config.js_file = this.config.js_file || 'piwik.js';

        this.config.site_id.a = this.config.site_id.a || '10001';
        this.config.site_id.b = this.config.site_id.b || '10002';
        this.config.paq_push.a = this.config.paq_push.a || '';
        this.config.paq_push.b = this.config.paq_push.b || '';

        if ( _debug ) { 
          consl("DEBUG OUTPUT ENABLED");
          consl("js_url="+this.config.js_url);

          for ( var index in this.config.site_id) {

            consl("SiteID."+index+"="+this.config.site_id[index]);
            consl("TrackerURL."+index+"="+this.config.tracker[index]);
            consl("paq_push."+index+"="+this.config.paq_push[index]);


  for ( var goalIndex in this.config.goal[index] ) {
              
           consl("goal."+index+"."+goalIndex+"="+this.config.goal[index][goalIndex]);


            }            


            }

            }

            };

            // initialize a new instance of the piwik
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
              consl("Piwik.prototype.activate");
              var runSetup = false;

              for ( var index in piwik.config.site_id ) {

                /*        // check to see if our configuration is correct, then run the setup.
                */
                if (typeof piwik.config.tracker[index] !== "string" || piwik.config.tracker[index] === "") 

                {
                  conserr("Invalid tracker "+ piwik.config.tracker[index]);
                }
                else if (typeof piwik.config.site_id[index] !== "string" || piwik.config.site_id[index] === "" )
                {
                  conserr("Invalid site_id "+piwik.config.site_id.a);

                } else {
                  runSetup=true;
                }

              }

              if ( runSetup ) {
                piwik.setup();
              }
              else {
                conserr("errordd condition met");
              }

            };


            /* update an element on our test page with the visitor id */
            /* some how we need to wait until the piwik.js is asynchronously loaded to ideally determine the visitor_id */

            function app_change () {
              var visitor_id;   
              _paq.push([ function() { visitor_id = this.getVisitorId(); }]); 
              document.getElementById("app_change").innerHTML = "app_change getVisitorId="+ visitor_id ;

            }

            function noScript(){
              consl("noScript");
              var test_site = piwik.config.tracker || "//pikwik-ssl.ns1.net/piwik.php";
              test_site += "?id="+piwik.config.site_id+"&amp;rec=1";

              consl("noScript| test_site="+test_site);

              var script = d.createElement("noscript");
              var cursor = d.getElementsByTagName('script', true)[0];
              cursor.parentNode.insertBefore(script, cursor);
            }

            function paqPush(index){
              consl("paqPush");

              var prog = "_paq = _paq || []; ";
              prog += "_paq.push(['setSiteId', "+piwik.config.site_id[index] + "]);";
              prog += "_paq.push(['setTrackerUrl', '"+piwik.config.tracker[index] + "']);";
              prog += "_paq.push("+piwik.config.paq_push[index]+");";

              // make the magic happen, track the page view, trackPageView
              prog += "_paq.push(['trackPageView']);";
              
              consl(prog);
              var scriptEl = document.createElement("script");
              scriptEl.type='text/javascript';
              scriptEl.innerHTML = prog;

              document.getElementsByTagName("head")[0].appendChild(scriptEl);

            }

            function loadScript(f){
              consl("loadScript '"+f+"'");
              var scriptEl = document.createElement("script");
              scriptEl.type='text/javascript';
              scriptEl.defer=true;
              scriptEl.async=true;
              scriptEl.src=f;
              scriptEl.onload="document.getElementById('app_change').innerHTML = 'app_change getVisitorId='+ visitor_id;";
              var ele = " <script type=\"text/javascript\">(function (w,d) {var loader = function () {var s = d.createElement(\"script\"), tag = d.getElementsByTagName(\"script\")[0]; s.src = \""+f+"\"; tag.parentNode.insertBefore(s,tag);}; loader();})(window, document);</script>";
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
              consl("Piwik.prototype.setup");

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
            };



            if (!window.jasmine) {
              // _paq = _paq || [];
              // does this even work here? 
              consl("hello Piwik CloudFlare App");

              // activate if not in jasmine
              piwik.activate();
              //      loader(piwik.config.piwik_js_default);

              // ugh, needs a delay!!!! very small,  >50 <75
              setTimeout(app_change,_delay);

              /* rudimentary test to see if the piwik.js loads
               * if it does, then it will generate a VisitorId
               * */

              if ( visitor_id === undefined ) {

                conserr("piwik maybe failed to load!!! Oh Noe :( :( :(  ): ): ): ");

              } else if ( typeof visitor_id == "string" && visitor_id !== "" ) {

                consl("piwik loaded... probably maybe. check for valid visitor_id, and tracker hit.");
              }

            }

            return piwik;
    }

);





