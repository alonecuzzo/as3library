package com.atmospherebbdo.dbc 
{
	import com.atmospherebbdo.assertions.assert;
	import com.atmospherebbdo.errors.PreconditionFailureError;				
	
	/**
	 * Checks that an expression is true, throwing an error if not. The 
	 * expression should relate to object state at the beginning of a method
	 * call.
	 * 
	 * @param	expression	Boolean
	 * @param	message		String
	 * 
	 * @throws	PreconditionFailureError
	 */
	public function precondition( expression:Boolean, 
		message:String="Precondition failed."):void
	{
		assert(expression, message, PreconditionFailureError);
	}
}