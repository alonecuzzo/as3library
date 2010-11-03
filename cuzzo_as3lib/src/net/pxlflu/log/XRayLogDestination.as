package com.atmospherebbdo.log
{	import com.atmospherebbdo.log.LogMessageFormat;
	import com.atmospherebbdo.log.LogMessage;
	import com.atmospherebbdo.log.LogLevel;
	import com.atmospherebbdo.log.ILogDestination;
	import com.blitzagency.xray.logger.XrayLogger;	

	/**
	 * @auther mark hawley
	 * 
	 * Routes log messages to Xray. (online version here: 
	 * http://www.rockonflash.com/xray/flex/Xray.html)
	 */
	public class XRayLogDestination implements ILogDestination
	{
		private var xRayLogger:XrayLogger;
		private var minimumLevel:LogLevel;
		
		/**
		 * Constructor.
		 * 
		 * @param minimumLevel	LogLevel Optional, defaults to 
		 * 								LogLevel.TRACE
		 */
		public function XRayLogDestination( minimumLevel:LogLevel=null)
		{
			if (minimumLevel == null)
			{
				minimumLevel = LogLevel.TRACE;
			}
			this.minimumLevel = minimumLevel;

			if (xRayLogger == null)
			{
				xRayLogger = XrayLogger.getInstance();
			}
		}

		/**
		 * Stringifys log events as they arrive, then forwards the strings to the
		 * correct xRayLog methods.
		 * 
		 * @param	message	Object
		 */
		public function log( message:LogMessage  ):void 
		{
			if ( message.level < minimumLevel )
			{
				return;
			}
			
			var level:Number;
			
			switch( message.level )
			{
				case LogLevel.TRACE:
					// fall through - no TRACE in XRAY
				case LogLevel.DEBUG:
					level = XrayLogger.DEBUG;
					break;
				case LogLevel.INFO:
					level = XrayLogger.INFO;
					break;
				case LogLevel.WARN:
					level = XrayLogger.WARN;
					break;
				case LogLevel.ERROR:
					level = XrayLogger.ERROR;
					break;
				case LogLevel.FATAL:
					level = XrayLogger.FATAL;
					break;
			}
			
			// uses the short format: no time stamps		
			xRayLogger.log( message.toString(LogMessageFormat.ORIGIN_FIRST), "", "", level );
		}
	}
}