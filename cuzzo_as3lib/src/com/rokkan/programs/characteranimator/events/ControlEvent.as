package com.rokkan.programs.characteranimator.events 
{
	import flash.events.Event;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class ControlEvent extends Event 
	{
		public static const PART_SELECTED:String = "partSelected";
		public static const KEYFRAME_SELECTED:String = "keyFrameSelected";
		public static const KEYFRAME_UPDATED:String = "keyFrameUpdated";
		
		// created vars
		public var params:Object;
		
		public function ControlEvent(type:String, params:Object, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			if (params == null) {
				this.params = {};
			}else {
				this.params = params;
			}
			
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ControlEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ControlEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}