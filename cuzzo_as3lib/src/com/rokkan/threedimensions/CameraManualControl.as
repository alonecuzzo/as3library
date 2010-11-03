package com.rokkan.threedimensions 
{
	import away3d.cameras.HoverCamera3D;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	/**
	* Used to add keyboard control over the 3d stage easily, uses keys WASD and the arrow keys as well as optionally the mouse.
	* @author Russell Savage
	*/
	public class CameraManualControl 
	{
		
		// created vars
		private var _hoverCamera:HoverCamera3D;
		public var key83:Boolean, key87:Boolean, key65:Boolean, key68:Boolean, keyUp:Boolean, keyDown:Boolean, keyEnter:Boolean = false;
		public var keyZero:Boolean, keyOne:Boolean, keyTwo:Boolean, keyThree:Boolean = false;
		public var keyComma:Boolean, keyPeriod:Boolean, keyCtrl:Boolean = false;
		private var _stage:Stage;
		
		/**
		 * Used to add keyboard control over the 3d stage easily, uses keys WASD and the arrow keys as well as optionally the mouse.
		 * @param	hoverCam	HoverCamera3D Camera
		 * @param	stage	referance to the stage object
		 * @param	useMouseWheel	whether or not the mousewheel is activated
		 * @return
		 */
		public function CameraManualControl( hoverCam:HoverCamera3D, stage:Stage, useMouseWheel:Boolean = false ) 
		{
			initHover( hoverCam, stage, useMouseWheel );
		}
		
		public function initHover( hoverCam:HoverCamera3D, stage:Stage, useMouseWheel:Boolean = false ) {
			_hoverCamera = hoverCam;
			_stage = stage;
			
			_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			_stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			if(useMouseWheel)
				_stage.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
		}
		
		private function handleMouseWheel( e:MouseEvent ) {
			_hoverCamera.distance -= e.delta * 35;
		}
		
		private function handleKeyDown(e:KeyboardEvent):void
		{
			trace("e.keyCode:" + e.keyCode);
			keyCtrl = e.ctrlKey;
			switch(e.keyCode){
				case 83				: key83 = true; break; // Key W
				case 87				: key87 = true; break; // Key S
				case 65				: key65 = true; break; // Key A
				case 68				: key68 = true; break; // Key D
				case 48				: keyZero = true;
				case 96				: keyZero = true; break;
				case 49				: keyOne = true;
				case 97				: keyOne = true; break;
				case 50				: keyTwo = true;
				case 98				: keyTwo = true; break;
				case 51				: keyThree = true;
				case 99				: keyThree = true; break;
				case 188			: keyComma = true; break; 
				case 190			: keyPeriod = true; break;
				case Keyboard.UP	: keyUp = true; break;
				case Keyboard.DOWN	: keyDown = true; break;
				case Keyboard.ENTER : keyEnter = true; break;
			}
		}
		
		private function handleKeyUp(e:KeyboardEvent):void
		{
			keyCtrl = e.ctrlKey;
			switch(e.keyCode){
				case 83				: key83 = false; break;
				case 87				: key87 = false; break;
				case 65				: key65 = false; break; 
				case 68				: key68 = false; break;
				case 48				: keyZero = false;
				case 96				: keyZero = false; break;
				case 49				: keyOne = false;
				case 97				: keyOne = false; break;
				case 50				: keyTwo = false;
				case 98				: keyTwo = false; break;
				case 51				: keyThree = false;
				case 99				: keyThree = false; break;
				case 188			: keyComma = false; break; 
				case 190			: keyPeriod = false; break; 
				case Keyboard.UP	: keyUp = false; break;
				case Keyboard.DOWN	: keyDown = false; break;
				case Keyboard.ENTER : keyEnter = false; break;
			}
		}
		
		private function onEnterFrame( e:Event = null ) {
			// Debug helpers
			if(keyCtrl==false){
				if (key83) {
					_hoverCamera.targettiltangle -= 10;
				}else if (key87) {
					_hoverCamera.targettiltangle += 10;
				}
				if (key65) {
					_hoverCamera.targetpanangle -= 10;
				}else if (key68) {
					_hoverCamera.targetpanangle += 10
				}
				if (keyUp) {
					_hoverCamera.distance -= 10;
				}else if ( keyDown ) {
					_hoverCamera.distance += 10;
				}
			}
		}
		
	}
	
}