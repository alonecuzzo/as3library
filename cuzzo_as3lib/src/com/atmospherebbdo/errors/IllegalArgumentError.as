package com.atmospherebbdo.errors 
{

	/**
	 * @author Mark Hawley
	 * 
	 * Error thrown on an illegal argument.
	 */
	public class IllegalArgumentError extends Error 
	{
		/**
		 * Constructor.
		 * 
		 * @param message String, optional. Defaults to 
		 * 				   "ILLEGAL ARGUMENT"
		 * @param id uint, optional. Defaults to 0.
		 */
		public function IllegalArgumentError(message:String = "ILLEGAL ARGUMENT", id:uint = 0)
		{
			super(message, id);
		}
	}
}
