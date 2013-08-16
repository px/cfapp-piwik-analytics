## Plaidly Advanced
Piwik is an incredible application. It contains a very large feature set of well documented API calls.
Through use of these [Javascript tracking](http://piwik.org/docs/javascript-tracking/) features, and the **Advanced \_paq** field, you will be able to utilize the complete set of Piwik API calls available for your installation.

1. Enable the **Advanced Features Menu** option.
2. Try out some **Advanced \_paq** examples.
3. Enable __Logging__ if you experience issues with the Javascript tracking codes.


<hr/>


### *Examples:*
Having a few of these laying around should spark imaginations.

* Return 0

`[ function() { return 0;} ]`

* Hello World displayed in console log

`[ function() { return window.console.log( "Hello World"); } ]`

* Get VisitorId and display in console log

`[ function() { return window.console.log( "getVisitorId=" + this.getVisitorId() ); } ]`

* Set the Document Title using more advanced methods

`["setDocumentTitle",document.domain + ' / ' + document.title]`

* Implement a HeartBeatTimer

`['setHeartBeatTimer',30,60]`


<hr/>


## Making magic?
Please [share](/CONTRIBUTING.html) the results!


