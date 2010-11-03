package com.rokkan.programs.characteranimator.controls 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class TimeLineSoundItem extends Sprite 
	{
		// inherent vars
		public var back_mc:MovieClip;
		
		// created vars
		private var _soundDict:Dictionary;
		private var _selectedKeyFrame:TimeLineSoundKeyFrame;
		private var _movingBox:Sprite;
		private var _lastSelectFrame:uint=1;
		
		public function TimeLineSoundItem() 
		{
			_soundDict = new Dictionary();
		}
		
		public function init( src:String ) {
			this.addKeyFrame(src, 1);
		}
		
		public function addKeyFrame( src:String, frame:uint = 1 ) {
			var soundKey:TimeLineSoundKeyFrame = new TimeLineSoundKeyFrame();
			soundKey.init( src );
			soundKey.frame = frame;
			addKeyFrameObj( soundKey );
		}
		
		private function addKeyFrameObj( soundKey:TimeLineSoundKeyFrame ) {
			this.addChild( soundKey );
			_soundDict[ soundKey.frame ] = soundKey;
		}
		
		public function selectFrame( frame:int ) {
			trace("selectFrame frame:" + frame);
			
			for (var key:Object in _soundDict) {
				if ((key > _lastSelectFrame && key <= frame ) || key == frame) { // if in between the last frame selected and the current (or equal to current frame)
					_soundDict[ key ].playSound();
				}
			}
			_lastSelectFrame = frame;
		}
		
		public function stopSounds() {
			for (var key:Object in _soundDict) {
				_soundDict[ key ].stopSound();
			}
		}
		
		public function startDraggingKey( keyFrame:TimeLineSoundKeyFrame ) {
			_selectedKeyFrame = keyFrame;
			_movingBox = new timeLineMoving_mc() as Sprite;
			_movingBox.x = this.mouseX - this.mouseX%8;
			this.addChild( _movingBox );
			this.addEventListener( Event.ENTER_FRAME, dragOnEnter, false, 0, true);
			stage.addEventListener( MouseEvent.MOUSE_UP, stopDragging, false, 0, true);
		}
		
		private function dragOnEnter( e:Event ) {
			_movingBox.x = this.mouseX - this.mouseX%8;
		}
		
		private function stopDragging( e:Event = null ) { 
			this.removeEventListener( Event.ENTER_FRAME, dragOnEnter);
			stage.removeEventListener( MouseEvent.MOUSE_UP, stopDragging);
			this.removeChild( _movingBox );
			
			delete _soundDict[ _selectedKeyFrame.frame ];
			_selectedKeyFrame.frame = this.mouseXFrame;
			_selectedKeyFrame.x = 8 * (_selectedKeyFrame.frame - 1);
			_soundDict[ _selectedKeyFrame.frame ] = _selectedKeyFrame;
			trace("new frame:" + _selectedKeyFrame.frame);
		}
		
		public function get mouseXFrame():Number {
			return Math.floor( this.mouseX / 8 ) + 1;
		}
		
		/*********************
		 * Serialize Methods
		 * *******************/
		
		public function serialize():String {
			var output:String = "";
			var keyFrame:TimeLineSoundKeyFrame;
			for (var key:Object in _soundDict) {
				key = TimeLineSoundKeyFrame( _soundDict[ key ] );
				output += key.serialize() + "|";
			}
			output = output.substr(0, output.length - 1);
			return output;
		}
		
		public function deserialize( str:String ) {
			var ptsArr:Array = str.split("|");
			var keyFrame:TimeLineSoundKeyFrame;
			for (var i:uint = 0; i <ptsArr.length; i++) {
				keyFrame = new TimeLineSoundKeyFrame();
				keyFrame.deserialize( ptsArr[i] );
				addKeyFrameObj( keyFrame );
			}
		}
	}
	
}