package com.atmospherebbdo.errors 
{

	/**
	 * @author Mark Hawley
	 */
	public class AbstractMethodCallError extends Error 
	{
		/**
		 * Constructor.
		 * 
		 * @param message 	String, optional. Defaults to "ABSTRACT 
		 * 					METHOD CALL"
		 * @param id uint, optional. Defaults to 0.
		 */
		public function  AbstractMethodCallError(message:String="ABSTRACT METHOD CALL", id:uint=0)
		{
			super(message, id);
		}
	}
}
