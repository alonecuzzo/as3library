package com.atmospherebbdo.util 
{
	import flash.net.LocalConnection;	
	
	/**
	 * Forces the garbage collector to run.
	 */
	public function forceGarbageCollection() :void
	{
		try 
		{
			new LocalConnection().connect('foo');
			new LocalConnection().connect('foo');
		} 
		catch (e:*) 
		{
			// do nothing
		}
	}
}
