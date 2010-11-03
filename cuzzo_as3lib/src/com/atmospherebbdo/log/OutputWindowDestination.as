package com.atmospherebbdo.log
{
	import com.atmospherebbdo.log.LogLevel;
	import com.atmospherebbdo.log.ILogDestination;
	import com.atmospherebbdo.log.LogMessage;		

	/**
	 * Simple LogDestination that sends messages to the Output window. The
	 * XRayLogDestination does the same thing, in addition to logging to the
	 * XRay connector, so it's generally the one to use.
	 * 
	 * @author hawleym
	 */
	public class OutputWindowDestination implements ILogDestination
	{	
		private var minLevel:LogLevel = LogLevel.INFO;
		
		/**
		 * Constructor.
		 * 
		 * @param	minimumLevel	LogLevel, the lowest level this
		 * 							destination will display. Defaults to
		 * 							LogLevel.INFO.
		 */
		public function OutputWindowDestination( minimumLevel:LogLevel=null ) 
		{	
			if (minimumLevel != null)
			{
				minLevel = minimumLevel;
			}
		}

		/**
		 * Simplest log method, calling trace().
		 * 
		 * @param	message	LogMessage
		 */
		public function log( message:LogMessage ) :void
		{
			if (message.level >= minLevel)
			{
				trace( message );
			}
		}
	}
}