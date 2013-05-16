CloudFlare.define("piwik_analytics/config", [], function() {
  var __pkC;

  __pkC = {
    "_debug": "true",
    "default_piwik_install": "/piwik",
    "default_site_id": "1",
    "piwik_install": "https://piwik-ssl.ns1.net",
    "site_id": "26",
    "link_tracking": "true",
    "tracking_all_subdomains": "2",
    "tracking_group_by_domain": "true",
    "tracking_all_aliases": null,
    "tracking_all_aliases": "'example.com','foo.com','bar.net'",
    "tracking_do_not_track": null,
    "paq_push": "\t    [\'setHeartBeatTimer\',5,30],\t,, [\'setLinkTrackingTimer\',250] ,,,,, [\'disableCookies\'] ,[ function() { return window.console.log('getVisitorId='+this.getVisitorId()); } ],['this'],false-true,['that'],    , ['trackPageView'], 'bad array1'], ['bad array', ; stuff,\" ][,i&#![]],[9],",
    "paq_push": "[\'setHeartBeatTimer\',2,5]"
  };
  return window.__piwikConfig = __pkC;
});
