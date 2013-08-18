
<a name="install">&nbsp;</a>

# Suit Up

To utilize Miniature Hipster, Piwik must be [installed](http://piwik.org/docs/installation/) already, or are using a [hosted Piwik](http://piwik.org/hosting/) package.

+ Turn on **Piwik Analytics** for CloudFlare [configured domains](https://www.cloudflare.com/cloudflare-apps) within the Apps section


<a name="config">&nbsp;</a>

## Configure

1. Configure the **Piwik Installation URL**
3. Provide a **Website ID** for the domain
4. Click **UPDATE**

If configured properly all pages should have Piwik Analytics tracking enabled on them.


<hr/>

<a name="details">&nbsp;</a>
### Details
 
<span class="visible-xs hidden-lg hidden-md label label-info">View on fullsize device to see example code.</span>
* Piwik Installation URL

    This is used to load the *piwik.js* library, and also for the tracker destination.

    Do not add a trailing **'/'** character. Ideally it should be utilizing [SSL](https://support.cloudflare.com/forums/21317627-SSL-at-CloudFlare) transport for security purposes. Providing a schemeless URL `//host.tld` is also valid for use of other protocols, such as [SPDY](https://www.cloudflare.com/spdy). But only if your tracker installation supports it. Leaving this empty will use the default relative URL `/piwik`
    
    Example:

```https://piwik.example.com```

* Piwik Site Id

    Website Id to be tracked.

    If not specified, it will default to use `1`

* Outlinks

    A quoted and comma separated list of configured alias URLs, where clicks on those links will not be counted as 'Outlink'.
    Use of the asterisk ('\*') wildcard token is optional.

    Example:

`
"*.other.example.com", ".subdomain.example.com"
`

<hr/>

## Go Plaid
Not into simple suits? 
Try on some [advanced features](/help/advanced/).
