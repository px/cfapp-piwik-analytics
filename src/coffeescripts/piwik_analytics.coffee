###
* This is Miniature Hipster
*  @name      Miniature Hipster
*  @version   0.0.21b
*  @author    Rob Friedman <px@ns1.net>
*  @url       <http://playerx.net>
*  @license   https://github.com/px/cfapp-piwik-analytics/raw/master/LICENSE.txt
*  @todo      TODO: 
*
###

# vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab


#_config = window.__CF.AJS.piwik_analytics
p=window._pk_loaded={stuff:"stuff"}


###
* simple stylized console output for my app
###
consl = ( msg = "" ) ->
  #msg = "" if msg is undefined
  window.console.log( "_px_> " + msg )
###
* simple stylized console error output for my app
###
conserr= ( msg = "" ) ->
  #msg = msg if msg is undefined
  window.console.error( "*px**> " + msg )

_debug = null

# just so it isnt lost.
window._paq = window._paq || []
# send our request for VisitorId
#window._paq.push [->
#  window._pk_visitor_id = @getVisitorId()
#  consl( "Piwik Loaded, window._pk_visitor_id="+ window._pk_visitor_id ) if _debug
#]


# fixScheme(url) fix the file:// url to use https:// url
#  useful for tracker url fixing schemeless url
fixScheme = (url) ->
  consl( "fixScheme(" + url + ")" ) if _debug?
  consl( "window.location.protocol=" + window.location.protocol ) if _debug?

  url2=url

  if /^(http).*/.test(url)
    # return the url as it stands
    url2= url
  else
    # url does not have "http[s]" rewrite it to be what we want, "https:".
    url2= "https:"+url

  # return the fixed-up url2
  url2



###
* loadScript(f)
* use CloudFlare.require to load the javascript f requested
* and then execute the callback c
###
loadScript = (f,callback) ->
  consl( "loadScript via CloudFlare.require( [" + f + "], "+ callback +")") if _debug?
  CloudFlare.require( [f], callback )


###
# piwik_analytics module definition
#
# Requires piwik_analytics/config FIXME not true, reads from embedded
#     CDATA from CloudFlare currently; Hopefully will fix to use param arguments
# 
# TODO: Debating putting logic to call for piwik.js above so that way it can be loaded
#     sooner most likely.
#     Figure out why ["piwik_analytics/config"] is not working
# stick with commas for sep
###
CloudFlare.define "piwik_analytics", ( _config ) ->
  #CloudFlare.define "piwik_analytics",["piwik_analytics/config","//cdnjs.cloudflare.com/ajax/libs/piwik/1.10.1/piwik.js"], ( _config ) ->

  "use strict"

  ## myPiwik module; to be passed into a "return" later which will cause loading
  myPiwik = {}
  ## find our configuration, or just create the storage
  _config = _config

  ## Try reading the piwik_analytics configuration from embedded CDATA; FIXME
  # there is a better way to do this through the parameter above I'm sure
  # but I haven't gotten it to work yet.
  try
    _config = window.__CF.AJS.piwik_analytics
    _debug = _config._debug
  catch e
    conserr(e)
    conserr("Where is CloudFlare? window.__CF.AJS.piwik_analytics --  Enabling Debugger, and testing defaults! ")
    _config = {}
    _debug = _config._debug = true
    _config.default_site_id="1"
    _config.default_piwik_js="/piwik/piwik.js"
    _config.default_piwik_tracker="/piwik/piwik.php"
   

  if _config.default_site_id is undefined or _config.default_site_id is null
    _config.default_site_id = "1"

  if _config.default_piwik_js is undefined or _config.default_piwik_js is null
    _config.default_piwik_js = "/piwik/piwik.js"
  
  if _config.default_piwik_tracker is undefined or _config.default_piwik_tracker is null
    _config.default_piwik_tracker = "/piwik/piwik.php"

  ### because sometimes a minor delay is needed, in seconds.
