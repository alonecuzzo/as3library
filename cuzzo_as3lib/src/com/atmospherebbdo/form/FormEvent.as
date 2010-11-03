package com.atmospherebbdo.form 
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLVariables;		

	/**
	 * @author Mark Hawley
	 */
	public class FormEvent extends Event 
	{
		public static var VALIDATION_FAILURE:String = "form invalid";
		public static var VALIDATION_SUCCESS:String = "form valid";
		public static var SUBMISSION_SUCCESS:String = "form submitted";
		public static var SUBMISSION_FAILURE:String = "form failure";
		
		public static var IO_ERROR:String = "form io error";
		public static var SECURITY_ERROR:String = "form security error";
		
		public var sent:URLVariables;
		public var received:URLVariables;
		public var action:URLRequest;
		public var status:String;
		
		public function FormEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
