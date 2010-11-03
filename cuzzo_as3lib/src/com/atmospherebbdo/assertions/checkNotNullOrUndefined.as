package com.atmospherebbdo.assertions 
{			
	
	/**
	 * Checks that an object is not null or undefined, throwing an error if not. 
	 * The object should be a function argument. 
	 * 
	 * @param	object		Object
	 * @param	message		String
	 */
	public function checkNotNullOrUndefined( object:*, 
		message:String = "checkNotNullOrUndefined failed." ):void
	{
		assert(object !== null && object !== undefined, message);
	}}