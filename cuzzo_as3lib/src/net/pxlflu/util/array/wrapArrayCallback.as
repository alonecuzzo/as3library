package com.atmospherebbdo.util.array 
{
	/**
	 * Wraps a callback destined for one of the functional Array
	 * methods so it ignores the commonly unused extra parameters.
	 * 
	 * @param	f	Function with signature f(item:*):*
	 * 
	 * @return	Function with signature 
	 * 			f(item:*, index:int, array:Array):*
	 */
	public function wrapArrayCallback( f:Function ) :Function
	{
		return ( function ( item:*, index:int, array:Array) :*
		{
			return f(item);
		});
	}}