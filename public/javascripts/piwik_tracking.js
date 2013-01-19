CloudFlare.require(
    ['cloudflare/console','piwik/js'],
    function(console) {

      console.log("Hello, CloudFlare!");
    }
    );

CloudFlare.define(
    "piwik/js",
    // be sure to keep the same order here in the modules
    [ "cloudflare/config","cloudflare/console", "cloudflare/dom", 'cloudflare/user', "piwik_tracking/config"],

    // as you have here in the parameters
    function(config, console, dom, user, _config) {

      "use strict";


      var Piwik = function Piwik(config) {
        this.piwikEl = null;
        this._config = _config;
        this.cookie = "__piwik_tracking_cfapp_px";

      };

      var piwik = new Piwik (_config);



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
  var test_site = this.config.piwik_receiver || "//pikwik-ssl.ns1.net/piwik.php";
  test_site += "?id="+this.config.site_id+"&amp;rec=1";
  var script = dom.createElement("noscript");
  var cursor = dom.getElementsByTagName('script', true)[0];
  // dom.setAttribute(script, "type", "text/javascript")
  // dom.setAttribute(script, "src", test_site)
  cursor.parentNode.insertBefore(script, cursor);
}

function piwikScript(){
  var piwik_js = this.config.piwik_js || "//cdnjs.cloudflare.com/ajax/libs/piwik/1.10.1/piwik.js";
  var script = dom.createElement("script");
  // var cursor = document.getElementsByTagName('script', true)[0];
  var cursor = dom.getElementsByTagName('script', true)[0];
  // dom.setAttribute(script, "type", "text/javascript");
  dom.setAttribute(script, "src", piwik_js);
  cursor.parentNode.insertBefore(script, cursor);
}



Piwik.prototype.setup = function() {
  piwikScript();
  noScript();
};


console.log("hello piwik");

//if (!window.jasmine) {
// activate if not in jasmine
piwik.activate();

//}

return piwik;

}
);

