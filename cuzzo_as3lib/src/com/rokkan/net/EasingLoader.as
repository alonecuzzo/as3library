package com.rokkan.net {
	import flash.events.Event;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class EasingLoader {
		// created vars
		private var _callback:Function;
		private var _destRatio:Number;
		private var _animRatio:Number;
		private var _maxSpeed:Number;
		private var _attachPt;
		private var _onComplete:Function;
		private var _onProgress:Function;
		private var _easeInAmt:Number;
		private var _easeOutAmt:Number;
		
		public function EasingLoader(attachPt, onComplete:Function, onProgress:Function = null, easeInAmt:Number = 0.15, easeOutAmt:Number = 1.12) {
			_destRatio = _animRatio = 0;
			_attachPt = attachPt;
			_onComplete = onComplete;
			_onProgress = onProgress;
			_easeInAmt = easeInAmt;
			_easeOutAmt = easeOutAmt;
			_maxSpeed = 0.01;
			
			_attachPt.addEventListener(Event.ENTER_FRAME, loaderAnimOnEnter, false, 0, true);
		}
		
		public function set ratio(ratio:Number) { 
			_destRatio = ratio;
		}
		
		public function get ratio():Number {
			return _destRatio;
		}
		
		private function loaderAnimOnEnter( event:Event = null ){
			var diff:Number = _destRatio - _animRatio;
			var offSet:Number = diff >= 0 ? Math.pow(diff, 0.5) : 0;
			if (offSet < 0.001)
				offSet = 0.001;
			if(offSet>_maxSpeed){ // ease in to the top speed
				offSet = _maxSpeed;
				_maxSpeed = _maxSpeed<=0.01 ? 0.01 : _maxSpeed; // never let maxspeed be zero
				_maxSpeed *= _easeOutAmt;
			}else {
				_maxSpeed = offSet==0 ? 0.01 : offSet; // never let maxspeed be zero
			}
			
			//trace("_animRatio:" + _animRatio.toFixed(3) + " offSet:"+offSet.toFixed(3));
			if (_animRatio + offSet >= _destRatio){  // start the ease in to the _destRatio
				offSet = (_destRatio - _animRatio) * _easeInAmt;
			}
			
			_onProgress( _animRatio );
			
			_animRatio += offSet;
			if(_animRatio>_destRatio)
				_animRatio = _destRatio;
			
			if(Math.round(_animRatio*1000)>=1000){
				_attachPt.removeEventListener(Event.ENTER_FRAME, loaderAnimOnEnter);
				_onComplete();
			}
		}
		
	}
	
}