package com.atmospherebbdo.errors 
{

	/**
	 * @author Mark Hawley
	 */
	public class NoSuchElementError extends Error 
	{
		/**
		 * Constructor.
		 * 
		 * @param message 	String, optional. Defaults to "NO 
		 * 					SUCH ELEMENT EXCEPTION"
		 * @param id uint, optional. Defaults to 0.
		 */
		public function  NoSuchElementError(message:String="NO SUCH ELEMENT EXCEPTION", id:uint=0)
		{
			super(message, id);
		}
	}
}
