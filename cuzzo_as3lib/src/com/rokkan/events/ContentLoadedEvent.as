package com.rokkan.events{
	
	import flash.events.Event;

	/**
	 * ContentLoadedEvent Class / Tarantino Framework
	 * @author Faisal Ramadan
	 * @version 0.5
	 */
	
	public class ContentLoadedEvent extends Event {
		
		public static var CONTENT_READ_COMPLETED:String = "content_read_completed";
	    public var content:XML;
		
		public function ContentLoadedEvent(type:String, content:XML) {
			super(type);
            this.content = content;
		};
		
		public override function clone():Event {
			return new ContentLoadedEvent( type, content);
		};
	};
};