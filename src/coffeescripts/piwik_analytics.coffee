###
* This is Miniature Hipster
*  @name      Miniature Hipster
*  @version   0.0.14
*  @author    Rob Friedman <px@ns1.net>
*  @url       <http://playerx.net>
*  @license   https://github.com/px/cfapp-piwik-analytics/raw/master/LICENSE.txt
*
###

# vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab


#_config = window.__CF.AJS.piwik_analytics
p=window._pk_loaded={stuff:"stuff"}

# var _debug = false;
_debug = true

consl = (m) ->
  window.console.log( "_px_> " + m )

conserr= (m) ->
  window.console.error( "*px**> " + m )



# fixScheme(url) fix the file:// url to use https:// url
#  useful for tracker url fixing schemeless url
fixScheme = (url) ->

  consl( "fixScheme(" + url + ")" ) if _debug
  consl( "window.location.protocol=" + window.location.protocol ) if _debug

  url2=url

  if /^(http).*/.test(url)
    # return the url as it stands
    url2= url
  else
    # url does not have http rewrite it to be what we want.
    url2= "https:"+url

  # return the fixed-up url2
  url2



###
* loadScript(f)
* use CloudFlare.require to load the javascript f requested
* and then execute the callback c
###
loadScript = (f,callback) ->

  consl( "loadScript via CloudFlare.require [" + f + "], "+ callback )

  # maybe needs a delay
  CloudFlare.require( [f], callback )





# stick with commas
CloudFlare.define "piwik_analytics", [""], ( _config ) ->

  "use strict"

  ## Piwik
  myPiwik = {}
  _config = _config || {}

  try
    #   myPiwik.config = _config
    _config = window.__CF.AJS.piwik_analytics || {}
  catch e
    conserr "the _config is broken"


  ### because sometimes a minor delay is needed, in seconds.
* FIXME because I'm sure we can do without.
  ###
  _delay = 0.11

  _default_piwik_version = "1.10.1"

  if ( _debug )
    consl( "Hello from the Piwik CloudFlare App!" + _config )
    # clear localStorage is we're debuging
    consl( "window.localStorage.clear()=" + window.localStorage.clear() )
  # end


  # rudimentary test to see if the piwik.js loads
  #       * if it does, then it will generate a VisitorId
  #       *
  myPiwik.isPiwik = ->
    consl "isPiwik() loaded?"
    # push a command on to the global window._paq array, and
    # set the global window._pk_visitor_id variable
    window._paq = window._paq || []
    try
      window._paq.push [->
        window._pk_visitor_id = @getVisitorId()
      ]
    catch e
      conserr ("issue with window._paq is "+e)

    try
      if ( window._pk_visitor_id is `undefined` or window._pk_visitor_id is "" )
        conserr( " no window._pk_visitor_id piwik maybe failed to load!!! Oh Noe :( :( :(  ): ): ): " )
      else if ( typeof window._pk_visitor_id is "string" and window._pk_visitor_id isnt "" )
        consl( "piwik loaded... probably maybe. window._pk_visitor_id='"+window._pk_visitor_id+"', and tracker hit." )
    catch e
      conserr( "isPiwik() " + e )

    yes


    # some how we need to wait until the piwik.js is asynchronously
    # loaded to ideally determine the _pk_visitor_id

  myPiwik.appChange = ->
    consl( "appChange()" ) if _debug

    try
      #window.setTimeout(
      window.document.getElementById("app_change").innerHTML = ("appChange -- getVisitorId=" + window._pk_visitor_id ) #, 1000*_delay
      consl("_pk_visitor_id="+window._pk_visitor_id)
      myPiwik.isPiwik #)

    catch e
      conserr("appChange " + e)

    yes

  ###
* define it up here
  ###

#  myPiwik.config = (config) ->
#    # apply the config
#    try
#      @config = config
#    catch e
#      conserr "config error!" + e


  ###
