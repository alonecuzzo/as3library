package com.atmospherebbdo.errors 
{

	/**
	 * @author Mark Hawley
	 */
	public class IllegalStateError extends Error 
	{
		/**
		 * Constructor.
		 * 
		 * @param message 	String, optional. Defaults to "ILLEGAL 
		 * 					STATE"
		 * @param id uint, optional. Defaults to 0.
		 */
		public function  IllegalStateError(message:String="ILLEGAL STATE", id:uint=0)
		{
			super(message, id);
		}
	}
}
