Piwik.prototype.paqPush = (index) ->
  if (_debug) then piwik.consl "paqPush" + index

  try
    prog =  "_paq = _paq || []; "
    prog += "_paq.push(['setSiteId'," + piwik.config.site_id[index] + " ]); "
    ##prog += "_paq.push(['setTrackerUrl', '" + piwik.config.tracker.[index] + " ]); "

    if piwik.config.link_tracking[index] is "true"
     prog += "_paq.push(['enableLinkTracking',true]);" 
    else
     prog += "_paq.push(['enableLinkTracking',false]);"

    if piwik.config.set_do_not_track[index] is "true"
      prog += "_paq.push(['setDoNotTrack',true]);"
    else
      prog += "_paq.push(['setDoNotTrack',false]);"

    ###
    # pass the options
    ###
    prog += "_paq.push("+piwik.config.paq_push[index]+");"
    ###
    # make the magic happen, track the page view, trackPageView
    ###
    prog += "_paq.push(['trackPageView']);"
    if (_debug ) then piwik.consl(prog)
    scriptEl = document.createElement("script")
    scriptEl.type='text/javascript'
    scriptEl.innerHTML = prog

    document.getElementsByTagName("head")[0].appendChild(scriptEl)

    prog
  
  catch _error
    piwik.conserr "paqPush(index) error index="+index+", e="+_error

