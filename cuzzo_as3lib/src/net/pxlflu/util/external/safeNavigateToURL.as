package com.atmospherebbdo.util.external 
{	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;	

	/**
	 * Uses external interface to avoid popup blockers if it is available.
	 * Otherwise, exactly the same as flash.net.navigateToURL().
	 * 
	 * @param	request	URLRequest
	 * @param	window	String, optional, defaults to "_self"
	 */
	public function safeNavigateToURL( request:URLRequest, window:String="_self") :void
	{
		const SAME_WINDOW:String = "_self";
		
		// just navigate if we aren't opening up a new window or can't
		// do any fancy javascript
		if (!ExternalInterface.available || window == SAME_WINDOW) 
		{
			navigateToURL(request, window);
		} 
		else 
		{
			// evade pop-up blockers as needed
			if 	( userAgentIsFirefox() || userAgentIsRecentInternetExplorer() ) 
			{
				ExternalInterface.call("window.open", request.url, window);
			} 
			else 
			{
				navigateToURL(request, window);
			}
		}
	}}

import com.atmospherebbdo.dbc.precondition;

import flash.external.ExternalInterface;

/**
 * Returns true if the browser is Firefox.
 * 
 * @return Boolean	true if using Firefox.
 */
function userAgentIsFirefox() :Boolean
{
	var userAgent:String = getUserAgent();
	return userAgent.indexOf("firefox") != -1;
}

/**
 * Returns true if the browser is a recent IE.
 * 
 * @return Boolean	true if using a recent IE.
 */
function userAgentIsRecentInternetExplorer() :Boolean
{
	var userAgent:String = getUserAgent();
	return userAgent.indexOf("msie") != -1 && uint(userAgent.substr(userAgent.indexOf("msie") + 5, 3)) >= 7;
}

/**
 * Retrieves the user agent string from the current brower, 
 * if possible.
 * 
 * @return String
 */
function getUserAgent() :String
{
	precondition( ExternalInterface.available );
		
	if (cachedUserAgent == null)
	{
		cachedUserAgent = String(ExternalInterface.call("function() {return navigator.userAgent;}")).toLowerCase();
	}
	return cachedUserAgent;
}

var cachedUserAgent:String;