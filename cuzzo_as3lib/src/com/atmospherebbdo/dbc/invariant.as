package com.atmospherebbdo.dbc 
{
	import com.atmospherebbdo.assertions.assert;
	import com.atmospherebbdo.errors.InvariantFailureError;		
			
	
	/**
	 * Used to verify that an expression remains true for a time,
	 * as during a loop or method call.
	 * 
	 * @param	expression	Boolean
	 * @param	message		String
	 * 
	 * @throws	InvariantFailureError
	 */
	public function invariant( expression:Boolean, 
		message:String="Invariant failed."):void
	{
		assert(expression, message, InvariantFailureError);
	}}