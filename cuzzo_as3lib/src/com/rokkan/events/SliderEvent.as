package com.rokkan.events 
{
	import flash.events.Event;

	public class SliderEvent extends Event
	{
		
		/**
		 * The <code>SliderEvent.THUMB_PRESS</code> constant defines the value of the type property of an <code>thumbPress</code> event object.
		 */
		public static const THUMB_PRESS:String = "thumbPress";
		
		/**
		 * The <code>SliderEvent.THUMB_RELEASE</code> constant defines the value of the type property of an <code>thumbRelease</code> event object.
		 */
		public static const THUMB_RELEASE:String = "thumbRelease";
		
		/**
		 * Creates an Event object that contains slider event information.
		 * @param	type	The type of the event
		 * @param	bubbles	Determines whether the Event object participates in the bubbling stage of the event flow
		 * @param	cancelable	Determines whether the Event object can be canceled.
		 */
		public function SliderEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );
		}
		
		/**
		 * Creates a copy of the SliderEvent object and sets the value of each property to match that of the original.
		 * @return	A new SliderEvent object with property values that match those of the original.
		 */
		public override function clone():Event 
		{ 
			return new SliderEvent(type, bubbles, cancelable);
		} 
		
		/**
		 * Returns a string that contains all the properties of the SliderEvent object.
		 * @return	A string that contains all the properties of the SliderEvent object.
		 */
		public override function toString():String 
		{ 
			return formatToString("SliderEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
