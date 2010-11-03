package com.atmospherebbdo.errors
{

	/**
	 * @author Mark Hawley
	 * 
	 * Error thrown on a failed precondition.
	 */
	public class PreconditionFailureError extends AssertionFailureError
	{
		/**
		 * Constructor.
		 * 
		 * @param message 	String, optional. Defaults to "PRECONDITION 
		 * 					FAILED"
		 * @param id uint, optional. Defaults to 0.
		 */
		public function PreconditionFailureError(
			message:String="PRECONDITION FAILED", id:uint = 0)
		{
			super(message, id);
		}
	}
}
