package com.atmospherebbdo.assertions 
{

	/**
	 * An always-failing assertion.
	 * 
	 * @param message	String, description of what's being asserted  as true
	 * @param errorType		Class, an error type to throw on failure
	 * 
	 * @throws errorType
	 */	public function fail( message:String=null, errorType:Class=null ) :void
	{
		assert( false, message, errorType );
	}
}