* FIXME because I'm sure we can do without.
  ###
  #_delay = 0.11

  ## likely not needed FIXME
  #_default_piwik_version = "1.10.1"

  # send our request for VisitorId
  window._paq.push [->
    window._pk_visitor_id = @getVisitorId()
    # output console message with VisitorId once piwik.js is loaded
    consl( "piwik.js is loaded, window._pk_visitor_id="+ window._pk_visitor_id ) if _debug?
  ]

  ## If we're debugging, say Hello, and clear localStorage
  if ( _debug? )
    consl( "Hello from the Piwik CloudFlare App! Object?->" + _config )
    # clear localStorage is we're debuging
    consl( "window.localStorage.clear() === undefined? " + ( window.localStorage.clear()? ) )
  # end

  ###
  # myPiwik.isPiwik()
  * pushes a request for the Piwik VisitorId generated once piwik.js executes
  * performs a rudimentary test to see if the piwik.js loads
  * if it does, then it will return a yes, other no
  *
  ###
  myPiwik.isPiwik = ->
    consl( "myPiwik.isPiwik() loaded?") if _debug?
    # push a command on to the global window._paq array, and
    # set the global window._pk_visitor_id variable
    #window._paq = window._paq || []
    #try
    #  window._paq.push [->
    #    window._pk_visitor_id = @getVisitorId()
    #  ]
    #catch e
    #  conserr ("There is an issue with window._paq; "+e) if _debug

    # This really needs a delay before attempting to read _pk_visitor_id; FIXME
    # some how we need to wait until the piwik.js is asynchronously
    # loaded to ideally determine the _pk_visitor_id
    try
      if ( window._pk_visitor_id is undefined or window._pk_visitor_id is "" )
        conserr( " no window._pk_visitor_id piwik maybe failed to load!!! Oh Noe. " ) if _debug?
        # return a no, not loaded
        return no
      else if ( typeof window._pk_visitor_id is "string" and window._pk_visitor_id != "" )
        consl( "Piwik loaded... probably maybe. window._pk_visitor_id='"+window._pk_visitor_id+"', and tracker hit." ) if _debug?
        # return a yes, piwik.js has been loaded
        return yes
    catch e
      conserr( "isPiwik() " + e )
    # return a no
    no
    # end myPiwik.isPiwik()



  ###
* myPiwik.activate()
* TODO: break this into three different methods
*         one; which determines the tracking library URL to load
*         two; determines a valid SiteId
*         three; another which determines a valid TrackerURL
* This will currently:
*     fixup a missing siteId to be id=1
*     determine how to load and activate the piwik.js from desired location
*     FIXME; will not fixup the tracker url for missing scheme on file:// url locations
  ###
  myPiwik.activate = () ->
    consl( "myPiwik.activate() started") if _debug?

    # temp value to store the javascript library url
    _js = _config.default_piwik_js || "/piwik/piwik.js"

    ## if we are not loading from cdnjs and piwik_js has been set
    if ( ( _config.piwik_js isnt null and _config.piwik_js isnt undefined ) and ( _config.use_cdnjs is null or _config.use_cdnjs is undefined ) )
      consl( "Using configured piwik_js=" + _config.piwik_js ) if _debug?
      _js = _config.piwik_js

    else if ( _config.use_cdnjs is "true" or _config.piwik_js is "" )
      consl( "Using use_cdnjs is enabled; " + _config.default_piwik_js ) if _debug?
      _js = _config.default_piwik_js

    else
      conserr("Using Failsafe _js=" + _config.default_piwik_js ) if _debug?
      _js = _config.default_piwik_js

    ## load the determined _js library, then execute isPiwik() callback
    #loadScript( unescape( _js ), myPiwik.isPiwik )
    #loadScript( unescape( _js ), null )
    #alert("past loadScript") if _debug
    CloudFlare.require([_js])





    # check for null, undefined, not a number, or empty site_id values
    _site_id = _config.default_site_id || "1"
    # works
    ## choose the site_id if unset
    if ( ( _config.site_id is null ) or isNaN( _config.site_id ) or  _config.site_id is "" )
      ## default to default_site_id from cloudflare.json
      conserr( "Invalid site_id; defaulting to "+ _site_id ) if _debug?
    else
      consl( "Using site_id from _config "+ _config.site_id ) if _debug?
      _site_id = _config.site_id
    # end if site_id
    _config.site_id = _site_id



    ## poorly placed default
    _piwik_tracker = _config.default_piwik_tracker || "/piwik/piwik.php"
    if ( _config.piwik_tracker is null or _config.piwik_tracker is undefined )
      conserr("Invalid piwik_tracker using default=" + _piwik_tracker ) if _debug?
      # FIXME; there should be a better resort than this;
      #   maybe determine the zone from CloudFlare CDATA;
      #   or use "example.com" but that would leak more data
      #_piwik_tracker = _piwik_tracker
    else
      consl("Using configured piwik_tracker=" + _config.piwik_tracker ) if _debug?
      # just unescape the tracker url
      # using fixscheme here with the url will
      # break what the user requests in their configuration
      _piwik_tracker = _config.piwik_tracker
      #_config.piwik_tracker = _config.piwik_tracker

    # end if piwik_tracker
    _config.piwik_tracker = unescape( _piwik_tracker )

    consl( "myPiwik.activate() completed" ) if _debug?
    # return a yes, it's mostly a lie, but who cares >:)
    yes
    # end myPiwik.activated







  ###
