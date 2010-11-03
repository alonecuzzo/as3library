package com.rokkan.timers {
	import com.rokkan.utils.ArrayMethods;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	* ...
	* @author $(DefaultUser)
	*/
	public class AfterXFrames {
		
		private static var _callBackArr:Array;
		private static var _frameCnt:Number = 0;
		private static var _onEnterAtt:Sprite;
		
		public static function init() {
			_onEnterAtt = new Sprite();
			_callBackArr = new Array();
		}
		
		public static function delayedCall(xFrames:uint, callback:Function, callbackArr:Array = null) {
			if (_onEnterAtt == null) {
				init();
			}
			
			if (_onEnterAtt.hasEventListener( Event.ENTER_FRAME ) == false)
				_onEnterAtt.addEventListener( Event.ENTER_FRAME, callEveryFrame, false, 0, true);
			
			_callBackArr.push([_frameCnt + xFrames, callback, callbackArr]);
		}
		
		public static function killCallTo(callback:Function) {  // cancel a delayed call to a function
			for (var i:uint = 0; i < _callBackArr.length; i++) {
				if (_callBackArr[i][1] == callback) {
					_callBackArr = ArrayMethods.arrayRemoveElem(_callBackArr, i);
				}
			}
		}
		
		private static function callEveryFrame( e:Event ) { // every on every enter frame, to see if there are any functions to dispatch
			if (_callBackArr.length <= 0) {
				_onEnterAtt.removeEventListener( Event.ENTER_FRAME, callEveryFrame);
				return false;
			}
			
			for (var i:uint = 0; i < _callBackArr.length; i++) {
				if (_callBackArr[i][0] <= _frameCnt) {
					_callBackArr[i][1].apply(null, _callBackArr[i][2]);
					_callBackArr = ArrayMethods.arrayRemoveElem(_callBackArr, i);
				}
			}
			
			_frameCnt++;
		}
		
		public static function die() {
			_onEnterAtt.removeEventListener( Event.ENTER_FRAME, callEveryFrame);
		}
	}
	
}