package com.atmospherebbdo.log
{
	/**
	 * Log interface.
	 * 
	 * @author hawleym
	 */
	public interface ILog 
	{
		function trace( ... rest ) :void;
		function debug( ... rest ) :void;
		function info( ... rest ) :void;
		function warn( ... rest ) :void;
		function error( ... rest ) :void;
		function fatal( ... rest ) :void;
	}
}