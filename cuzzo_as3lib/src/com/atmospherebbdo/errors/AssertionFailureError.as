package com.atmospherebbdo.errors
{

	/**
	 * @author Mark Hawley
	 * 
	 * Error thrown on a failed assertion.
	 */
	public class AssertionFailureError extends Error 
	{
		/**
		 * Constructor.
		 * 
		 * @param message 	String, optional. Defaults to "ASSERTION 
		 * 					FAILED"
		 * @param id uint, optional. Defaults to 0.
		 */
		public function AssertionFailureError(
			message:String="ASSERTION FAILED", id:uint = 0)
		{
			super(message, id);
		}
	}
}
