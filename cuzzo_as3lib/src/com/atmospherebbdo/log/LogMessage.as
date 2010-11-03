package com.atmospherebbdo.log
{
	import com.atmospherebbdo.log.LogLevel;
	import com.atmospherebbdo.util.string.sprintf;	
	
	/**
	 * @author Mark Hawley
	 * 
	 * A message for logging.
	 */
	public class LogMessage 
	{
		/** time message was created **/
		public var time:Date;
		/** log priority **/
		public var level:LogLevel;
		/** text message of log **/
		public var message:String;
		/** object that emitted the log message **/
		public var origin:String;
		
		/**
		 * Simple string dump.
		 * 
		 * @return	String
		 */
		public function toString( messageFormat:LogMessageFormat=null ) :String
		{
			if (messageFormat == null)
			{
				messageFormat = LogMessageFormat.DEFAULT;
			}
			return sprintf( messageFormat.toString(), this );
		}
	}
}
