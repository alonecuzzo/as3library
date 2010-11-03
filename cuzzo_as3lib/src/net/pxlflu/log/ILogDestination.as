package com.atmospherebbdo.log
{
	/**
	 * The interface to an object that handles log messages.
	 * 
	 * @author hawleym
	 */
	import com.atmospherebbdo.log.LogMessage;	

	public interface ILogDestination 
	{
		function log( message:LogMessage ) :void;
	}
}