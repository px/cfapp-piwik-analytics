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
#
#    __defaultConf = {
#      _debug: null
#      default_debug: "true"
#      piwik_install:"/piwik"
#      default_piwik_install:"/piwik"
#      site_id:null
#      default_piwik_site_id:"1"
#      paq_push:null
#      tracking_all_subdomains:"true"
#      tracking_do_not_track: null
#    }
#
    ## create _paq array
    window._paq = window._paq || []

#    setup.setDefault = (v, d, m) ->
#      try
#        # if the variable is undefined or empty
#        if ( v is undefined or v is ""  )
#          # output a log message
#          __console.error("Invalid "+m+" = \""+v+"\", using default "+ m + " = \""+ d+"\" " )
#          # assign the variable the value of the default
#          v = d
#        # return v
#        v
#      catch e3 # catch the error
#        # perform the assignment of the default value
#        v = d
#        # output an error message
#        __console.error (e3)
#        # return v
#        v

    ## copy over config -- need a better way
    setup._debug = __conf._debug
    setup.default_piwik_site_id = __conf.default_piwik_site_id
    setup.default_piwik_install = __conf.default_piwik_install
    setup.site_id = __conf.site_id
    setup.piwik_install = __conf.piwik_install
    setup.tracking_do_not_track = __conf.tracking_do_not_track
    setup.tracking_group_by_domain = __conf.tracking_group_by_domain
    setup.tracking_all_aliases = __conf.tracking_all_aliases
    setup.paq_push = __conf.paq_push
    
    #setup._debug = null    ## null is "" or empty
    #setup._debug = "true"  ## true is "true" or not null

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

