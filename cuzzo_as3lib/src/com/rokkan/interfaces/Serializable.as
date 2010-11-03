package com.rokkan.interfaces 
{
	
	/**
	 * ...
	 * @author Russell Savage
	 */
	public interface Serializable 
	{
		function serialize():String;
	
		function deserialize( str:String );
	}
	
}