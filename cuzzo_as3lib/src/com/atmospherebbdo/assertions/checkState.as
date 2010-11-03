package com.atmospherebbdo.assertions 
{	import com.atmospherebbdo.errors.IllegalStateError;			
	
	/**
	 * Checks that an expression is true, throwing an error if not. The 
	 * expression should relate to object state at the beginning of a method
	 * call.
	 * 
	 * @param	expression	Boolean
	 * @param	message		String
	 * 
	 * @throws	IllegalStateError
	 */
	public function checkState( expression:Boolean, 
		message:String = "checkState failed."):void
	{
		assert( expression, message, IllegalStateError );
	}}