
Process Notes
-------------
* New versions TODO
  * better describe the process
  * npm -- there is a [package.json](package.json) to help with dependencies.
   * Install package dependecies - (`npm install -d`)

    * automatically compile changes to coffeescript files within this project using the [Cakefile](Cakefile) script. (`cake bake`)
    * test compiled javascript using [local testing](test/index.html)
    * test compiled javascript using [js.cloudflare.com](http://js.cloudflare.com/)
      * [pbcopy](http://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/pbcopy.1.html) is your friend. (`pbcopy < public/javascripts/piwik_analytics.js`)
    * Validation: (`./validate.sh`)
      * automatically validate and check cloudflare.json &amp; and soon other json files with jsonlint

    * which files need to version bump;
      * [Cakefile](Cakefile) -- top of file
      * [cloudflare.json](cloudflare.json) -- end of file
      * [package.json](package.json) -- top of file

    * `git commit cloudflare.json package.json Cakefile -m "version bump"`

    * Once you are happy, proceed to push your new version as follows.
      1. [login to CloudFlare](https://www.cloudflare.com/login)
      2. [App Developer Dashboard](https://www.cloudflare.com/app-signup)
      3. click on "more", then "Pull new version" button. Now WAIT! Here be dragons.

    So your pull was successful? Now tag that version!
    * `git tag <version>`

