_mh_version = "0.0.7"

CloudFlare.define("piwik_analytics",

  [ "piwik_analytics/config" ],

(_config) ->
  "use strict"

  exports ? this

  window._paq = window._paq || []

  Piwik = Piwik || {}

  _debug = true

  window._visitor_id = window._visitor_id || ''

  Piwik = (config) ->
    this.config = config

    this.config.set_do_not_track = config_set_do_not_track.a || config.set_no_not_track.b || true
    
    this.config.link_tracking = config.link_tracking.a || config.link_tracking.b || false

    if ( _debug )

      show = (opt)->
        try
          consl "_debug="+opt+"="+this
        catch _error
          conserr "_debug e=" + _error

      this.consl "DEBUG CONFIG OUTPUT ENABLED -- options follow"

      this.consl "localStorage.clear()" + localStorage.clear()
      
      show opt for opt in this.config
      
      try
        this.consl "js_url=" + this.config.js_url
      catch _error
        this.conserr "_debug e="+_error

      try
        this.consl "set_do_not_track=" + this.config.set_do_not_track
      catch _error
        this.conserr "_debug error in set_do_not_track e=" + error

      try
        this.consl "link_tracking=" +this.config.link_tracking
      catch _error
        this.conserr "_debug error in link_tracking e=" +error

    



   ## Console logging
   this.consl = (m) ->
      console.log "px_> "+m




   ## Console Error logging
   this.conserr = (m) ->
     console.error "px**> "+m
    
 piwik.activate()
 piwik
)
