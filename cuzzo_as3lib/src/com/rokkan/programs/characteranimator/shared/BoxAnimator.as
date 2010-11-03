package com.rokkan.programs.characteranimator.shared 
{
	import com.rokkan.programs.characteranimator.parts.BoxRotator;
	import com.rokkan.tween.Extreme;
	import com.rokkan.utils.ArrayMethods;
	import fl.motion.easing.*;
	import fl.transitions.Tween;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import gs.TweenLite;
	import flash.utils.getTimer;
	
	/**
	* Not finished, don't use
	* @author Russell Savage
	*/
	public class BoxAnimator 
	{
		public static var frameRate:Number = 40;
		
		
		// created vars
		private var _startTime:uint = 0;
		private var _frameOffset:uint = 0;
		private static var _delayedAnimsArr:Array = new Array();
		private static var _cleanupArr:Array = new Array();
		
		public function BoxAnimator() 
		{
			
		}
		
		public function start(frameOffset:Number = 0) {
			_startTime = getTimer();
			_frameOffset = frameOffset;
		}
		
		public function get current():Number {
			var calc1:Number = (getTimer() - _startTime ) / 1000 * frameRate;
			return calc1 + _frameOffset;
		}
		
		/**
		 * Animate a BoxRotator model, with a premade animation described in an XML file
		 * @param	the base of the BoxRotator Model
		 * @param	the XML definition of the animation
		 * @param	vars, optional additional parameters: onComplete (Function to call once animation is complete), 
		 * 			delay (Number in seconds), useFirstFrameValues (Boolean), playBackSpeed (Number from 0-1), 
		 * 			onReady wait until assets are loaded before starting the animation
		 * @return 	nothing
		 */
		public static function animate( baseBox:BoxRotator, animDefinition:XML, vars:Object = null ):void {
			
			vars = vars == null ? { } : vars;
			var onReady:Function = vars.onReady; // only start animating onReady
			if(onReady==null){ // ready to Start animating now!
				var delay:Number = vars.delay == null ? 0 : vars.delay;
				var callback:Function = vars.onComplete;
				var useFirstFrameValues:Boolean = Boolean( vars.useFirstFrameValues );
				var playBackSpeed:Number = vars.playBackSpeed == null ? 1 : vars.playBackSpeed;
				
				var timeLineList:XMLList = animDefinition.timeLine.timeLineItem;
				
				var targetDict:Dictionary = new Dictionary(false);
				
				getAllChildren( baseBox, targetDict );
				
				var animationDescr:Object;
				var tweensArr:Array;
				var propsArr:Array;
				var propArr:Array;
				var easeFunc:Function = Linear.easeNone;
				var lastFrameAmt:Number;
				var easeTime:Number;
				var targetId:String;
				var target:BoxRotator;
				var lastFrame:Number = 0;
				for (var i:uint = 0; i < timeLineList.length(); i++) // loop through targets
				{
					targetId = timeLineList[i].@id;
					tweensArr = timeLineList[i][0].split("|");
					lastFrameAmt = 0;
					for (var j:uint = 0; j < tweensArr.length; j++) { // loop through tweens for target
						target = targetDict[ targetId ];
						
						if (j >= 1 ) {
							animationDescr = { overwrite:false, delay:delay };
							propsArr = tweensArr[j].split(",");
							for (var k:uint = 0; k < propsArr.length; k++) { // loop through properties to tween
								propArr = propsArr[k].split(":");
								if (propArr[0].indexOf("frame") >= 0 ) { // define time length
									var timeOff:Number = Number( propArr[1] - 1 );
									if (timeOff > lastFrame)
										lastFrame = timeOff; 
									
									easeTime = ( timeOff - lastFrameAmt ) / frameRate * playBackSpeed;
									animationDescr[ "delay" ] = delay + ( lastFrameAmt ) / frameRate * playBackSpeed;
									
									lastFrameAmt = timeOff;
									
								} else if (propArr[0].indexOf("easingFunc") >= 0 ) { // Define easing function
									if (propArr[0].indexOf("Linear") >=0 ) {
										easeFunc = Linear[ propArr[1] ];
									}else if (propArr[0].indexOf("Quadratic") >=0 ) {
										easeFunc = Quadratic[ propArr[1] ];
									}else if (propArr[0].indexOf("Extreme") >=0 ) {
										easeFunc = Extreme[ propArr[1] ];
									}else if (propArr[0].indexOf("Cubic") >=0 ) {
										easeFunc = Cubic[ propArr[1] ];
									}else if (propArr[0].indexOf("Bounce") >=0 ) {
										easeFunc = Bounce[ propArr[1] ];
									}else if (propArr[0].indexOf("Back") >=0 ) {
										easeFunc = Back[ propArr[1] ];
									}else if (propArr[0].indexOf("Quintic") >=0 ) {
										easeFunc = Quintic[ propArr[1] ];
									}else if (propArr[0].indexOf("Quartic") >=0 ) {
										easeFunc = Quartic[ propArr[1] ];
									}
									
									animationDescr[ "ease" ] = easeFunc;
								}else {
									animationDescr[ propArr[0] ] = Number( propArr[1] );
								}
							}
							//trace("target:" + target + " easeTime:" + easeTime + " delay:" + animationDescr["delay"]);
							TweenLite.to( target, easeTime, animationDescr);
						}else if (useFirstFrameValues && j == 0) {
							trace("using first frames delay:" + delay);
							TweenLite.delayedCall( delay, useFirstValues, [ tweensArr[j], target ] );
						}
						
					} // end second for loop
				} // end first for loop
				
				// Loop through sounds
				if (vars.soundAssets != null) {
					var soundAssetsArr:Array = vars.soundAssets;
					for (i = 0; i < soundAssetsArr.length; i++) {
						var soundItem:Sound = soundAssetsArr[i][0];
						var startAt:Number = (soundAssetsArr[i][2]-1) / frameRate * playBackSpeed;
						var soundChannel:SoundChannel = soundItem.play( startAt );
						soundChannel.addEventListener( Event.SOUND_COMPLETE, soundCompletedCleanup, false, 0, true);
						_cleanupArr.push( [baseBox, soundChannel ] );
					}
				}
				
				TweenLite.delayedCall((lastFrame+1) / frameRate * playBackSpeed + delay, callBackWhenFinished, [callback]);
			} // end if (onReady) 
			else { // onReady is defined
				var timeLineSoundList:XMLList = animDefinition.timeLine.soundLineItem;
				//var propsArr:Array;
				//var propArr:Array;
				for (i = 0; i < timeLineSoundList.length(); i++) // loop through targets
				{
					propsArr = timeLineSoundList[i].split(",");
					var soundAssets:Array = new Array();
					var frameNum:Number = -1;
					var soundSrc:String = null;
					for (k = 0; k < propsArr.length; k++) {
						propArr = propsArr[k].split(":");
						if (propArr[0].indexOf("_soundSrc") >= 0) {
							soundSrc = propsArr[k].substring( propsArr[k].indexOf(":") + 1);
						}else if (propArr[0].indexOf("frame") >= 0) {
							frameNum = Number( propArr[1] );
						}
					}
					
					if (frameNum > 0 && soundSrc != null) {
						var sound:Sound = new Sound();
						//trace("loading sound:" +soundSrc + " frameNum:"+frameNum);
						sound.addEventListener(Event.COMPLETE, soundLoaded, false, 0, true);
						sound.load( new URLRequest( soundSrc ) );
						soundAssets.push( [sound, false, frameNum] ); // structure: sound, isLoaded, frameNumber
					}
					
					_delayedAnimsArr.push( [ soundAssets, baseBox, animDefinition, vars ] );
				}
			}
		}
		
		private static function useFirstValues( vals:String, target:BoxRotator ) {
			var propsArr:Array = vals.split(",");
			var propArr:Array;
			for (var k:uint = 0; k < propsArr.length; k++) {
				propArr = propsArr[k].split(":");
				if (propArr[0].indexOf("frame") < 0 && propArr[0].indexOf("easingFunc") < 0) {
					target[ propArr[0] ] = Number( propArr[1] );
					TweenLite.killTweensOf( target[ propArr[0] ] );
				}
			}
		}
		
		private static function soundCompletedCleanup( e:Event = null ) {
			trace("sound completed:" + e.target);
			var soundChannel:SoundChannel = SoundChannel( e.target );
			
			for (var i:uint = 0; i < _cleanupArr.length; i++) {
				if (_cleanupArr[i][1] == soundChannel) {
					_cleanupArr = ArrayMethods.arrayRemoveElem( _cleanupArr, i);
					break;
				}
			}
		}
		
		private static function soundLoaded( e:Event = null ) {
			var soundTarget = e.target;
			trace("soundLoaded soundTarget:" + soundTarget);
			
			for (var i:uint = 0; i < _delayedAnimsArr.length; i++) {
				var loadedCnt:Number = 0;
				for (var k:uint = 0; k < _delayedAnimsArr[i][0].length; k++) {
					if (soundTarget == _delayedAnimsArr[i][0][k][0]) {
						trace("sound loaded");
						_delayedAnimsArr[i][0][k][1] = true;
					}
					
					if (_delayedAnimsArr[i][0][k][1]) {
						loadedCnt++;
					}
					
					if (loadedCnt >= _delayedAnimsArr[i][0].length) {
						trace("ALl sounds loaded");
						var soundArr:Array = _delayedAnimsArr[i][0];
						_delayedAnimsArr[i][3].soundAssets = soundArr;
						_delayedAnimsArr[i][3].onReady();
						_delayedAnimsArr[i][3].onReady = null;
						animate( _delayedAnimsArr[i][1], _delayedAnimsArr[i][2], _delayedAnimsArr[i][3] );
						_delayedAnimsArr = ArrayMethods.arrayRemoveElem( _delayedAnimsArr, i );
						break;
						break;
					}
				}
			}
		}
		
		private static function callBackWhenFinished( callback:Function ) {
			if(callback!=null)
				callback();
		}
		
		public static function killSoundsOf( box:BoxRotator ) {
			var newCleanupArr:Array = new Array();
			for (var i:uint = 0; i < _cleanupArr.length; i++) {
				if (_cleanupArr[i][0] == box) {
					var soundChan:SoundChannel = _cleanupArr[i][1];
					soundChan.stop();
				}else {
					newCleanupArr.push( _cleanupArr[i] );
				}
			}
			
			_cleanupArr = newCleanupArr;
		}
		
		public static function killTweensOf( box:BoxRotator, andChildren:Boolean = true ) {
			killSoundsOf( box);
			TweenLite.killDelayedCallsTo( callBackWhenFinished );
			TweenLite.killTweensOf( box );
			
			if (andChildren) {
				var children:Array = box.children;
				for (var i:uint = 0; i < children.length; i++) {
					if (children[i] is BoxRotator) {
						killTweensOf( children[i] );
					}
				}
			}
		}
		
		public static function loadModel( xml:XML ):BoxRotator {
			return loadModelItem( xml );	
		}
		
		private static function loadModelItem( xmlData:XML, addToItem = null, level:Number = 0):BoxRotator {
			var addBox:BoxRotator = new BoxRotator("temp");
			addBox.deserialize( xmlData.attribute("data") );
			
			if(addToItem!=null)
				addToItem.addChild( addBox );
			
			if (xmlData.children().length() > 0) {
				var boxList:XMLList = xmlData.children();	
				for each (var  boxInfo:XML in boxList){
					loadModelItem( boxInfo, addBox, level + 1);
				}
			}
			
			return addBox;
		}
		
		private static function getAllChildren( box:BoxRotator, dict:Dictionary ):void {
				dict[ box.id ] = box;
				
				var childrenArr:Array  = box.children;
				for (var i:uint = 0; i < childrenArr.length; i++) {
					if (childrenArr[i] is BoxRotator) {
						getAllChildren( childrenArr[i], dict);
					}
				}
			}
	}
	
}