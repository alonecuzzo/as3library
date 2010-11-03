package com.rokkan.events 
{
	
	import flash.events.Event;
	
	public class TransitionEvent extends Event 
	{
		
		/**
		 * The <code>TransitionEvent.INTRO_COMPLETE</code> constant defines the value of the type property of an <code>introComplete</code> event object.
		 */
		public static var INTRO_COMPLETE:String = "introComplete";
		
		/**
		 * The <code>TransitionEvent.OUTRO_COMPLETE</code> constant defines the value of the type property of an <code>outroComplete</code> event object.
		 */
		public static var OUTRO_COMPLETE:String = "outroComplete";
		
		/**
		 * The <code>TransitionEvent.INTRO_START</code> constant defines the value of the type property of an <code>introStart</code> event object.
		 */
		public static var INTRO_START:String = "introStart";
		
		/**
		 * The <code>TransitionEvent.OUTRO_START</code> constant defines the value of the type property of an <code>outroStart</code> event object.
		 */
		public static var OUTRO_START:String = "outroStart";
		
		/**
		 * Creates an Event object that contains transition event information.
		 * @param	type	The type of the event
		 * @param	bubbles	Determines whether the Event object participates in the bubbling stage of the event flow
		 * @param	cancelable	Determines whether the Event object can be canceled.
		 */
		public function TransitionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Creates a copy of the TransitionEvent object and sets the value of each property to match that of the original.
		 * @return	A new TransitionEvent object with property values that match those of the original.
		 */
		public override function clone():Event 
		{ 
			return new TransitionEvent(type, bubbles, cancelable);
		} 
		
		/**
		 * Returns a string that contains all the properties of the TransitionEvent object.
		 * @return	A string that contains all the properties of the TransitionEvent object.
		 */
		public override function toString():String 
		{ 
			return formatToString("TransitionEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}