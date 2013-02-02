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
    

    try
      @config = _config
    catch e
      console.error "the _config is broken"

    # because sometimes a minor delay is needed, in seconds. FIXME because I'm sure we can do without. 
    _delay = 0.11
    
    # var _debug = false;
    _debug = true
    _default_piwik_version = "1.10.1"

    consl = (m) ->
      console.log "_px_> " + m

    conserr= (m) ->
      console.error "*px**> " + m

    consl "Hello from the Piwik CloudFlare App!"  if _debug
    # clear localStorage is we're debuging 
    consl "window.localStorage.clear()=" + window.localStorage.clear() if _debug

    # use CloudFlare.require to load the javascript requested
    loadScript = (f) ->
      consl "loadScript via CloudFlare.require [" + f + "]"  if _debug
      # maybe needs a delay
      CloudFlare.require [f], ->
        app_change()
        is_piwik()
        yes

    # javascript append an element to head    
    loadScript2 = (f) ->
      # output to console if _debug
      consl "loadScript2 '" + f + "'"  if _debug
      # create a script element to place our script into
      scriptEl = document.createElement("script")
      # set the type and other features for the element
      scriptEl.type = "text/javascript"
      scriptEl.defer = true
      scriptEl.async = true
      scriptEl.src = f
      scriptEl.onload = ""
      # append the element to the bottom of the head element
      document.getElementsByTagName("head")[0].appendChild scriptEl
      # push a command on to the global window._paq array, and
      # set the global window._pk_visitor_id variable
      window._paq.push [
        ->
         window._pk_visitor_id = @getVisitorId()

        ->
         window._pk_visitor_info = @getVisitorInfo()

        ->
         window._pk_visitor_attr_info = @getAttributionInfo()
      ]
      window._pk_visitor_id
   
    # some how we need to wait until the piwik.js is asynchronously loaded to ideally determine the _pk_visitor_id 
    app_change = ->
      consl "app_change()" if _debug
      setTimeout( ->
         ( document.getElementById("app_change").innerHTML = "app_change -- getVisitorId=" + window._pk_visitor_id)
        1000*_delay)
        is_piwik

    # rudimentary test to see if the piwik.js loads
    #       * if it does, then it will generate a VisitorId
    #       * 
    is_piwik = ->
      consl "is_piwik() loaded?"
      # push a command on to the global window._paq array, and
      # set the global window._pk_visitor_id variable
      window._paq.push [->
        window._pk_visitor_id = @getVisitorId()
      ]
      try
       if window._pk_visitor_id is undefined or window._pk_visitor_id is ""
          conserr " no window._pk_visitor_id piwik maybe failed to load!!! Oh Noe :( :( :(  ): ): ): "
        else consl "piwik loaded... probably maybe. window._pk_visitor_id='"+window._pk_visitor_id+"', and tracker hit."  if typeof window._pk_visitor_id is "string" and window._pk_visitor_id isnt ""
      catch e
        conserr "is_piwik() " + e

    # fix_scheme(url) fix the file:// url to use https:// url
    #  useful for tracker url fixing schemeless url
    fix_scheme = (url) ->
      consl "fix_scheme(" + url + ")" if _debug

      #consl "window.location.protocol" + window.location.protocol if _debug

      if /^(http).*/.test(url)
        # return the url as it stands
        return url
      else
        # url does not have http rewrite it to be what we want.
        return "https:"+url



    # define it up here
    Piwik = {}
    Piwik = (config) ->
      # apply the config
      @config = config

      # fixup the tracker url for missing scheme on file:// url locations
      #
      if @config.use_cdnjs
        # loadScript the @config.default_piwik_js for now
        loadScript fix_scheme @config.default_piwik_js
      else if @config.js_url
        loadScript fix_scheme @config.js_url

    #
    #   * paqPush(index)
    #   * function to push information into the window._paq global array
    #   *
    #   * 
      paqPush = () ->
        consl "paqPush()"  if _debug
        # start building the window._paq array for configuration and commands
        prog = "window._paq = window._paq || []; "
        # set the site_id
        prog += "window._paq.push(['setSiteId', " + config.site_id + "]);"
        # set the tracker url
        prog += "window._paq.push(['setTrackerUrl', '" + fix_scheme( config.tracker )+ "']);"
        # select if link_tracking is enabled
        if config.link_tracking is "true"
          prog += "window._paq.push(['enableLinkTracking',true]);"
        else
          prog += "window._paq.push(['enableLinkTracking',false]);"

        # select if do_not_tack is enabled
        if config.set_do_not_track is "true"
          prog += "window._paq.push(['setDoNotTrack',true]);"
        else
          prog += "window._paq.push(['setDoNotTrack',false]);"
      
      # pass the options 
        prog += "window._paq.push(" + config.paq_push + ");"
        
      # make the magic happen, track the page view, trackPageView
        prog += "window._paq.push(['trackPageView']);"
   
        consl "prog=("+prog+")"  if _debug

        scriptEl = document.createElement("script")
        scriptEl.type = "text/javascript"
        scriptEl.innerHTML = prog
        document.getElementsByTagName("head")[0].appendChild scriptEl
        consl "paqPush() finished ok!" if _debug 

      noScript = ->
        consl "noScript"  if _debug
        test_site = piwik.config.tracker or "https://pikwik-ssl.ns1.net/piwik.php"
        test_site += "?id=" + piwik.config.site_id + "&amp;rec=1"
        consl "noScript| test_site=" + test_site  if _debug
        script = document.createElement("noscript")
        cursor = document.getElementsByTagName("script", true)[0]
        cursor.parentNode.insertBefore script, cursor
      
        #activate()
        #setup()
      paqPush()


  # instantiate and configure a new instance of the piwik
    piwik = new Piwik(_config)
    
  #app_change()
    yes


loaded.then(
      ->
        (modules) {
         modules

        }
      ->
        (error) {
          console
              #          // Handle errors here..
        }
     )

