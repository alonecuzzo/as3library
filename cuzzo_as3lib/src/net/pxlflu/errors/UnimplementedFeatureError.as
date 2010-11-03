package com.atmospherebbdo.errors {
	/**	 * Error to be thrown when a method that has not yet been given a working	 * implementation is erroneously called. Obviously, use of this error class	 * should be made as infrequently as possible!	 */	public class UnimplementedFeatureError extends Error 	{		/**		 * Constructor.		 * 		 * @param message 	String, optional. Defaults to "UNIMPLEMENTED FEATURE"		 */
		public function UnimplementedFeatureError(message:String="UNIMPLEMENTED FEATURE") 		{
			super(message);
		}
	}
}