* activate()
* this will load and activate the piwik.js from desired location
* fixup the tracker url for missing scheme on file:// url locations
  ###
  myPiwik.activate = () ->
    consl "activate() started"
    _js = ""

    if ( _config.use_cdnjs )
      consl( "_config.use_cdnjs=" + _config.use_cdnjs )
    else
      conserr( "_config.use_cdnjs=" + _config.use_cdnjs )

      ## if we aren't loading from cdnjs and js_url has ben set
    if ( ! _config.use_cdnjs and _config.js_url isnt `undefined` and _config.js_url isnt "" )
      consl( "attempting to use configurered js_url=" + _config.js_url )
      _js = _config.js_url
      #loadScript( fixScheme( unescape( _config.js_url )))

    else
      consl( "use_cdnjs is enabled" )
      # loadScript the _config.default_piwik_js for now
      #loadScript( fixScheme( unescape( _config.default_piwik_js )))
      _js = _config.default_piwik_js

    #loadScript( fixScheme( unescape( _js )))
    #CloudFlare.require([_js])
    loadScript( unescape(_js), "myPiwik.isPiwik()" )
    #myPiwik.isPiwik()
    #myPiwik.appChange()

    # works
    # config.site_id = 'a'
    ## choose the site_id if unset
    if ( _config.site_id is `undefined` or isNaN( _config.site_id ) or ( _config.site_id is "" ) )
      conserr( "Invalid site_id; defaulting to '1'" )
      ## default to site_id 1
      _config.site_id = 1
    else
      consl( "regular site_id from _config "+ _config.site_id )


    if ( _config.piwik_tracker is `undefined` or _config.piwik_tracker is "" )
      _config.piwik_tracker = "FIXME"
    else
      _config.piwik_tracker = fixScheme( unescape( _config.piwik_tracker ))

    consl( "activate() completed")

  ###
* paqPush()
*   push our Piwik options into the window._paq array
  ###
  myPiwik.paqPush = () ->
    consl("paqPush()") if _debug

    window._paq = window._paq || []
    window._paq.push(['setSiteId', unescape ( _config.site_id ) ])
    window._paq.push(['setTrackerUrl', unescape ( _config.piwik_tracker ) ])

    # select if link_tracking is enabled
    if ( _config.link_tracking is "true" )
      window._paq.push(['enableLinkTracking',true])
    else
      window._paq.push(['enableLinkTracking',false])
    #
    if ( _config.set_do_not_track is "true" )
      window._paq.push(['setDoNotTrack',true])
    else
      window._paq.push(['setDoNotTrack',false])
    #
    # pass the options
    window._paq.push( _config.paq_push ) if ! _config.paq_push and _config.paq_push isnt `undefined` and _config.paq_push isnt ""
    consl("paqPush() finished ok!") if _debug
    _config.paq_push

  ###
* noScript()
* this is kind of a waste as it will never get run if javascript is not enabled
  ###
  myPiwik.noScript = ->
    consl( "noScript()" ) if _debug
    test_site = fixScheme( unescape( _config.piwik_tracker ))
    test_site += "?id=" + _config.site_id + "&amp;rec=1"
    consl( "noScript| test_site=" + test_site ) if _debug
    script = document.createElement("noscript")
    cursor = document.getElementsByTagName("script", true)[0]
    cursor.parentNode.insertBefore( script, cursor )



  ###
* do stuff to get the party started
  ###

  # run the activation
  myPiwik.activate()
  # push the commands into the global array
  myPiwik.paqPush()
  # do noScript()
  myPiwik.noScript()

  ###
* instantiate and configure a new instance of the Piwik when it is returned
*  myPiwik = new Piwik(_config)
  ###
  myPiwik


window._pk_loaded = CloudFlare.require ["piwik_analytics"], (_config) ->
  yes

window._pk_loaded.then(
  ->
    (modules) {
      modules
    },
      ->
        (error) {
          console
        #          // Handle errors here..
        }
)

