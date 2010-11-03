package com.atmospherebbdo.errors {
	/**	 * Error to be thrown when an instance of a class should appear somewhere	 * (like a list of event listeners) but can not be found.	 */	public class InstanceNotFoundError extends Error 	{		/**		 * Constructor.		 * 		 * @param message 	String, optional. Defaults to "INSTANCE NOT FOUND"		 */
		public function InstanceNotFoundError(message:String="INSTANCE NOT FOUND") 		{
			super(message);
		}
	}
}