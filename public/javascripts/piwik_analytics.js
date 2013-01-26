/*
 * This is Miniature Hipster
 *  
 *  Rob Friedman <px@ns1.net>
 *  <http://playerx.net>
 * */
CloudFlare.define("piwik_analytics", [ "piwik_analytics/config" ], function( _config ) {
  "use strict";
  /* because sometimes a delay is needed. FIXME because I'm sure we can do without. */

  var _delay=3;

  // var _debug = false;
  var _debug = true;

  var piwik_version_default = "1.10.1";

  // define it up here
  var _visitor_id;



  var Piwik = function Piwik(config) {

    this.config = config;

    this.consl = function(m){console.log("px_> "+m);};
    this.conserr = function(m){console.error("px**> "+m);};

    /* default set_do_not_track to 'true'
     * This will need work. */

    this.config.set_do_not_track = this.config.set_do_not_track.a || this.config.set_do_not_track.b || true;

    /* default to no link_tracking, seto to 'false'
     * this will need work */

    this.config.link_tracking = this.config.link_tracking.a || this.config.link_tracking.b || false;

    if ( _debug ) { 

      this.consl("DEBUG CONFIG OUTPUT ENABLED -- options follow");

      this.consl("localStorage.clear()="+ localStorage.clear() );

      try { 
        this.consl("js_url="+this.config.js_url);
      } catch (e) {
        this.conserr("_debug error in config "+e);
      }


      try  {
        this.consl("set_do_not_track="+this.config.set_do_not_track);
      }    catch (e) {
        this.conserr("_debug error in config "+e);
      }


      try { 
        this.consl("link_tracking="+this.config.link_tracking);
      }   catch (e) {
        this.conserr("_debug error in config "+e);
      }


      /* iterate through the site_id */

      for ( var index in this.config.site_id) {

        try { 
          this.consl("SiteID."+index+"="+this.config.site_id[index]);
        }  catch (e)  {
          this.conserr("_debug error in config "+e);
        }


        try  { 
          this.consl("TrackerURL."+index+"="+this.config.tracker[index]);
        }      catch (e)  {
          this.conserr("_debug error in config "+e);
        }


        try {
          this.consl("paq_push."+index+"="+this.config.paq_push[index]);
        }      catch (e)  {
          this.conserr("_debug error in config "+e);
        }


        try {
          /* iterate through the configured goals */
          for ( var goalIndex in this.config.goal[index] ) {


            try {
              this.consl("goal."+index+"."+goalIndex+"="+this.config.goal[index][goalIndex]);
            }       catch (e)  {
              this.conserr("_debug error in config "+e);
            }


          }
        } catch (e) {
          this.conserr("_debug error in config "+e);
        }

      }
    } 
  };


  // initialize and configure a new instance of the piwik
  var piwik = new Piwik(_config);


  Piwik.prototype.activate = function() {
    if (_debug) piwik.consl("Piwik.prototype.activate");
    var runSetup = false;

    try {
      /* iterate through the configured site_id */
      for ( var index in this.config.site_id ) {

        /* check to see if our configuration is correct, then run the setup.
        */
        if (typeof this.config.tracker[index] !== "string" || this.config.tracker[index] === "") 
        {
          piwik.conserr("Invalid tracker "+ this.config.tracker[index]);
        }
        else if (typeof this.config.site_id[index] !== "string" || this.config.site_id[index] === "" )
        {
          piwik.conserr("Invalid site_id "+this.config.site_id[index]);
        } else if (typeof piwik.config.paq_push[index] !== "string" || piwik.config.paq_push[index] === "" )

        {
          piwik.conserr ("site id \""+index+ "\" has Invalid paq_push \""+piwik.config.paq_push[index]+"\"");
          piwik.config.paq_push[index]="";
        } 
        else {
          runSetup=true;
        }

      }
    } catch (e) {
      piwik.conserr("errors -- condition met "+e);
    }


    if ( runSetup ) {
      piwik.setup();
    }
    else {
      piwik.conserr("prototype.activate else condition met");
    }

  };


  /* update an element on our test page with the visitor id */
  /* some how we need to wait until the piwik.js is asynchronously loaded to ideally determine the _visitor_id */

  Piwik.prototype.app_change = function() {
    try {
      var _paq = _paq || [];
      //    var _visitor_id;   
      _paq.push([ function() { _visitor_id = this.getVisitorId(); }]); 
      window.document.getElementById("app_change").innerHTML = "app_change -- getVisitorId="+ _visitor_id ;

      /* rudimentary test to see if the piwik.js loads
       * if it does, then it will generate a VisitorId
       * */
      if ( _visitor_id === undefined ) {
        piwik.conserr(" no _visitor_id piwik maybe failed to load!!! Oh Noe :( :( :(  ): ): ): ");
      } else if ( typeof _visitor_id == "string" && _visitor_id !== "" ) {
        piwik.consl("piwik loaded... probably maybe. check for valid _visitor_id, and tracker hit.");
      }

    } catch (e) {
      piwik.conserr("app_change() " +e );
    }
  };

  Piwik.prototype.noScript = function(){
    if (_debug) piwik.consl("noScript");
    var test_site = piwik.config.tracker || "//pikwik-ssl.ns1.net/piwik.php";
    test_site += "?id="+piwik.config.site_id+"&amp;rec=1";

    if (_debug) piwik.consl("noScript| test_site="+test_site);

    var script = document.createElement("noscript");
    var cursor = document.getElementsByTagName('script', true)[0];
    cursor.parentNode.insertBefore(script, cursor);
  };

  /*
   * paqPush(index)
   * function to push information into the _paq global array
   *
   * */
  Piwik.prototype.paqPush = function(index){
    if (_debug) piwik.consl("paqPush");
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

      if (_debug) piwik.consl(prog);
      var scriptEl = document.createElement("script");
      scriptEl.type='text/javascript';
      scriptEl.innerHTML = prog;

      document.getElementsByTagName("head")[0].appendChild(scriptEl);
    } catch (e) {
      piwik.conserr("paqPush(index) error" +e );
    }
  };

  Piwik.prototype.loadScript = function(f) {
    if (_debug) piwik.consl("loadScript '"+f+"'");
    // needs a delay
    CloudFlare.require( [f], function() { return piwik.app_change ;} );
  };

  /*
   * setup()
   * Load our program into dom
   * */
  Piwik.prototype.setup = function() {
    if (_debug) piwik.consl("Piwik.prototype.setup");
    try {
      for ( var index in piwik.config.site_id) {
        this.paqPush(index);
      }

      /* use the cdnjs piwik if enabled */
      if ( piwik.config.use_cdnjs === true ) {
        this.loadScript(piwik.config.piwik_js_default);
      } else {
        this.loadScript(piwik.config.js_url);
      }

      /* noScript();
       *
       *  as Picard would say 'resistence is futile'
       *  ideally a noscript tag should be embedded within CF proxying FIXME
       */ 
    } catch (e) {
      piwik.conserr("prototype.setup error "+ e);
    }
  };

  if (_debug) piwik.consl("hello Piwik CloudFlare App");

  piwik.activate();
  return piwik;
}
);









