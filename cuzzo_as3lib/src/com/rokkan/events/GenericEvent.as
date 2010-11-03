package com.rokkan.events 
{
	
	import flash.events.Event;
	
	public class GenericEvent extends Event 
	{
		
		/**
		 * The <code>GenericEvent.ENTER</code> constant defines the value of the type property of an <code>enter</code> event object.
		 */
		public static const ENTER:String = "enter";
		
		/**
		 * Creates an Event object that contains generic event information.
		 * @param	type	The type of the event
		 * @param	bubbles	Determines whether the Event object participates in the bubbling stage of the event flow
		 * @param	cancelable	Determines whether the Event object can be canceled.
		 */
		public function GenericEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		/**
		 * Creates a copy of the GenericEvent object and sets the value of each property to match that of the original.
		 * @return	A new GenericEvent object with property values that match those of the original.
		 */
		public override function clone():Event 
		{ 
			return new GenericEvent( type, bubbles, cancelable );
		} 
		
		/**
		 * Returns a string that contains all the properties of the GenericEvent object.
		 * @return	A string that contains all the properties of the GenericEvent object.
		 */
		public override function toString():String 
		{ 
			return formatToString( "GenericEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}