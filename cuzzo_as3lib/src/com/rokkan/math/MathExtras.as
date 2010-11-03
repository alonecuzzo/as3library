package com.rokkan.math 
{
	import flash.utils.Dictionary;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class MathExtras 
	{
		
		private static var _randomProfDic:Dictionary = new Dictionary();
		
		public function MathExtras() 
		{
			
		}
		
		/**
		 * A fake randomize function that keeps from repeating an item too many times in a row
		 * @param	a positive minimum value you wish to get back
		 * @param	a positive maximum value you wish to get back
		 * @param	the degree to which the likelihood of the last number is to be used again.
		 * @return 	an random-esque positive integer between the minimum and maximum numbers provided
		 */
		public static function randomFake( min:uint, max:uint, degradeRatio:Number = 0.5 ):uint {
			var output:String = "";
			var key:String = "" + min + "," + max;
			if ( _randomProfDic[ key ] == null) {
				_randomProfDic[ key ] = new Array();
			}
			
			var totalNum:Number = 0;
			for ( var i:uint = min; i < max; i++) {
				if (_randomProfDic[ key ][i] == null) {
					_randomProfDic[ key ][i] = 1;
				}
				totalNum += _randomProfDic[ key ][i];
			}
			
			var rand:Number = Math.random() * totalNum;
			//output += " rand:" + rand + " totalNum:" + totalNum;
			var useKey:uint;
			totalNum = 0;
			for ( i = min; i < max; i++) {
				totalNum += _randomProfDic[ key ][i];
				//output += " _randomProfDic[ key ][" + i + "]:" + _randomProfDic[ key ][i] + " totalNum:"+totalNum;
				
				if ( totalNum >= rand ) {
					useKey = i;
					output += "\nsetting useKey:" + useKey;
					_randomProfDic[ key ][i] *= degradeRatio;
					break;
				}else {
					if(_randomProfDic[ key ][i] < 1){ // if the ratio was lowered before, bring it back up towards 1
						_randomProfDic[ key ][i] *= (1 / degradeRatio);
					}
				}
			}
			
			return useKey;
		}
		
	}
	
}