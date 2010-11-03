package com.rokkan.programs.characteranimator.controls 
{
	import com.rokkan.programs.characteranimator.Main;
	import com.rokkan.utils.StringMethods;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class TimeLineSoundKeyFrame extends Sprite 
	{
		// inherent vars
		public var name_txt:TextField;
		public var waveHolder_mc:MovieClip;
		public var back_mc:MovieClip;
		
		// created vars
		private var _frame:uint = 1;
		private var _soundSrc:String;
		private var _soundChannel:SoundChannel;
		private var _soundShape:Shape;
		
		private var _drawSoundChannel:SoundChannel;
		private var _drawCount:Number;
		private var _drawTimer:Timer;
		private var _lastX:Number;
		private var _lastPosition:Number;
		
		private var _isSelected:Boolean = false;
		
		public function TimeLineSoundKeyFrame() 
		{
			
		}
		
		public function init( src:String ) {
			_soundSrc = src;
			var sound:Sound = new Sound();
			sound.load( new URLRequest( _soundSrc ) );
			_drawSoundChannel = sound.play(0, 0, new SoundTransform(0.01));
			_drawSoundChannel.addEventListener(Event.SOUND_COMPLETE, stopDrawAmpt, false, 0, true);
			_drawTimer = new Timer(5, 0);
			_drawTimer.addEventListener(TimerEvent.TIMER, drawAmplitude, false, 0, true);
			_drawTimer.start();
			_drawCount = 0;
			
			src = StringMethods.stripHtmlChars( src );
			name_txt.text = src.substring( src.lastIndexOf("/") + 1, src.length);
			
			this.addEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown, false, 0, true);
		}
		
		private function handleMouseDown( e:MouseEvent = null) {
			parent["startDraggingKey"]( this );
		}
		
		public function playSound() {
			trace("starting sound this:" + this);
			var sound:Sound = new Sound();
			sound.load( new URLRequest( _soundSrc ) );
			_soundChannel = sound.play(0);
		}
		
		private function drawAmplitude( e:Event = null ) {
			_drawCount += _drawTimer.delay;
			if(_soundShape==null){
				_soundShape = new Shape();
				waveHolder_mc.addChild( _soundShape );
				_soundShape.y = 8;
				_soundShape.graphics.lineStyle(1, 0x0000FF );
			}
			
			var xPos:Number = _drawSoundChannel.position / 1000 * 320;
			if (_drawSoundChannel.position == _lastPosition) {
				var add:Number = (_drawCount / 1000) * 320 * 2;
				xPos += add;
			}else {
				_drawCount = 0;
			}
			var diffX:Number = xPos - _lastX;
			var yHeight:Number = _drawSoundChannel.leftPeak * 1000;
			_soundShape.graphics.lineTo(xPos - diffX / 2, yHeight);
			_soundShape.graphics.lineTo(xPos, 5 - yHeight);
			
			_lastPosition = _drawSoundChannel.position;
			_lastX = xPos;
		}
		
		private function stopDrawAmpt( e:Event = null ) {
			_drawSoundChannel.removeEventListener(Event.SOUND_COMPLETE, stopDrawAmpt);
			_drawTimer.removeEventListener(TimerEvent.TIMER, drawAmplitude);
			_drawTimer.stop();
		}
		
		public function stopSound() {
			trace("stopping sound this:" + this);;
			this.removeEventListener( Event.ENTER_FRAME, drawAmplitude );
			if(_soundChannel!=null)
				_soundChannel.stop();
		}
		
		public function set frame( num:int ) {
			_frame = num;
			this.x = 8 * (_frame - 1);
		}
		
		public function get frame():int {
			return _frame;
		}
		
		
		/*********************
		 * Serialize Methods
		 * *******************/
		public function serialize():String {
			var output:String = "frame:" + frame;
			output += ",_soundSrc:" + _soundSrc;
			return output;
		}
		
		public function deserialize( str:String ) {
			var propArr:Array = str.split(",");
			var subPairs:String;
			var propVal:String;
			var propName:String;
			
			var indexPt:uint;
			for (var i:uint = 0; i < propArr.length; i++) {
				subPairs = propArr[i];
				indexPt = subPairs.indexOf(":");
				propName = subPairs.substring(0, indexPt);
				propVal = subPairs.substring(indexPt + 1);
				trace("propName:" + propName + " propVal:" + propVal);
				if (propName.indexOf("_soundSrc") >= 0) {
					_soundSrc = propArr[i].substring( propArr[i].indexOf(":") + 1);
				}else {
					this[propName] = Number(propVal);
				}
			}
			trace("_soundSrc:" + _soundSrc + " frame:" + frame);
			
			init( _soundSrc );
		}
	}
	
}