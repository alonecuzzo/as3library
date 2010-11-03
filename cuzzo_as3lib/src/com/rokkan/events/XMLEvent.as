package com.rokkan.events 
{
	
	import flash.events.Event;
	
	public class XMLEvent extends Event
	{
		
		/**
		 * The <code>XMLEvent.XML_PARSED</code> constant defines the value of the type property of an <code>xmlParsed</code> event object.
		 */
		public static var XML_PARSED:String = "xmlParsed";
		
		/**
		 * Creates an Event object that contains video event information.
		 * @param	type	The type of the event
		 * @param	bubbles	Determines whether the Event object participates in the bubbling stage of the event flow
		 * @param	cancelable	Determines whether the Event object can be canceled.
		 */
		public function XMLEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );
		}
		
		/**
		 * Creates a copy of the XMLEvent object and sets the value of each property to match that of the original.
		 * @return	A new XMLEvent object with property values that match those of the original.
		 */
		override public function clone():Event 
		{ 
			return new XMLEvent(type, bubbles, cancelable);
		} 
		
		/**
		 * Returns a string that contains all the properties of the XMLEvent object.
		 * @return	A string that contains all the properties of the XMLEvent object.
		 */
		override public function toString():String 
		{ 
			return formatToString("XMLEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}