package com.rokkan.programs.characteranimator.controls 
{
	import com.rokkan.programs.characteranimator.events.ControlEvent;
	import com.rokkan.programs.characteranimator.parts.BoxRotator;
	import com.rokkan.tween.Extreme;
	import fl.motion.easing.Back;
	import fl.motion.easing.Bounce;
	import fl.motion.easing.Cubic;
	import fl.motion.easing.Linear;
	import fl.motion.easing.Quadratic;
	import fl.motion.easing.Quartic;
	import fl.motion.easing.Quintic;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import com.rokkan.programs.characteranimator.events.HasFocus;
	import flash.utils.Dictionary;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class TimeLineItem extends Sprite 
	{
		// inherent vars
		public var back_mc:MovieClip;
		
		private var _keyFrameGroup:Dictionary;
		private var _selectedKeyFrame:TimeLineKeyFrame;
		private var _target:BoxRotator;
		private var _timeLineRef:TimeLine;
		private var _totalFrames:Number = 1;
		private var _selectedBox:Sprite;
		private var _movingBox:Sprite;
		
		public function TimeLineItem() 
		{
			_keyFrameGroup = new Dictionary();
		}
		
		public function init( boxRot:BoxRotator ) {
			_target = boxRot;
			_timeLineRef = TimeLine( parent.parent.parent.parent.parent );
			
			var rightClickMenu:ContextMenu = new ContextMenu();
			rightClickMenu.hideBuiltInItems();
			
			back_mc.addEventListener( MouseEvent.MOUSE_DOWN, handleBackSelect, false, 0, true);
			
			var insertKey:ContextMenuItem = new ContextMenuItem("Insert Key Frame");
			insertKey.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, insertKeyFrame, false, 0, true );
			
			rightClickMenu.customItems.push( insertKey );
			this.contextMenu = rightClickMenu;
			
			this.addKeyFrame( 1 );
			TimeLineKeyFrame.copyProperties(boxRot, _keyFrameGroup[ 1 ].properties);
			back_mc.width = 80*80;
			
			for (var i:uint = 0; i < 80; i++) {
				var select_mc:Sprite = new timeLineFramesSet_mc() as Sprite;
				select_mc.x = i * 80;
				select_mc.mouseEnabled = false;
				this.addChild( select_mc );
			}
			
			_selectedBox = new timeLineSelectBox_mc() as Sprite;
			_selectedBox.visible = false;
			this.addChild( _selectedBox );
		}
		
		public function reset() {
			for (var key:Object in _keyFrameGroup) {
				if (_keyFrameGroup[ key ] != null && key!=1) {
					this.removeChild( _keyFrameGroup[ key ] );
					delete _keyFrameGroup[ key ];
				}
			}
			
			_totalFrames = 1;
		}
		
		public function keyFrameSelected() {
			_selectedBox.visible = false;
		}
		
		private function handleBackSelect( e:MouseEvent = null) {
			var selectFrame:Number = Math.floor( this.mouseX / 8 ) + 1;
			dispatchEvent( new HasFocus( HasFocus.CHANGE_FOCUS, { focus:_timeLineRef }, true ) );
			_timeLineRef.selectFrame( selectFrame );
			_selectedBox.x = (selectFrame-1) * 8;
			_selectedBox.visible = true;
		}
		
		public function updateProperties(frame:Number, target:BoxRotator, easingFunc:String = null) {
			if (_keyFrameGroup[ frame ] == null) {
				this.addKeyFrame( frame );
			}
			_keyFrameGroup[ frame ].updateProperties( target, easingFunc );
		}
		
		private function insertKeyFrame( e:ContextMenuEvent = null ) {
			var newFrame:Number = Math.floor( this.mouseX / 8 ) + 1;
			addKeyFrame( newFrame );
			if(_selectedKeyFrame!=null)
				_selectedKeyFrame.deSelect();
			
			if (newFrame >= _totalFrames) {
				_totalFrames = newFrame;
			}
			dispatchEvent( new HasFocus( HasFocus.CHANGE_FOCUS, { focus:_timeLineRef }, true ) );
			_timeLineRef.selectFrame( newFrame, this );
		}
		
		public function deselect() {
			if(_selectedKeyFrame!=null)
				_selectedKeyFrame.deSelect();
			_selectedBox.visible = false;
		}
		
		public function addKeyFrame( frame:Number = 1 ) {
			var keyFrame:TimeLineKeyFrame = new TimeLineKeyFrame( frame );
			
			if(frame>1){
				var lastKeyFrame:TimeLineKeyFrame = getLastValidKeyframe( frame );
				TimeLineKeyFrame.copyProperties(lastKeyFrame.properties, keyFrame.properties);
			}
			addKeyFrameObj( keyFrame );
			
			//keyFrame.select();
			//parent.parent.parent.parent["selectFrame"]( keyFrame.frame, this );
			//dispatchEvent( new ControlEvent( ControlEvent.KEYFRAME_SELECTED, { mc:keyFrame }, true) );
		}
		
		private function addKeyFrameObj( keyFrame:TimeLineKeyFrame ) {
			this.addChild( keyFrame );
			keyFrame.init();
			keyFrame.x = 8 * (keyFrame.frame - 1);
			_keyFrameGroup[ keyFrame.frame ] = keyFrame;
			if (keyFrame.frame >= _totalFrames) {
				_totalFrames = keyFrame.frame;
			}
		}
		
		public function clearKeyFrame( keyFrame:TimeLineKeyFrame ) {
			if( keyFrame.frame >= 1){
				if (_totalFrames == keyFrame.frame) { // this was the highest frame, recalculate the new highest frame
					var searchTo:Number = _totalFrames - 1;
					for (var i:uint = 1; i <= searchTo; i++) {
						if (_keyFrameGroup[ i ] != null) {
							_totalFrames = _keyFrameGroup[ i ].frame;
						}
					}
				}
				
				delete _keyFrameGroup[ keyFrame.frame ];
				this.removeChild( keyFrame );
			}
		}
		
		public function selectFrame( frame:Number ) {
			var lastKeyFrame:TimeLineKeyFrame = getLastValidKeyframe( frame );
			var nextKeyFrame:TimeLineKeyFrame = getNextValidKeyframe( frame );
			var lastKeyFrameFrame:uint = lastKeyFrame == null ? 1 : lastKeyFrame.frame;
			if(lastKeyFrameFrame == frame || nextKeyFrame == null){ // is on keyframe, or there is no other keyframe after this frame
				if(lastKeyFrame!=null){
					TimeLineKeyFrame.copyProperties(lastKeyFrame.properties, _target);
				}
			}else { // tween between keyframes
				var frameLength:Number = nextKeyFrame.frame - lastKeyFrame.frame;
				var offSet:Number = frame - lastKeyFrame.frame;
				
				var easeFunc:Function = Linear.easeNone;
				if (lastKeyFrame.easingFunc != null && lastKeyFrame.easingFunc.toLowerCase().indexOf("null") < 0 ){
					var splitArr:Array = lastKeyFrame.easingFunc.split(".");
					if (splitArr[0].indexOf("Linear") >=0 ) {
						easeFunc = Linear[ splitArr[1] ];
					}else if (splitArr[0].indexOf("Quadratic") >=0 ) {
						easeFunc = Quadratic[ splitArr[1] ];
					}else if (splitArr[0].indexOf("Extreme") >=0 ) {
						easeFunc = Extreme[ splitArr[1] ];
					}else if (splitArr[0].indexOf("Cubic") >=0 ) {
						easeFunc = Cubic[ splitArr[1] ];
					}else if (splitArr[0].indexOf("Bounce") >=0 ) {
						easeFunc = Bounce[ splitArr[1] ];
					}else if (splitArr[0].indexOf("Back") >=0 ) {
						easeFunc = Back[ splitArr[1] ];
					}else if (splitArr[0].indexOf("Quintic") >=0 ) {
						easeFunc = Quintic[ splitArr[1] ];
					}else if (splitArr[0].indexOf("Quartic") >=0 ) {
						easeFunc = Quartic[ splitArr[1] ];
					}
				}
				//trace("tweening between lastKeyFrame:" + lastKeyFrame + " nextKeyFrame:" + nextKeyFrame);
				//trace("easeFunc:" + easeFunc + " lastKeyFrame.easingFunc:"+lastKeyFrame.easingFunc);
				TimeLineKeyFrame.tweenProperties(lastKeyFrame.properties, nextKeyFrame.properties, _target, frameLength, offSet, easeFunc);
			}
		}
		
		private function getLastValidKeyframe( frame:Number ):TimeLineKeyFrame {
			var lastKeyFrame:TimeLineKeyFrame = TimeLineKeyFrame( _keyFrameGroup[ 1 ] );
			
			for (var i:uint = 2; i <= frame; i++) {
				if (_keyFrameGroup[ i ] != null) {
					lastKeyFrame = TimeLineKeyFrame( _keyFrameGroup[ i ] );
				}
			}
			
			return lastKeyFrame;
		}
		
		private function getNextValidKeyframe( frame:Number ):TimeLineKeyFrame {
			var nextKeyFrame:TimeLineKeyFrame = null;
			
			for (var i:uint = frame + 1; i <= _totalFrames; i++) {
				if (_keyFrameGroup[ i ] != null) {
					nextKeyFrame = TimeLineKeyFrame( _keyFrameGroup[ i ] );
					i = _totalFrames + 1;
				}
			}
			
			return nextKeyFrame;
		}
		
		public function startDraggingKey( keyFrame:TimeLineKeyFrame ) {
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
			
			if(_selectedKeyFrame.frame != this.mouseXFrame){ // if old frame is not equal to new
				// clear out old frame space
				delete _keyFrameGroup[ _selectedKeyFrame.frame ];
				
				// if there is already a keyframe there, delete it
				if (_keyFrameGroup[ this.mouseXFrame ] != null ) {
					clearKeyFrame( _keyFrameGroup[ this.mouseXFrame ] );
				}
				
				// update the new frame
				_selectedKeyFrame.frame = this.mouseXFrame;
				_selectedKeyFrame.x = 8 * (_selectedKeyFrame.frame - 1);
				_keyFrameGroup[ _selectedKeyFrame.frame ] = _selectedKeyFrame;
				resetTotalFrames();
			}
		}
		
		private function resetTotalFrames() {
			_totalFrames = 0;
			for each (var keyFrame:TimeLineKeyFrame in _keyFrameGroup) {
				if (keyFrame!=null && keyFrame.frame > _totalFrames) {
					_totalFrames = keyFrame.frame;
				}
			}
		}
		
		public function selectKeyFrame( keyFrame:TimeLineKeyFrame ) {
			if (_selectedKeyFrame != null && _selectedKeyFrame != keyFrame) {
				_selectedKeyFrame.deSelect();
			}
			
			//trace("selectKeyFrame keyFrame:" + keyFrame.frame + " _selectedKeyFrame:"+_selectedKeyFrame);
			
			_timeLineRef.selectFrame( keyFrame.frame, this );
			_selectedKeyFrame = keyFrame;
		}
		
		/*********************
		 * Get/Set Methods
		 * *******************/
		public function get target():BoxRotator {
			return _target;
		}
		
		public function get totalFrames():Number {
			return _totalFrames;
		}
		
		public function get mouseXFrame():Number {
			return Math.floor( this.mouseX / 8 ) + 1;
		}
		
		/*********************
		 * Serialize Methods
		 * *******************/
		
		public function serialize():String {
			var output:String = "";
			var key:TimeLineKeyFrame;
			for (var i:uint = 0; i <= _totalFrames; i++) {
				if (_keyFrameGroup[ i ] != null) {
					key = TimeLineKeyFrame( _keyFrameGroup[ i ] );
					output += key.serialize() + "|";
				}
			}
			output = output.substr(0, output.length - 1);
			return output;
		}
		
		public function deserialize( str:String ) {
			trace("timelineItem this:" + this + " str:" + str);
			var ptsArr:Array = str.split("|");
			var key:TimeLineKeyFrame;
			for (var i:uint = 0; i <ptsArr.length; i++) {
				key = new TimeLineKeyFrame();
				key.deserialize( ptsArr[i] );
				addKeyFrameObj( key );
			}
		}
		
	}
	
}