package com.atmospherebbdo.util.email 
{	import flash.events.Event;	
	/**	 * @author markhawley	 */	public class EmailEvent extends Event 
	{
		public static const SUCCESS:String = "emailSuccess";
		public static const FAILURE:String = "emailFailure";
		
		public var toEmail:String;
		public var fromEmail:String;
		
		/**
		 * Constructor.
		 * 
		 * @param	type	String
		 * @param	toEmail	String
		 * @param 	fromEmail String
		 */		public function EmailEvent(type:String, toEmail:String=null, 
			fromEmail:String=null)
		{			super(type, false, false);
			
			this.toEmail = toEmail;
			this.fromEmail = fromEmail;		}
		
		/**
		 * Clones the event.
		 * 
		 * @return	Event (an EmailEvent)
		 */
		override public function clone() :Event
		{
			var c:EmailEvent = new EmailEvent( type, toEmail, fromEmail );
			return c;
		}
	}}