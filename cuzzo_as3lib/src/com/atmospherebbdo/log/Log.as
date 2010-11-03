package com.atmospherebbdo.log 
{
	import com.atmospherebbdo.log.ILog;
	import com.atmospherebbdo.log.LogLevel;
	import com.atmospherebbdo.log.LogMessage;
	import com.atmospherebbdo.util.string.sprintf;
	import com.atmospherebbdo.util.array.wrapArrayCallback;	

	/**
	 * @author Mark Hawley
	 * 
	 * It logs!
	 */
	public class Log implements ILog
	{
		
		private var name:String = null;
		private var filter:LogLevel = null;
		private var destinations:Array = null;
		
		/**
		 * Constructor.
		 * 
		 * @param	name			The name of this Log.
		 * @param	logLevel		LogLevel this Log functions at.
		 */
		public function Log( name:String, logLevel:LogLevel )
		{
			if (name != null)
			{
				this.name = name;
			}
			if (logLevel == null)
			{
				filter = LogLevel.INFO;
			}
			else
			{
				filter = logLevel;
			}
		}
		
		/**
		 * Finest level of logging.
		 * 
		 * @param	message	Object
		 */
		public function trace( ... rest ) :void
		{
			logMessage( rest, LogLevel.TRACE );
		}
		
		/**
		 * Level of logging suitable for testing.
		 * 
		 * @param	message	Object
		 */
		public function debug( ... rest ) :void
		{
			logMessage( rest, LogLevel.DEBUG );
		}
		
		/**
		 * Most-used level of logging.
		 * 
		 * @param	message	Object
		 */
		public function info( ... rest ) :void
		{
			logMessage( rest, LogLevel.INFO );
		}
		
		/**
		 * Level of logging used for errors that are recoverable or not
		 * that bad in the first place.
		 * 
		 * @param	message	Object
		 */
		public function warn( ... rest) :void
		{
			logMessage( rest, LogLevel.WARN );
		}
		
		/**
		 * Level of logging used when a true error is encountered.
		 * 
		 * @param	message	Object
		 */
		public function error( ... rest ) :void
		{
			logMessage( rest, LogLevel.ERROR );
		}
		
		/**
		 * Level of logging used when disaster befalls us.
		 * 
		 * @param	message	Object
		 */
		public function fatal( ... rest ) :void
		{
			logMessage( rest, LogLevel.FATAL );
		}
		
		/**
		 * Sets the level below which messages should be ignored.
		 * 
		 * @param	level	LogLevel
		 */
		public function setLevel( level:LogLevel ) :void
		{
			filter = level;
		}
		
		/**
		 * Override the LogFactory's destinations with ones specific to this
		 * Log instance.
		 * 
		 * @param	...rest	a number of ILogDestinations.
		 */
		public function setDestinations( ...rest ) :void
		{
			destinations = rest;
		}
		
		/**
		 * Logs a message to each destination this Log has been given.
		 * 
		 * @param	message Object
		 * @param	level	LogLevel
		 */
		private function logMessage( args:Array, level:LogLevel ) :void
		{
			if ( level < filter )
			{
				return;
			}
			
//			TODO: think through further support for stack traces: do we really
//			want to throw an error for each log statement?
//			
//			var message:LogMessage = new LogMessage();
//			message.time = new Date();
//			message.level = level;
//			message.message = format.apply( null, args );
//			message.origin = name;
//			message.stackTrace = "";
//			var error:Error = new Error();
//			if( error.getStackTrace().length > 0 )
//			{
//				var str:String = err.getStackTrace();
//				var t:Array = str.split("/n");
//				t = t[3].split("\tat ");
//				str = t[1].split("]").join("");
//
//				message.stackTrace = str;
//			}
			
			var message:LogMessage = new LogMessage();
			message.time = new Date();
			message.level = level;
			message.message = sprintf.apply( null, args );
			message.origin = name;
			
			if (destinations == null)
			{
				destinations = LogFactory.destinations;
			}
			
			destinations.map( wrapArrayCallback(function (d:ILogDestination) :void
			{
				d.log(message);
			}));
		}
	}
}
