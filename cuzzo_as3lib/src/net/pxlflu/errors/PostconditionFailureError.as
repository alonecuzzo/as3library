package com.atmospherebbdo.errors
{

	/**
	 * @author Mark Hawley
	 * 
	 * Error thrown on a failed postcondition.
	 */
	public class PostconditionFailureError extends AssertionFailureError
	{
		/**
		 * Constructor.
		 * 
		 * @param message 	String, optional. Defaults to "POSTCONDITION 
		 * 					FAILED"
		 * @param id uint, optional. Defaults to 0.
		 */
		public function PostconditionFailureError(
			message:String="POSTCONDITION FAILED", id:uint = 0)
		{
			super(message, id);
		}
	}
}
