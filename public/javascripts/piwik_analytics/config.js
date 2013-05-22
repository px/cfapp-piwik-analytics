CloudFlare.define("piwik_analytics/config", [], function() {
  var __pkC;

  __pkC = {
    "_debug": "true",
    "default_piwik_install": "/piwik",
    "default_site_id": "1",
    "piwik_install": "https://piwik-ssl.ns1.net",
    "site_id": "26",
    "tracking_all_subdomains": "2",
    "tracking_group_by_domain": "true",
    "tracking_all_aliases": null,
    "tracking_do_not_track": null,
    "advMenu": "true",
    "paq_push": "[\'setHeartBeatTimer\',5,15],[function(){return window.console.log(\'getVisitorId=\'+this.getVisitorId());}]"
  };
  return window.__piwikConfig = __pkC;
});
