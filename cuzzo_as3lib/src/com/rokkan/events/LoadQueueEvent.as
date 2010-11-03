package com.rokkan.events 
{
	
	import com.rokkan.net.LoadQueueItem;
	import flash.events.Event

	public class LoadQueueEvent extends Event
	{
		
		/**
		 * The <code>LoadQueueEvent.QUEUE_PROGRESS</code> constant defines the value of the type property of an <code>queueProgress</code> event object.
		 */
		public static const QUEUE_PROGRESS:String = "queueProgress";
		
		/**
		 * The <code>LoadQueueEvent.ITEM_COMPLETE</code> constant defines the value of the type property of an <code>itemComplete</code> event object.
		 */
		public static const ITEM_COMPLETE:String = "itemComplete";
		
		/**
		 * The current item that is being loaded or has completed loading.
		 */
		public var item:LoadQueueItem;
		
		/**
		 * The amount of data, in bytes, that is loaded of the current item in the queue.
		 */
		public var itemBytesLoaded:uint;
		
		/**
		 * The total amount of data, in bytes, of the current item in the queue.
		 */
		public var itemBytesTotal:uint;
		
		/**
		 * The overall progress of the queue expressed as a number between 0 and 1.
		 */
		public var queuePercent:Number;
		
		/**
		 * Creates an Event object that contains load queue event information.
		 * @param	type	The type of the event
		 * @param	bubbles	Determines whether the Event object participates in the bubbling stage of the event flow
		 * @param	cancelable	Determines whether the Event object can be canceled.
		 * @param	itemBytesLoaded	The amount of bytes loaded of the current item in the queue
		 * @param	itemBytesTotal	The atotal mount of bytes of the current item in the queue
		 * @param	queuePercent	The overall progress of the queue expressed as a number between 0 and 1
		 * @param	item	The current item in the queue
		 */
		public function LoadQueueEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false, 
										itemBytesLoaded:uint = 0, 
										itemBytesTotal:uint = 0,
										queuePercent:Number = 0, 
										item:LoadQueueItem = null ) 
		{
			super( type, bubbles, cancelable );
			this.itemBytesLoaded = itemBytesLoaded;
			this.itemBytesTotal = itemBytesTotal;
			this.queuePercent = queuePercent;
			this.item = item;
		}
		
		/**
		 * Creates a copy of the LoadQueueEvent object and sets the value of each property to match that of the original.
		 * @return	A new LoadQueueEvent object with property values that match those of the original.
		 */
		public override function clone():Event 
		{ 
			return new LoadQueueEvent(type, bubbles, cancelable, itemBytesLoaded, itemBytesTotal, queuePercent, item );
		} 
		
		/**
		 * Returns a string that contains all the properties of the LoadQueueEvent object.
		 * @return	A string that contains all the properties of the LoadQueueEvent object.
		 */
		public override function toString():String 
		{ 
			return formatToString("LoadQueueEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
		
	}
	
}