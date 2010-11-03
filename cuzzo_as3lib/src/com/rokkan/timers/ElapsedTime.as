package com.rokkan.timers {
	import flash.utils.getTimer;
	
	/**
	* Elapsed Time - 
	* @author Russell Savage
	*/
	public class ElapsedTime {
		private var _timerMultiArr;
		private var _isPaused:Boolean = false;
		
		public function ElapsedTime() {
			_timerMultiArr = new Object;
		}
		
		public function addTimer(timerId:uint):Boolean {
			if (_timerMultiArr[timerId] != undefined)
				return false;
			
			_timerMultiArr[timerId] = getTimer();  
			
			return true;
		}
		
		public function pauseTimers() {
			_isPaused = true;
		}
		
		public function unPauseTimers() {
			_isPaused = false;
		}
		
		public function isPaused() {
			return _isPaused;
		}
		
		public function getElapsedTime(id:uint):Number {
			var currentTime:Number = getTimer();
			var diff:Number = currentTime - _timerMultiArr[id];
			
			if(_isPaused==false){
				_timerMultiArr[id] = currentTime;
				return diff;
			}else {
				_timerMultiArr[id] = currentTime;
				return 0;
			}
		}
		
	}
	
}