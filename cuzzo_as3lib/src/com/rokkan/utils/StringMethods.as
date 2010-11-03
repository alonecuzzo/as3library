package com.rokkan.utils {
	
	/**
	* ...
	* @author $(DefaultUser)
	*/
	public class StringMethods {
		
		public function StringMethods() {
			
		}
		
		public static function stripHtmlChars(str:String) {
			str = replaceStr(str, "\r\n", "");
			str = replaceStr(str, "&lt;", "<");
			str = replaceStr(str, "&gt;", ">");
			str = replaceStr(str, "&quot;", "\"");
			str = replaceStr(str, "&apos;", "'");
			str = replaceStr(str, "&amp;", "&");
			str = replaceStr(str, "&trade;", "™");
			str = replaceStr(str, "%20", " ");
			
			return str;
		}
		
		public static function replaceStr(source:String, change:String, replacement:String):String{
			var tmp:Array = source.split( change );
			return tmp.join( replacement );
		}
		
	}
	
}