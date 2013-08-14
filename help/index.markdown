---
title: "miniature help?"
layout: default
---

<a name="installation">&nbsp;</a>

## Installation & Configuration
Setup [your configured domains](https://www.cloudflare.com/cloudflare-apps).

<a name="configuration">&nbsp;</a>

### Simple Configuration

1. Turn it on. Configure where your **Piwik Installation URL** is. 
2. Configure a **Website ID** for the domain.
3. Click **UPDATE**, if configured properly all pages should have Piwik Analytics tracking enabled on them.



### Details
* Piwik Installation URL

    This is used to load the *piwik.js* library, and also for the tracker destination.

    Example: `https://piwik.example.com`

    Do not add a trailing **'/'** character. Ideally it should be utilizing [SSL](https://support.cloudflare.com/forums/21317627-SSL-at-CloudFlare) transport for security purposes. Providing a schemeless URL `//host.tld` is also valid for use of other protocols, such as [SPDY](https://www.cloudflare.com/spdy). But only if your tracker installation supports it. Leaving this empty will use the default relative URL `/piwik`

* Piwik Site Id

    Website Id to be tracked.

    If not specified, it will default to use `1`

* Outlinks

    A quoted and comma separated list of configured alias URLs, where clicks on those links will not be counted as 'Outlink'.
    Use of the asterisk ('\*') wildcard token is optional. Example: `"*.other.example.com",".subdomain.example.com"`


### Hey?!
Looking for something beyond the norm? 
[Advanced features](/help/advanced/)
