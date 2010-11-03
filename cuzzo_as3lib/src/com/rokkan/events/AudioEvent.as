package com.rokkan.events 
{
	import flash.events.Event;

	public class AudioEvent extends Event
	{
		
		/**
		 * The <code>AudioEvent.BUFFERING</code> constant defines the value of the type property of an <code>buffering</code> event object.
		 */
		public static const BUFFERING:String = "buffering";
		
		/**
		 * The <code>AudioEvent.CUE_POINT</code> constant defines the value of the type property of an <code>cuePoint</code> event object.
		 */
		public static const CUE_POINT:String = "cuePoint";
		
		/**
		 * The <code>AudioEvent.PLAYHEAD_UPDATE</code> constant defines the value of the type property of an <code>playheadUpdate</code> event object.
		 */
		public static const PLAYHEAD_UPDATE:String = "playheadUpdate";
		
		/**
		 * The <code>AudioEvent.PLAYING</code> constant defines the value of the type property of an <code>playing</code> event object.
		 */
		public static const PLAYING:String = "playing";
		
		/**
		 * The <code>AudioEvent.PAUSED</code> constant defines the value of the type property of an <code>paused</code> event object.
		 */
		public static const PAUSED:String = "paused";
		
		/**
		 * The <code>AudioEvent.REWINDING</code> constant defines the value of the type property of an <code>rewinding</code> event object.
		 */
		public static const REWINDING:String = "rewinding";
		
		/**
		 * The <code>AudioEvent.SEEKING</code> constant defines the value of the type property of an <code>seeking</code> event object.
		 */
		public static const SEEKING:String = "seeking";
		
		/**
		 * The <code>AudioEvent.SEEKING</code> constant defines the value of the type property of an <code>id3</code> event object.
		 */
		public static const ID3:String = "id3";
		
		/**
		 * Creates an Event object that contains Audio event information.
		 * @param	type	The type of the event
		 * @param	bubbles	Determines whether the Event object participates in the bubbling stage of the event flow
		 * @param	cancelable	Determines whether the Event object can be canceled.
		 */
		public function AudioEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );
		}
		
		/**
		 * Creates a copy of the AudioEvent object and sets the value of each property to match that of the original.
		 * @return	A new AudioEvent object with property values that match those of the original.
		 */
		public override function clone():Event 
		{ 
			return new AudioEvent(type, bubbles, cancelable );
		} 
		
		/**
		 * Returns a string that contains all the properties of the AudioEvent object.
		 * @return	A string that contains all the properties of the AudioEvent object.
		 */
		public override function toString():String 
		{ 
			return formatToString("AudioEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
