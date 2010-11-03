package com.atmospherebbdo.dbc 
{
	import com.atmospherebbdo.assertions.assert;
	import com.atmospherebbdo.errors.PostconditionFailureError;		
	
	/**
	 * Checks that an expression is true, throwing an error if not. The 
	 * expression should relate to object state at the end of a method
	 * call.
	 * 
	 * @param	expression	Boolean
	 * @param	message		String
	 * 
	 * @throws	PostconditionFailureError
	 */
	public function postcondition( expression:Boolean, 
		message:String="Postcondition failed."):void
	{
		assert(expression, message, PostconditionFailureError);
	}}