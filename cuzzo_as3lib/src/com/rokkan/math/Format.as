package com.rokkan.math 
{
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class Format 
	{
		
		public function Format() 
		{
			
		}
		
		public static function minFix( val:Number, min:Number ):String {
			var shrunk:String = val.toFixed( min );
			if (Number( val )%1==0) {
				return String(Math.round( val ));
			}
			if (shrunk.length > val.toString().length) {
				
				return val.toString();
			}
			var newVal:Number = Number( shrunk );
			return newVal.toString();			
		}
		
		public static function addCommas( val:Number ):String {
			val = Math.round( val );
			var valStr:String = String( val );
			var returnStr:String = "";
			for (var i:int = valStr.length - 1; i > 0 ; i = i - 3) {
				returnStr += "," + valStr.substring( i, i + 3);
				trace("returnStr:" + returnStr);
			}
			
			returnStr = returnStr.substring(1);
			
			return returnStr;
		}
		
	}
	
}