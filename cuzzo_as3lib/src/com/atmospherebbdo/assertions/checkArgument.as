package com.atmospherebbdo.assertions 
{	import com.atmospherebbdo.errors.IllegalArgumentError;	
	
	/**
	 * Checks that an expression is true, throwing an error if not. The 
	 * expression should relate a function argument to one or more possible
	 * values. 
	 * 
	 * @param	expression	Boolean
	 * @param	message		String
	 * 
	 * @throws	IllegalArgumentError
	 */
	public function checkArgument( expression:Boolean, message:String = "checkArgument failed."):void
	{
		assert( expression, message, IllegalArgumentError );
	}}