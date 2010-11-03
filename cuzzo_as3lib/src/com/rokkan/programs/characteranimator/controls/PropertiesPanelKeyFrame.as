package com.rokkan.programs.characteranimator.controls 
{
	import com.rokkan.programs.characteranimator.events.ControlEvent;
	import com.rokkan.programs.characteranimator.parts.BoxRotator;
	import com.rokkan.tween.Extreme;
	import fl.controls.ComboBox;
	import fl.events.DataChangeEvent;
	import fl.motion.easing.Bounce;
	import fl.motion.easing.Cubic;
	import fl.motion.easing.Linear;
	import fl.motion.easing.Quadratic;
	import fl.motion.easing.Quartic;
	import fl.motion.easing.Quintic;
	import flash.display.Sprite;
	import flash.events.Event;
	import gs.TweenLite;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class PropertiesPanelKeyFrame extends Sprite 
	{
		// inherent vars
		public var tweenBox_mc:ComboBox;
		
		// created vars
		private var _target:TimeLineKeyFrame;
		private var _easeDropArr:Array = [ ["None", "Linear.easeNone"],
										["Bounce.easeIn", "Bounce.easeIn"],
										["Bounce.easeOut", "Bounce.easeOut"],
										["Bounce.easeInOut", "Bounce.easeInOut"],
										["Back.easeIn", "Back.easeIn"],
										["Back.easeOut", "Back.easeOut"],
										["Back.easeInOut", "Back.easeInOut"],
										["Cubic.easeIn", "Cubic.easeIn"],
										["Cubic.easeOut", "Cubic.easeOut"],
										["Cubic.easeInOut", "Cubic.easeInOut"],
										["Extreme.easeIn", "Extreme.easeIn"],
										["Extreme.easeOut", "Extreme.easeOut"],
										["Extreme.easeInOut", "Extreme.easeInOut"],
										["Quadratic.easeIn", "Quadratic.easeIn"], 
										["Quadratic.easeOut", "Quadratic.easeOut"], 
										["Quadratic.easeInOut", "Quadratic.easeInOut"],
										["Quartic.easeIn", "Quartic.easeIn"],
										["Quartic.easeOut", "Quartic.easeOut"],
										["Quartic.easeInOut", "Quartic.easeInOut"],
										["Quintic.easeIn", "Quintic.easeIn"],
										["Quintic.easeOut", "Quintic.easeOut"],
										["Quintic.easeInOut", "Quintic.easeInOut"]
										];
										
		
		public function PropertiesPanelKeyFrame() 
		{
			
		}
		
		public function init( target ) {
			_target = TimeLineKeyFrame( target );
			
			for (var i:uint = 0; i < _easeDropArr.length; i++) {
				tweenBox_mc.addItem( {label:_easeDropArr[i][0], data:_easeDropArr[i][1]} );
				if (_target.easingFunc != null && _target.easingFunc.indexOf( _easeDropArr[i][1] ) >= 0) {
					tweenBox_mc.selectedIndex = i;
				}
			}
			
			tweenBox_mc.addEventListener("change", changeTween, false, 0, true); 
		}
		
		public function die() {
			tweenBox_mc.removeEventListener("change", changeTween); 
		}
		
		private function changeTween( e:Event = null) {
			var itemSelected = tweenBox_mc.selectedItem;
			
			var target:BoxRotator = _target.parent["target"];
			
			dispatchEvent( new ControlEvent( ControlEvent.KEYFRAME_UPDATED, {mc:target, ease:itemSelected.data }, true) );
		}
	}
	
}