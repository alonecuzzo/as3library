package com.atmospherebbdo.assertions 
{
	/**
	 * Checks that an object is defined, throwing an error if not. 
	 * The object should be a function argument. The object may be null.
	 * 
	 * @param	object		Object
	 * @param	message		String
	 */
	public function checkNotUndefined( object:*, 
		message:String = "checkNotUndefined failed."):void
	{
		assert(object !== undefined, message);
	}}