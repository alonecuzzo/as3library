package com.rokkan.programs.characteranimator.controls 
{
	import com.rokkan.programs.characteranimator.events.ControlEvent;
	import com.rokkan.programs.characteranimator.events.HasFocus;
	import com.rokkan.programs.characteranimator.Main;
	import com.rokkan.programs.characteranimator.parts.BoxRotator;
	import com.rokkan.utils.ArrayMethods;
	import fl.containers.ScrollPane;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class TimeLine extends Sprite 
	{
		// inherent vars
		public var timeLineAdders_mc:TimeLineAdders;
		public var timeLineScrollable_mc:MovieClip;
		public var scrollPane_mc:ScrollPane;
		private var _lastTitle:MovieClip;
		private var _timeLineArr:Array;
		private var _soundLineArr:Array;
		private var _soundTitleArr:Array = new Array();
		private var _guideItemArr:Array = new Array();
		
		private var _selectedFrame:Number = 1;
		
		public function TimeLine() 
		{
			_timeLineArr = new Array();
			_soundLineArr = new Array();
		}
		
		public function init() {
			timeLineScrollable_mc.posBack_mc.addEventListener( MouseEvent.MOUSE_DOWN, handleBackSelect, false, 0, true);
			timeLineScrollable_mc.posBack_mc.width = 6400;
			timeLineScrollable_mc.pos_mc.vertLine_mc.mouseEnabled = false;
			
			for (var i:uint = 0; i < 80; i++) {
				var frame_mc:Sprite = new timeLineTopFrames_mc() as Sprite;
				timeLineScrollable_mc.addChild( frame_mc );
				frame_mc.mouseChildren = false;
				frame_mc.mouseEnabled = false;
				frame_mc.x = 80 * i;
				if (i == 0) {
					frame_mc["first_txt"].text = 1;
				}
				frame_mc["second_txt"].text = i * 10 + 5;
				frame_mc["third_txt"].text = i * 10 + 10;
			}
			timeLineAdders_mc.init();
			
			scrollPane_mc.source = timeLineScrollable_mc;
		}
		
		private function handleBackSelect( e:MouseEvent = null) {
			trace("handleBackSelect");
			var back_mc:MovieClip = timeLineScrollable_mc.posBack_mc;
			var selectedFrame:Number = Math.floor( back_mc.mouseX * back_mc.scaleX / 8 ) + 1;
			dispatchEvent( new HasFocus( HasFocus.CHANGE_FOCUS, { focus:this }, true ) );
			selectFrame( selectedFrame );
		}
		
		public function resetAnim() {
			for (var i:uint = 0; i < _timeLineArr.length; i++) {
				var timePiece:TimeLineItem = TimeLineItem( _timeLineArr[i][1] );
				timePiece.reset();
			}
			for (i = 0; i < _soundLineArr.length; i++) {
				var soundLineItem:TimeLineSoundItem = _soundLineArr[i];
				timeLineScrollable_mc.holder_mc.removeChild( soundLineItem );
			}
			_soundLineArr = new Array();
			for (i = 0; i < _guideItemArr.length; i++) {
				_guideItemArr[i].die();
				this.removeChild( _guideItemArr[i] );
			}
			_guideItemArr = new Array();
			for (i = 0; i < _soundTitleArr.length; i++) {
				var soundTitle_mc:Sprite = _soundTitleArr[i];
				this.removeChild( soundTitle_mc );
			}
			_soundTitleArr = new Array();
		}
		
		public function clear() {
			for (var i = 0; i < _timeLineArr.length; i++) {
				var box:BoxRotator = _timeLineArr[i][1].target;
				trace("removing box:" + box);
				box.die();
				box.parent.removeChild( box );
				timeLineScrollable_mc.holder_mc.removeChild( _timeLineArr[i][1] );
				this.removeChild( _timeLineArr[i][0] );
			}
			_timeLineArr = new Array();
			adjustPositions();
		}
		
		public function addItem( boxRot:BoxRotator, level:Number, belowTimeLine:TimeLineTitlePiece = null ) {
			//trace("TimeLine addItem box:" + boxRot);
			var addToPoint:Number = _timeLineArr.length - 1;
			var i:uint;
			
			if(belowTimeLine!=null){
				for (i = 0; i < _timeLineArr.length; i++) {
					if (_timeLineArr[i][0] == belowTimeLine) {
						addToPoint = i;
					}
				}
			}
			
			var title:TimeLineTitlePiece = new TimeLineTitlePiece();
			this.addChild( title );
			title.init( boxRot, level );
			
			var timePiece:TimeLineItem = new TimeLineItem();
			timeLineScrollable_mc.holder_mc.addChild( timePiece );
			
			_timeLineArr = ArrayMethods.insertElem( _timeLineArr, [title, timePiece], addToPoint );
			
			timePiece.init( boxRot );
			
			adjustPositions();
		}
		
		public function addGuideItem( src:String ) {
			trace("adding guide src:" + src);
			var guidePiece:TimeLineGuidePiece = new TimeLineGuidePiece();
			this.addChild( guidePiece );
			guidePiece.init( src );
			_guideItemArr.push( guidePiece );
			adjustPositions();
		}
		
		public function removeGuideItem( item:TimeLineGuidePiece ) {
			this.removeChild( item );
			_guideItemArr = ArrayMethods.arrayRemoveElemFind( _guideItemArr, item );
		}
		
		public function addSoundItem( src:String ) {
			var soundLineItem:TimeLineSoundItem = new TimeLineSoundItem();
			soundLineItem.init( src );
			addSoundItemObj( soundLineItem );
		}
		
		private function addSoundItemObj( soundLineItem:TimeLineSoundItem ) {
			var title:TimeLineTitleSound = new TimeLineTitleSound();
			this.addChild( title );
			title.init( soundLineItem );
			_soundTitleArr.push( title );
			
			timeLineScrollable_mc.holder_mc.addChild( soundLineItem );
			_soundLineArr.push( soundLineItem );
			adjustPositions();
		}
		
		public function removeSoundItemObj( soundTitle:TimeLineTitleSound ) {
			for (var i:uint = 0; i < _soundLineArr.length; i++) {
				var soundLine:TimeLineSoundItem = _soundLineArr[i];
				if ( soundLine == soundTitle.soundLineItem ) {
					_soundLineArr = ArrayMethods.arrayRemoveElem( _soundLineArr, i );
					timeLineScrollable_mc.holder_mc.removeChild( soundLine );
					_soundTitleArr = ArrayMethods.arrayRemoveElemFind( _soundTitleArr, soundTitle );
					this.removeChild( soundTitle );
					adjustPositions();
					break;
				}
			}
		}
		
		private function adjustPositions() {
			var lastY:Number = 0;
			for (var i:uint = 0; i < _timeLineArr.length; i++) {
				lastY += 19;
				_timeLineArr[i][0].y = lastY;
				_timeLineArr[i][1].y = lastY;
			}
			for ( i = 0; i < _guideItemArr.length; i++) {
				trace("_guideItemArr["+i+"]" + _guideItemArr[i]);
				lastY += 19;
				_guideItemArr[i].y = lastY;
			}
			for ( i = 0; i < _soundLineArr.length; i++) {
				trace("_soundLineArr i:" + i);
				lastY += 19;
				_soundLineArr[i].y = lastY;
				_soundTitleArr[i].y = lastY;
			}
			timeLineScrollable_mc.pos_mc.vertLine_mc.height = (lastY) + 3;
			resizeDisplay();
		}
		
		public function resizeDisplay() {
			scrollPane_mc.height = _timeLineArr.length * 19 + _soundLineArr.length * 19 + _guideItemArr.length * 19 + 19 + 15;
			scrollPane_mc.width = Main.stageRef.stageWidth - 150;
			timeLineAdders_mc.y = scrollPane_mc.height - timeLineAdders_mc.height + 3;
		}
		
		public function updateProperties( e:ControlEvent = null ) {
			var target = e.params.mc;
			var easingFunc = e.params.ease;
			for (var i = 0; i < _timeLineArr.length; i++) {
				if (_timeLineArr[i][1].target == target) {
					_timeLineArr[i][1].updateProperties( _selectedFrame, target, easingFunc);
				}
			}
		}
		
		public function stopSounds() {
			for ( var i:uint = 0; i < _soundLineArr.length; i++) {
				_soundLineArr[i].stopSounds();
			}
		}
		
		public function selectFrame(frame:Number, timeLineItem:TimeLineItem = null ) {
			//trace("TimeLine frame:" + frame + " timeLineItem:"+timeLineItem);
			parent["resetFocus"]();
			if(frame>0){
				_selectedFrame = frame;
				
				timeLineScrollable_mc.pos_mc.x = 8 * ( frame - 1 ) - 1;
				for (var i:uint = 0; i < _timeLineArr.length; i++) {
					if (timeLineItem != _timeLineArr[i][1]) {
						_timeLineArr[i][1].deselect();
					}
					_timeLineArr[i][1].selectFrame( frame );
				}
			}
			
			while ( timeLineScrollable_mc.pos_mc.x - scrollPane_mc.horizontalScrollPosition > stage.stageWidth - 150 ) {
				scrollPane_mc.horizontalScrollPosition += (stage.stageWidth - 150);
			}
		}
		
		public function selectFrameSounds( frame:int ) {
			for (var i:uint = 0; i < _soundLineArr.length; i++) {
				_soundLineArr[i].selectFrame( frame );
			}
		}
		
		public function get selectedFrame():Number {
			return _selectedFrame;
		}
		
		public function get totalFrames():Number {
			var largestLength:Number = 0;
			for (var i:uint = 0; i < _timeLineArr.length; i++) {
				if (_timeLineArr[i][1].totalFrames > largestLength) {
					largestLength = _timeLineArr[i][1].totalFrames;
				}
			}
			
			return largestLength;
		}
		
		public function toXML():XML {
			var xmlRep:String = "<timeLine>";
			for (var i:uint = 0; i < _timeLineArr.length; i++) {
				xmlRep += "<timeLineItem id='"+_timeLineArr[i][1].target.id+"'><![CDATA[" + _timeLineArr[i][1].serialize() + "]]></timeLineItem>";
			}
			for (i = 0; i < _soundLineArr.length; i++) {
				xmlRep += "<soundLineItem><![CDATA[" + _soundLineArr[i].serialize() + "]]></soundLineItem>";
			}
			xmlRep += "</timeLine>";
			
			var returnXML:XML = new XML(xmlRep);
			return returnXML;
		}
		
		public function fromXML( xml:XML ) {
		
			var timeLineList:XMLList = xml.timeLineItem;
			var timeLineItem:XML;
			for (var i:int = 0; i < timeLineList.length(); i++)
			{
				trace("timeLineList[i]:" + timeLineList[i] + " timeLineList[i][1]:"+timeLineList[i][1]);
				timeLineItem = timeLineList[i];
				_timeLineArr[i][1].deserialize( timeLineItem );
			}
			
			var soundLineList:XMLList = xml.soundLineItem;
			for ( i = 0; i < soundLineList.length(); i++) {
				timeLineItem = soundLineList[i];
				var soundLineItem:TimeLineSoundItem = new TimeLineSoundItem();
				soundLineItem.deserialize( timeLineItem );
				addSoundItemObj( soundLineItem );
			}

		}
	}
	
}