package com.atmospherebbdo.errors {
	/**	 * Error to be thrown when a class is referenced (by name) but no	 * such class has been compiled into the application.	 */	public class ClassNotFoundError extends Error 	{		/**		 * Constructor.		 * 		 * @param message 	String, optional. Defaults to "CLASS NOT FOUND"		 */
		public function ClassNotFoundError(message:String="CLASS NOT FOUND") 		{
			super(message);
		}	
	}
}