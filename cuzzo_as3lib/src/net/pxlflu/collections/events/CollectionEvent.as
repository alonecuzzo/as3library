package com.atmospherebbdo.collections.events {	import flash.events.Event;	
	/**	 * @author markhawley	 * 	 * An event broadcast by a collection.	 */	public class CollectionEvent extends Event 	{		/**		 * broadcast whenever anything changes in the collection.		 */		public static const CHANGED:String = "CollectionEvent: Changed";				/**		 * broadcast whenever something is added to the collection.		 */		public static const ADD:String = "CollectionEvent: add";				/**		 * broadcast whenever something is removed from the collection.		 */		public static const REMOVE:String = "CollectionEvent: remove";				/**		 * broadcast whenever something is moved from one index to another		 * within a collection.		 */		public static const MOVE:String = "CollectionEvent: move";				/**		 * broadcast whenever an item in a collection is replaced by another		 * item.		 */		public static const REPLACE:String = "CollectionEvent: replace";				/**		 * broadcast whenver a collection undergoes a very large change,		 * probably requiring extra processing by event listeners.		 */		public static const RESET:String = "CollectionEvent: reset";				/**		 * broadcast whenever a collection undergoes a large change requiring		 * views of the collection to refresh themselves.		 */		public static const REFRESH:String = "CollectionEvent: refresh";				/**		 * broadcast whenever items in a collection are updated.		 */		public static const UPDATE:String = "CollectionEvent: update";				public var items:Array;		public var location:int = -1;		public var oldLocation:int = -1;		/**		 * Constructor.		 * 		 * @param	type	String, a constant defined in this class.		 */		public function CollectionEvent(type:String)		{			super( type, false, false );		}				/**		 * Clones a collection event.		 * 		 * @return	Event;		 */		override public function clone() :Event		{			var e:CollectionEvent = new CollectionEvent(type);			e.items = items.splice();			e.location = location;			e.oldLocation = oldLocation;			return e;		}	}}