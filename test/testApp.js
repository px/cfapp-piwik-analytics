document = document || [];

"use strict;";

var _debug = _debug || true;


var _paq = _paq || []; 
var visitor_id="default id";
var get_tracker="default tracker";

_paq.push([ function() { visitor_id = this.getVisitorId(); }]);
// _paq.push([ function() { get_tracker = this.getAsyncTracker(); }]);

function update_status() {

  document.getElementById("visitorId").innerHTML = "getVisitorId="+ visitor_id ;
  document.getElementById("timeDiv").innerHTML = "Timer update";

  try {

  document.getElementById("piwik_js_default").innerHTML = "piwik_js_default="+piwikConfig.piwik_js_default;
  document.getElementById("js_url").innerHTML = "js_url="+piwikConfig.js_url;
  document.getElementById("use_cdnjs").innerHTML = "use_cdnjs="+ piwikConfig.use_cdnjs ;
  
  
  document.getElementById("site_id.a").innerHTML = "site_id.a="+piwikConfig.site_id.a;
  document.getElementById("site_id.b").innerHTML = "site_id.b="+piwikConfig.site_id.b;
  
  document.getElementById("trackerURL.a").innerHTML = "trackerURL.a="+piwikConfig.tracker.a;
  document.getElementById("trackerURL.b").innerHTML = "trackerURL.b="+piwikConfig.tracker.b;
  
  document.getElementById("getTracker").innerHTML = "getTracker="+get_tracker;

  document.getElementById("paq_push.a").innerHTML = "paq_push.a="+piwikConfig.paq_push.a;
  document.getElementById("paq_push.b").innerHTML = "paq_push.b="+piwikConfig.paq_push.b;
  } catch (e) {

    /* silently ignore the error */
  }

}

// 
var limit="0:3";

if(document.images){var parselimit=limit.split(":");parselimit=parselimit[0]*60+parselimit[1]*1;}

var saveTime=parselimit;

function refresh(){
  if(!document.images){return;}
  if(parselimit==1){

    // do work
    update_status();

    parselimit=saveTime;
    setTimeout(refresh,1000);

  } else {

    parselimit-=1;
    curmin=Math.floor(parselimit/60);
    cursec=parselimit%60;
    if(curmin!==0){
      curtime=curmin+" minutes and "+cursec+" seconds until update";
    } else {
      curtime=cursec+" seconds left until update";
    }

    document.getElementById('timeDiv').innerHTML = curtime;

    // unquoted causes stack error when using arguments ()
    setTimeout(refresh,1000);
  }
}

window.onload=refresh();

