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
    __conf,
    __perf
  ) ->
    #    __console.log("START piwik_analytics/setup")
    setup = {}

    # store the current time
    setup.perfThen = __perf.now()

    __defaultConf = {
      _debug: `false`
      default_debug: yes
      piwik_install:'/piwik'
      default_piwik_install:'/piwik'
      site_id:''
      default_piwik_site_id:1
      paq_push:""
      tracking_all_subdomains:yes
      tracking_do_not_track: no
    }

    #__conf = undefined
    if __conf is undefined
      __conf = __defaultConf

    # for testing on js.cloudflare.com
    if (window.document.location.hostname is "js.cloudflare.com")
      __console.error("js.cloudflare.com sandbox DETECTED! Using developer testing config.")
      __devConf = __defaultConf
      __devConf._debug="true"
      ##__devConf._debug=null
      __devConf.piwik_install='' ## purposefully invalid
      __devConf.default_piwik_install='//piwik-ssl.ns1.net'
      __devConf.site_id='invalid' ## purposefully invalid
      __devConf.default_piwik_site_id="28"
      ## this array block will be unescaped, evaled, and  pushed into the window._paq
      __devConf.paq_push="[ function() { return window.console.log(\"getVisitorId=\"+this.getVisitorId()); } ]"
      __devConf.tracking_group_by_domain="document.domain + '/' + document.title"
      __devConf.tracking_all_aliases="[\"*.piwik.example.com\",\"*.p-ssl.example.com\",\"*.p.example.com\",\"*.piwik-ssl.example.com\"]"
      ## apply our development configuration over what is in-place
      __conf = __devConf


    ## create _paq array
    window._paq = window._paq || []

    setup.setDefault = (v, d, m) ->
      try
        # if the variable is undefined or empty
        if ( v is undefined or v is ""  )
          # output a log message
          __console.error("Invalid "+m+" = \""+v+"\", using default "+ m + " = \""+ d+"\" " )
          # assign the variable the value of the default
          v = d
        # return v
        v
      catch e3 # catch the error
        # perform the assignment of the default value
        v = d
        # output an error message
        __console.error (e3)
        # return v
        v

    ## copy over config -- need a better way
    setup._debug = __conf._debug
    setup.default_piwik_site_id = __conf.default_piwik_site_id
    setup.default_piwik_install = __conf.default_piwik_install
    setup.site_id = __conf.site_id
    setup.piwik_install = __conf.piwik_install
    setup.paq_push = __conf.paq_push
    setup.tracking_group_by_domain = __conf.tracking_group_by_domain
    setup.tracking_all_aliases = __conf.tracking_all_aliases
    
    #setup._debug = null    ## null is "" or empty
    #setup._debug = "true"  ## true is "true" or not null

    #__console.log("setup._debug="+setup._debug)
    #__console.log("setup.site_id="+setup.site_id)
    #__console.log("setup.install="+setup.piwik_install)
    if setup._debug isnt null
      CloudFlare.push( { verbose:1 } )
      window.localStorage.clear()

      #__console.log("END piwik_analytics/setup")

      try
        __console.log(
          (__perf.now() - setup.perfThen) + " ms"+
            "\t piwik_analytics/setup execution time")
      catch e
        __console.error("uhoh "+e)

    setup
###
# end of setup module
###

