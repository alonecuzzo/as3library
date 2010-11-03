package com.atmospherebbdo.form 
{
	import com.atmospherebbdo.assertions.assert;
	import com.atmospherebbdo.assertions.checkArgument;
	import com.atmospherebbdo.form.field.IFormField;
	import com.atmospherebbdo.util.array.wrapArrayCallback;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;	
	[Event(name="form invalid", type="com.atmospherebbdo.form.FormEvent")]
	[Event(name="form valid", type="com.atmospherebbdo.form.FormEvent")]
	[Event(name="form submitted", type="com.atmospherebbdo.form.FormEvent")]
	[Event(name="form failure", type="com.atmospherebbdo.form.FormEvent")]
	[Event(name="form io error", type="com.atmospherebbdo.form.FormEvent")]
	[Event(name="form security error", type="com.atmospherebbdo.form.FormEvent")]
	
	/**
	 * @author Mark Hawley
	 * 
	 * The equivalent of an HTML form.
	 */
	public class Form implements IEventDispatcher
	{
		private var dispatcher:EventDispatcher;
		
		private var action:URLRequest;
		private var loader:URLLoader;

		public function Form( actionURL:String, method:String="GET" )
		{
			// should be true unless Flex gets an unexpected overhaul
			assert("GET" == URLRequestMethod.GET);
			
			dispatcher = new EventDispatcher();
			
			action = new URLRequest(actionURL);
			action.method = method;
			
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onSubmissionComplete);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.addEventListener(ProgressEvent.PROGRESS, onSubmissionProgress);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.addEventListener(Event.OPEN, onSubmissionStart);
		}

		public function submit( ...fields ) :void
		{
			var isFormField:Function = function (item:*) :Boolean { return item is IFormField; };
			checkArgument(fields.every( wrapArrayCallback( isFormField )),
				"Can only submit IFormField objects.");
				
			// collect the field values in the URLRequest
			var variables:URLVariables = new URLVariables();
			var populate:Function = function (item:IFormField) :void 
			{ 
				variables[item.getName()] = item.getValue(); 
			};
			fields.forEach(wrapArrayCallback(populate), this);
			
			action.data = variables;
			
			var loader:URLLoader = new URLLoader();
			loader.load(action);
		}
		
		protected function onSubmissionComplete(event:Event) :void
		{
			var fe:FormEvent = new FormEvent( FormEvent.SUBMISSION_SUCCESS );
			fe.action = action;
			fe.received = URLLoader(event.target).data;
			fe.sent = URLVariables(action.data);
			fe.status = FormEvent.SUBMISSION_SUCCESS;
			
			dispatchEvent(fe);
		}
		
		protected function onHTTPStatus(event:HTTPStatusEvent) :void
		{
			dispatchEvent(event);
		}
		
		protected function onIOError(event:IOErrorEvent) :void
		{
			var fe:FormEvent = new FormEvent( FormEvent.SUBMISSION_FAILURE);
			fe.action = action;
			fe.received = URLLoader(event.target).data;
			fe.sent = URLVariables(action.data);
			fe.status = FormEvent.IO_ERROR;
			
			dispatchEvent(fe);
		}

		protected function onSubmissionProgress(event:ProgressEvent) :void
		{
			dispatchEvent(event);
		}
		
		protected function onSecurityError(event:SecurityErrorEvent) :void
		{
			var fe:FormEvent = new FormEvent( FormEvent.SUBMISSION_FAILURE);
			fe.action = action;
			fe.received = URLLoader(event.target).data;
			fe.sent = URLVariables(action.data);
			fe.status = FormEvent.SECURITY_ERROR;
			
			dispatchEvent(fe);
		}
		
		protected function onSubmissionStart(event:Event) :void
		{
			dispatchEvent(event);
		}
	
		public function addEventListener( type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false) :void
		{
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener( type:String, listener:Function, useCapture:Boolean=false) :void
		{
			dispatcher.removeEventListener(type, listener, useCapture);
		}

		public function willTrigger( type:String ) :Boolean
		{
			return dispatcher.willTrigger(type);
		}
		
		public function hasEventListener( type:String ) :Boolean
		{
			return dispatcher.hasEventListener(type);
		}
		
		public function dispatchEvent( event:Event ) :Boolean
		{
			return dispatcher.dispatchEvent( event );
		}
	}
}