* myPiwik.paqPush()
*   take options from a Piwik configuration
*     We could have multiple trackers someday! TODO
*     It's easy, just not supported in this App.
*   push our Piwik options into the window._paq array
*   send a trackPageView to the TrackerUrl
  ###
  myPiwik.paqPush = () ->
    consl( "myPiwik.paqPush()" ) if _debug?
    # read in or create the _paq array if undefined; FIXME probably do not have to do this everywhere.
    window._paq = window._paq || []
    # send request for VisitorId, we can do this anytime
    #   and it will be assigned once piwik.js is executed
    #window._paq.push [->
    #  window._pk_visitor_id = @getVisitorId()
    #]
    # push the SiteId
    window._paq.push(['setSiteId', unescape ( _config.site_id ) ])
    # push the TrackerUrl
    window._paq.push(['setTrackerUrl', unescape ( _config.piwik_tracker ) ])

    # determine if LinkTracking is enabled, default to enable if undefined
    if ( _config.link_tracking is "true" or _config.link_tracking is undefined )
      window._paq.push(['enableLinkTracking',true])
    else
      window._paq.push(['enableLinkTracking',false])
    # end if link_tracking

    # determine if DoNotTrack is enabled, default to obey if undefined
    if ( _config.set_obey_do_not_track is "true" or _config.set_obey_do_not_track is undefined )
      window._paq.push(['setDoNotTrack',true])
    else
      window._paq.push(['setDoNotTrack',false])
    # end if do_not_track

    # pass the extra options if any
    window._paq.push( _config.paq_push ) if ( ( ! _config.paq_push ) and ( _config.paq_push isnt undefined ) and (_config.paq_push isnt "") )

    # Send a trackPageView request to the TrackerUrl
    window._paq.push(['trackPageView'])

    consl("paqPush() finished ok! _paq=" + window._paq ) if _debug
    #return the _paq array
    window._paq
    # end myPiwik.paqPush

  ###
* noScript()
* this is kind of a waste as it will never get run if javascript is not enabled
  ###
  myPiwik.noScript = ->
    consl( "myPiwik.noScript()" ) if _debug
    test_site = fixScheme( unescape( _config.piwik_tracker ))
    test_site += "?id=" + _config.site_id + "&amp;rec=1"
    consl( "noScript| test_site=" + test_site ) if _debug
    script = document.createElement("noscript")
    cursor = document.getElementsByTagName("script", true)[0]
    cursor.parentNode.insertBefore( script, cursor )
    # just return a yes
    yes
    # end myPiwik.noScript


  ###
* do stuff to get the party started
  ###

  # run the activation
  myPiwik.activate()

  # push the commands into the global array
  myPiwik.paqPush()

  # do noScript() FIXME; need to have "first class" access 
  #   to page contents in order to embed elements via CloudFlare proxy
  # myPiwik.noScript()

  ###
* instantiate and configure a new instance of Piwik module when it is returned
* Something like below
* # myPiwik = new Piwik(_config)
  ###
  myPiwik
  # end myPiwik module

###
* Require our piwik_analytics module to be loaded, and our configuration.
###
window._pk_loaded = CloudFlare.require ["piwik_analytics"], (_config) ->
  yes

###
* CloudFlare has .then methods for performing other actions once a module has been required.
* We're not using them, but they're here.
###
window._pk_loaded.then(
  ->
    (modules) {
      modules
    },
      ->
        (error) {
          console
        # // Handle errors here..
        }
)

