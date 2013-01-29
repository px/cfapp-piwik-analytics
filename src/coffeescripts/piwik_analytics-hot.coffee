###
* This is Miniature Hipster
*  @name      Miniature Hipster
*  @author    Rob Friedman <px@ns1.net>
*  @url       <http://playerx.net>
*  @license   https://github.com/px/cfapp-piwik-analytics/raw/master/LICENSE.txt
*
###

# stick with commas
loaded = CloudFlare.define "piwik_analytics", ["piwik_analytics/config"], (_config) ->
  "use strict"
  
  # because sometimes a minor delay is needed, in seconds. FIXME because I'm sure we can do without. 
  _delay = 0.11
  
  # var _debug = false;
  _debug = true
  piwik_version_default = "1.10.1"

  consl = (m) ->
    console.log "px_> " + m

  conserr= (m) ->
    console.error "px**> " + m

  loadScript = (f) ->
    consl "loadScript '" + f + "'"  if _debug
    # maybe needs a delay
    CloudFlare.require [f], ->
      app_change()

  #loadScript(_config.piwik_js_default)

      #  script_url = _config.piwik_js_default;;

      #  CloudFlare.require([script_url], -> {
    #  // code here will execute after the script has been loaded
    #  })

  loadScript2 = (f) ->
   consl "loadScript2 '" + f + "'"  if _debug
   scriptEl = document.createElement("script")
   scriptEl.type = "text/javascript"
   scriptEl.defer = true
   scriptEl.async = true
   scriptEl.src = f
   scriptEl.onload = ""
   document.getElementsByTagName("head")[0].appendChild scriptEl
   window._paq.push [->
     window._visitor_id = @getVisitorId()
   ]
  
   # app_change()
   ##  loadScript2(_config.piwik_js_default)

  # update an element on our test page with the visitor id 
  
  # some how we need to wait until the piwik.js is asynchronously loaded to ideally determine the _visitor_id 
  app_change = ->
    consl "app_change()"
    setTimeout( ->
       ( document.getElementById("app_change").innerHTML = "app_change -- getVisitorId=" + window._visitor_id)
      1000*_delay)
    try
      ##window._paq = window._paq or []
      ##window._visitor_id = window._visitor_id or ""
      
      #      _paq.push([ function() { window.document.getElementById("app_change").innerHTML = "app_change -- getVisitorId="+this.getVisitorId(); } ]);
   
      
      # rudimentary test to see if the piwik.js loads
      #       * if it does, then it will generate a VisitorId
      #       * 
      if window._visitor_id is undefined or window._visitor_id is ""
        conserr " no window._visitor_id piwik maybe failed to load!!! Oh Noe :( :( :(  ): ): ): "
      else consl "piwik loaded... probably maybe. check for valid window._visitor_id='"+window._visitor_id+"', and tracker hit."  if typeof window._visitor_id is "string" and window._visitor_id isnt ""
    catch e
      conserr "app_change() " + e



  consl "hello Piwik CloudFlare App"  if _debug
  
  # define it up here
  ##window._visitor_id = window._visitor_id or "xxxxxxxxxxxx"
  Piwik = {}
  Piwik = (config) ->
    @config = config
    
    # default set_do_not_track to 'true'
    #     * This will need work. 
    @config.set_do_not_track = @config.set_do_not_track.a or @config.set_do_not_track.b or true
    
    # default to no link_tracking, seto to 'false'
    #     * this will need work 
    @config.link_tracking = @config.link_tracking.a or @config.link_tracking.b or false

    if _debug
       
      consl "DEBUG CONFIG OUTPUT ENABLED -- options follow"
      consl "localStorage.clear()=" + localStorage.clear()
      try
        consl "js_url=" + @config.js_url
      catch e
        conserr "_debug error in config " + e
      try
        consl "set_do_not_track=" + @config.set_do_not_track
      catch e
        conserr "_debug error in config " + e
      try
        consl "link_tracking=" + @config.link_tracking
      catch e
        conserr "_debug error in config " + e
      
      # iterate through the site_id 
      for index of @config.site_id
        try
          consl "SiteID." + index + "=" + @config.site_id[index]
        catch e
          conserr "_debug error in config " + e
        try
          consl "TrackerURL." + index + "=" + @config.tracker[index]
        catch e
          conserr "_debug error in config " + e
        try
          consl "paq_push." + index + "=" + @config.paq_push[index]
        catch e
          conserr "_debug error in config " + e
  
  # disable goals
  #
  #           try {
  #        //    iterate through the configured goals
  #        for ( var goalIndex in this.config.goal[index] ) {
  #
  #
  #        try {
  #        this.consl("goal."+index+"."+goalIndex+"="+this.config.goal[index][goalIndex]);
  #        }       catch (e)  {
  #        this.conserr("_debug error in config "+e);
  #        }
  #
  #
  #        }
  #        } catch (e) {
  #        this.conserr("_debug error in config "+e);
  #        }
  #        
  
  #
  #   * setup()
  #   * Load our program into dom
  #   * 
  setup = ->
    consl "Piwik.prototype.setup"  if _debug
    try
      for index of _config.site_id
        paqPush index
      
      # use the cdnjs piwik if enabled 
      if _config.use_cdnjs is true
        loadScript2 _config.piwik_js_default
      else
        loadScript2 _config.js_url
    
    # noScript();
    #       *
    #       *  as Picard would say 'resistence is futile'
    #       *  ideally a noscript tag should be embedded within CF proxying FIXME
    #       
    catch e
      conserr "prototype.setup error " + e


  
   activate = ->
    consl "Piwik.prototype.activate"  if _debug
    runSetup = false
    try
      
      # iterate through the configured site_id 
      for index of _config.site_id
        
        # check to see if our configuration is correct, then run the setup.
        #        
        if typeof _config.tracker[index] isnt "string" or _config.tracker[index] is ""
          conserr "Invalid tracker " + _config.tracker[index]
        else if typeof _config.site_id[index] isnt "string" or _config.site_id[index] is ""
          conserr "Invalid site_id " + _config.site_id[index]
        else if typeof _config.paq_push[index] isnt "string" or _config.paq_push[index] is ""
          conserr "site id \"" + index + "\" has Invalid paq_push \"" + _config.paq_push[index] + "\""
          config.paq_push[index] = ""
        else
          runSetup = true
    catch e
      conserr "errors -- condition met " + e
    if runSetup
      setup()
    else
      conserr "prototype.activate else condition met"



  Piwik::noScript = ->
    consl "noScript"  if _debug
    test_site = piwik.config.tracker or "//pikwik-ssl.ns1.net/piwik.php"
    test_site += "?id=" + piwik.config.site_id + "&amp;rec=1"
    consl "noScript| test_site=" + test_site  if _debug
    script = document.createElement("noscript")
    cursor = document.getElementsByTagName("script", true)[0]
    cursor.parentNode.insertBefore script, cursor

  
  #
  #   * paqPush(index)
  #   * function to push information into the _paq global array
  #   *
  #   * 
  paqPush = (index) ->
    consl "paqPush"  if _debug
    try
      prog = "window._paq = window._paq || []; "
      prog += "window._paq.push(['setSiteId', " + _config.site_id[index] + "]);"
      prog += "window._paq.push(['setTrackerUrl', '" + _config.tracker[index] + "']);"
      if _config.link_tracking[index] is "true"
        prog += "window._paq.push(['enableLinkTracking',true]);"
      else
        prog += "window._paq.push(['enableLinkTracking',false]);"
      if _config.set_do_not_track[index] is "true"
        prog += "window._paq.push(['setDoNotTrack',true]);"
      else
        prog += "window._paq.push(['setDoNotTrack',false]);"
      
      # pass the options 
      prog += "window._paq.push(" + _config.paq_push[index] + ");"
      
      # make the magic happen, track the page view, trackPageView
      prog += "window._paq.push(['trackPageView']);"
      consl prog  if _debug
      scriptEl = document.createElement("script")
      scriptEl.type = "text/javascript"
      scriptEl.innerHTML = prog
      document.getElementsByTagName("head")[0].appendChild scriptEl
    catch e
      conserr "paqPush(index) error" + e
 
      
      # instantiate and configure a new instance of the piwik
  piwik = new Piwik(_config)
  activate()
  consl "stuff"
  
  
  app_change()
  yes


loaded.then( ->
      (modules)
     ->
      (error) {

        #          // Handle errors here..
              }
     )

