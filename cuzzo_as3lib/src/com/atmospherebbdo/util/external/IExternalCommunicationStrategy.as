package com.atmospherebbdo.util.external 
{

	/**
	 * @author Mark Hawley
	 * 
	 * Interface for wys to deal with the world outside of Flash.
	 */
	public interface IExternalCommunicationStrategy 
	{
		// first param is a method name
		function call( ...rest ):void;
		function addCallback( externalFunctionName:String, internalFunction:Function ) :void;
	}
}
