## Plaidly Advanced
Piwik is an incredible application. It contains a very large feature set of well documented API calls.
Through use of these [JavaScript tracking](http://piwik.org/docs/javascript-tracking/) features, and the **Advanced \_paq** field, you will be able to utilize the complete set of Piwik API calls available for your installation.

1. Enable the **Advanced Features Menu** option
2. Try out some **Advanced \_paq** examples
3. Enable __Logging__ if you experience issues with the JavaScript tracking codes


<hr/>


### *Examples:*
{% include fullsize-warning.html %}

Having a few of these example JavaScript &amp; API calls laying around should spark imaginations.

* Return 0, or any value

`[ function() { return 0;} ]`

* "Hello World" output to console log

`[ function() { return window.console.log( "Hello World"); } ]`

* Get VisitorId and output to console log

`[ function() { return window.console.log( "getVisitorId=" + this.getVisitorId() ); } ]`

* Set Document Title using more advanced methods

`["setDocumentTitle",document.domain + ' / ' + document.title]`

`setDocumentTitle( string )`

* Implement a HeartBeatTimer to record length of pageviews

`['setHeartBeatTimer',30,60]`

`setHeartBeatTimer( minimumVisitLength, heartBeatDelay )`


<hr/>


## Making magic?
Please [share](/CONTRIBUTING.html) the results!


