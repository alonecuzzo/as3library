package com.rokkan.events {
	import flash.events.Event;
	
	/**
	* ...
	* @author $(DefaultUser)
	*/
	public class AnimEvent extends Event {
		
		
		public var params:Object;
		
		public function AnimEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, params:Object = null) { 
			if (params == null){
				this.params = { };
			}else {
				this.params = params;
			}
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event { 
			return new AnimEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("GeneralEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}