package com.atmospherebbdo.assertions 
{
	/**
	 * Checks that an object is not null, throwing an error if so. 
	 * The object should be a function argument. The object may be undefined.
	 * 
	 * @param	object		Object
	 * @param	message		String
	 * 
	 * @throws	AssertionFailureError
	 */
	public function checkNotNull( object:*, 
		message:String = "checkNotNull failed."):void
	{
		assert(object !== null, message);
	}}