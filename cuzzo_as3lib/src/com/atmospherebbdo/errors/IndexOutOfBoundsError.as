package com.atmospherebbdo.errors 
{

	/**
	 * @author Mark Hawley
	 */
	public class IndexOutOfBoundsError extends Error 
	{
		/**
		 * Constructor.
		 * 
		 * @param message 	String, optional. Defaults to "INDEX 
		 * 					OUT OF BOUNDS"
		 * @param id uint, optional. Defaults to 0.
		 */
		public function  IndexOutOfBoundsError(message:String="INDEX OUT OF BOUNDS", id:uint=0)
		{
			super(message, id);
		}
	}
}
