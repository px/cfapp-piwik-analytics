# vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

###
* definition for setup
###
CloudFlare.define 'piwik_analytics/setup', [
  'cloudflare/console'
  'piwik_analytics/config'
  'piwik_analytics/perf'
],
  ( __console,
    __config = {
      _debug: yes
      piwik_install:'/piwik'
      site_id:'1'
      paq_push:""
      tracking_all_subdomains: yes
      tracking_do_not_track: no
    },
      __perf
  ) ->

    __console.log("START piwik_analytics/setup")
    ## create _paq array
    window._paq = window._paq || []


    setup = {}

    setup.perfThen = __perf.now()
    #(__config) ->
    #    __console.log("mod START piwik_analytics/setup")

    #    ## create _paq array
    #    window._paq = window._paq || []

    #    for opt in __config
    #      __console.log("option: "+opt)

    # _debug must be either true or null
    setup.default_debug = true # || null
    # default piwik tracker URL
    setup.default_piwik_install = "/piwik"
    # default piwik tracker id
    setup.default_piwik_site_id = "1"

    # for testing on js.cloudflare.com
    if (window.document.location.hostname is "js.cloudflare.com")
      __console.log("js.cloudflare.com sandbox DETECTED!")
      __config._debug = true # || null
      __config.piwik_install="//piwik-ssl.ns1.net"
      __config.site_id="28"


    setup.setDefault = (v, d, m) ->
      try
        # if the variable is undefined
        if v is undefined
          # assign the variable the value of the default
          v = d
          # output a log message
          __console.log("Using test default "+ m + " \t = "+ d )
        # return v
        v
      catch e3 # catch the error
        # perform the assignment of the default value
        v = d
        # output an error message
        __console.error (e3)
        # return v
        v


    ###
# myPiwik.setSiteId()
#
#   checks for a null value, not a number, and assign's SiteId to default
    ###
    setup.setSiteId =
      ( _SiteId ) ->

        # if it's a number use it. Double Negative,
        # will catch, alpha, and use the default above
        if ( not isNaN( _SiteId ) )
          __console.log( "setup.setSiteId\t = "+ _SiteId ) if setup._debug?
        else
          # default to default_site_id from cloudflare.json
          __console.error( "setup.setSiteId -- Invalid Website Id = "+ _SiteId+
            " ; defaulting to " + setup.default_piwik_site_id ) if setup._debug?
          _SiteId = setup.default_piwik_site_id

        # end if site_id
        window._paq.push(['setSiteId', unescape ( _SiteId ) ])
        _SiteId

    ###
# mypiwik.setInstall
# sets the tracker for the client to use
    ###
    setup.setInstall =
      (_install = setup.default_piwik_install ) ->
        if setup._debug?
          #  perfThen=__perf.now()
          __console.log("setup.setInstall\t = \""+unescape( _install)+"\"")
          # start the performance counter
          #myPiwik.perf()

        # fetch the piwik library
        #myPiwik.fetch([ unescape( _install + "/piwik.js" ) ])

        window._paq.push([
          'setTrackerUrl', unescape ( _install ) + "/piwik.php"
        ])
        #__console.log(
        #  "end myPiwik.setInstall time = "+
        #  (__perf.now() - perfThen)
        #) if setup._debug?

        ###
#return _install
        ###
        _install

    ###
    # config the defaults
    ###
    setup._debug = setup.setDefault( __config._debug, setup.default_debug, "Debug" )
    setup.piwik_install = setup.setInstall( setup.setDefault( __config.piwik_install, setup.default_piwik_install, "Install" ) )
    setup.site_id = setup.setSiteId( setup.setDefault( __config.site_id, setup.default_piwik_site_id, "WebsiteId" ) )
    #__console.log( "Hello from the Piwik Analytics CloudFlare App!" )

    #setup._debug = yes
    #setup.piwik_install ='/piwik-----'
    #setup.site_id=28

    __console.log("END piwik_analytics/setup")

    setup
###
# end of setup module
###

