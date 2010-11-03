package com.atmospherebbdo.assertions 
{	
	/**
	 * Simple assertion mechanism.
	 * 
	 * @param assertion Boolean, an expression to evaluate
	 * @param message	String, description of what's being asserted  as true
	 * @param errorType		Class, an error type to throw on failure
	 * 
	 * @throws errorType
	 */	public function assert( assertion:Boolean, message:String=null, 
		errorType:Class=null ) :void
	{
		// wrap assertion in a trace() call so we can disable assertions by
		// disabling trace() in the compilation settings
		trace(implementAssertion(assertion, message, errorType));
	}
}

import com.atmospherebbdo.errors.AssertionFailureError;

/**
 * The actual implementation of assertions.
 * 
 * @param assertion Boolean, an expression to evaluate
 * @param message	String, description of what's being asserted  as true
 * @param errorType	Class, an error type to throw on failure
 * 
 * @throws errorType
 */
function implementAssertion( assertion:Boolean, message:String=null, 
	errorType:Class=null ) :void
{
	if (assertion != true)
	{
		if (errorType == null)
		{
			errorType = AssertionFailureError;
		}
		
		var e:Error = new errorType(message);
		if (e != null)
		{
			throw e;
		}
	}
}
