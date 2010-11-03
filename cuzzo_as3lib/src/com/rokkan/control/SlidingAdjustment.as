package com.rokkan.control
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class SlidingAdjustment extends Sprite 
	{
		
		// created vars
		private var _target;
		private var _val:String;
		private var _min:Number;
		private var _max:Number;
		private var _downX:Number;
		private var _stageRef:Stage;
		
		public function SlidingAdjustment( target:Object, val:String, min:Number = -1000, max:Number = 1000 ) 
		{
			_target = target;
			_val = val;
			_min = min;
			_max = max;
			
			var backShape:Shape = new Shape();
			backShape.graphics.beginFill(0xFFFF00, 0);
			backShape.graphics.lineTo(11, 0);
			backShape.graphics.lineTo(11, 9);
			backShape.graphics.lineTo(0, 9);
			backShape.graphics.lineTo(0, 0);
			backShape.graphics.endFill();
			this.addChild( backShape );
			
			var triangle:Shape = new Shape();
			triangle.graphics.beginFill(0x666666);
			triangle.graphics.moveTo(5, 1);
			triangle.graphics.lineTo(1, 4.5);
			triangle.graphics.lineTo(5, 8);
			triangle.graphics.endFill();
			this.addChild( triangle );
			
			triangle = new Shape();
			triangle.graphics.beginFill(0x666666);
			triangle.graphics.moveTo(6, 1);
			triangle.graphics.lineTo(10, 4.5);
			triangle.graphics.lineTo(6, 8);
			triangle.graphics.endFill();
			this.addChild( triangle );
		}
		
		public function init() {
			this.buttonMode = true;
			this.addEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown, false, 0, true);
			this.addEventListener( MouseEvent.MOUSE_UP, handleMouseUp, false, 0, true);
			
			var isParent = this.parent;
			while (isParent is Stage == false) {
				isParent = isParent.parent;
			}
			_stageRef = Stage( isParent );
		}
		
		private function handleMouseDown( e:MouseEvent = null) {
			_downX = this.mouseX;
			this.addEventListener( Event.ENTER_FRAME, onEnterAdjust, false, 0, true);
			
			this.addEventListener( MouseEvent.MOUSE_UP, handleMouseUp, false, 0, true);
			_stageRef.addEventListener( MouseEvent.MOUSE_UP, handleMouseUp, false, 0, true);
		}
		
		private function onEnterAdjust( e:Event ) {
			var diff:Number = _downX - this.mouseX;
			
			var newVal:Number = _target[ _val ] + diff;
			if (newVal > _min && newVal < _max && diff != 0 && isNaN(newVal)==false) {
				_target[ _val ] = newVal;
				dispatchEvent( new Event( Event.CHANGE ) );
			}
			
			_downX = this.mouseX;
		}
		
		private function handleMouseUp( e:MouseEvent = null) {
			trace( _target + " val:" + _target[ _val ] );
			this.removeEventListener( MouseEvent.MOUSE_UP, handleMouseUp);
			_stageRef.removeEventListener( MouseEvent.MOUSE_UP, handleMouseUp);
			this.removeEventListener( Event.ENTER_FRAME, onEnterAdjust);
		}
		
	}
	
}