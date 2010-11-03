package com.rokkan.programs.characteranimator.events 
{
	import flash.events.Event;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class HasFocus extends Event 
	{
		public static const CHANGE_FOCUS:String = "changeFocus";
		
		// created vars
		public var params:Object;
		
		public function HasFocus(type:String, params:Object = null, bubbles:Boolean=false, cancelable:Boolean=false) 
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
			return new HasFocus(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("HasFocus", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}