CloudFlare.require(
    ['cloudflare/console','piwik/js'],
    function(console) {

      console.log("Hello, CloudFlare!");
    }
    );

CloudFlare.define(
    "piwik_tracking.js",
    [ "cloudflare/dom", 'cloudflare/user', "piwik_tracking/config"],

    function(dom, config) {
      "use strict";


      var Piwik = function Piwik(config) {
        this.piwikEl = null;
        this.config = config;
        this.cookie = "__piwik_tracking_cfapp_px";

      };

      var piwik = new Piwik (config);



     var translations =
{
  'en': 'English: ',
  'es': 'Espanol: ',
  'de': 'Deutsche: ',
  'fr': 'French: '
};

/*
 * detect language using the browser
 * */
var language = window.navigator.browserLanguage || window.navigator.userLanguage || 'en',
    translation = translations[ language.substring( 0, 2 ) ] || translations.en;

Piwik.prototype.activate = function() {
  // check to see if our configuration is correct, then run the setup.
  if (typeof this.config.side_id == "string" && this.config.side_id !== "") {
    this.setup();
  }


};

function noScript(){
  var test_site = "//pikwik-ssl.ns1.net/piwik.php?id=6&amp;rec=1";
  var script = dom.createElement("noscript");
  var cursor = document.getElementsByTagName('script', true)[0];
  // dom.setAttribute(script, "type", "text/javascript")
  // dom.setAttribute(script, "src", test_site)
  cursor.parentNode.insertBefore(script, cursor);
}

function piwikScript(){
  var piwik_js = "//pikwik-ssl.ns1.net/piwik.js";
  var script = dom.createElement("script");
  var cursor = document.getElementsByTagName('script', true)[0];
  // dom.setAttribute(script, "type", "text/javascript");
  dom.setAttribute(script, "src", piwik_js);
  cursor.parentNode.insertBefore(script, cursor);
}



Piwik.prototype.setup = function() {
  noScript();
  piwikScript();
};



if (!window.jasmine) {
// activate if not in jasmine
  piwik.activate();

}

return piwik;

}
);

