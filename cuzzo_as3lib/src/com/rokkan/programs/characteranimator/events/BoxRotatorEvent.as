package com.rokkan.programs.characteranimator.events 
{
	import flash.events.Event;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class BoxRotatorEvent extends Event 
	{
		public static const LOADED_TEXTUREANDPART:String = "loadedTextureAndPart";
		public static const LOADED_BASEMODEL:String = "loadedBaseModel";
		
		// created vars
		public var params:Object;
		
		public function BoxRotatorEvent(type:String, params:Object = null, bubbles:Boolean=false, cancelable:Boolean=false) 
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
			return new BoxRotatorEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("BoxRotatorEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}