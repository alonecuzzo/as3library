package com.atmospherebbdo.assertions 
{

	/**
	 * An always-failing assertion.
	 * 
	 * @param message	String, description of what's being asserted  as true
	 * @param errorType		Class, an error type to throw on failure
	 * 
	 * @throws errorType
	 */
	{
		assert( false, message, errorType );
	}
}