package com.rokkan.events 
{
	import flash.events.Event;

	public class VideoEvent extends Event
	{
		
		/**
		 * The <code>VideoEvent.BUFFERING</code> constant defines the value of the type property of an <code>buffering</code> event object.
		 */
		public static const BUFFERING:String = "buffering";
		
		/**
		 * The <code>VideoEvent.CUE_POINT</code> constant defines the value of the type property of an <code>cuePoint</code> event object.
		 */
		public static const CUE_POINT:String = "cuePoint";
		
		/**
		 * The <code>VideoEvent.META_DATA</code> constant defines the value of the type property of an <code>metaData</code> event object.
		 */
		public static const META_DATA:String = "metaData";
		
		/**
		 * The <code>VideoEvent.PLAYHEAD_UPDATE</code> constant defines the value of the type property of an <code>playheadUpdate</code> event object.
		 */
		public static const PLAYHEAD_UPDATE:String = "playheadUpdate";
		
		/**
		 * The <code>VideoEvent.PLAYING</code> constant defines the value of the type property of an <code>playing</code> event object.
		 */
		public static const PLAYING:String = "playing";
		
		/**
		 * The <code>VideoEvent.PAUSED</code> constant defines the value of the type property of an <code>paused</code> event object.
		 */
		public static const PAUSED:String = "paused";
		
		/**
		 * The <code>VideoEvent.REWINDING</code> constant defines the value of the type property of an <code>rewinding</code> event object.
		 */
		public static const REWINDING:String = "rewinding";
		
		/**
		 * The <code>VideoEvent.SEEKING</code> constant defines the value of the type property of an <code>seeking</code> event object.
		 */
		public static const SEEKING:String = "seeking";
		
		public static const VIDEO_FINISHED:String = "videoFinished";
		
		/**
		 * Creates an Event object that contains video event information.
		 * @param	type	The type of the event
		 * @param	bubbles	Determines whether the Event object participates in the bubbling stage of the event flow
		 * @param	cancelable	Determines whether the Event object can be canceled.
		 */
		public function VideoEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );
		}
		
		/**
		 * Creates a copy of the VideoEvent object and sets the value of each property to match that of the original.
		 * @return	A new VideoEvent object with property values that match those of the original.
		 */
		public override function clone():Event 
		{ 
			return new VideoEvent(type, bubbles, cancelable );
		} 
		
		/**
		 * Returns a string that contains all the properties of the VideoEvent object.
		 * @return	A string that contains all the properties of the VideoEvent object.
		 */
		public override function toString():String 
		{ 
			return formatToString("VideoEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
