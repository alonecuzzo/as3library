package com.rokkan.utils 
{
	/**
	 * Various Number utilities.
	 */
	public class NumberUtil 
	{
		/**
		 * Formats a number with commas delimiting thousandths.
		 * @param	value	A number to format
		 * @return	String	A number formatted with commas
		 */
		public static function addCommas( value:Number ):String
		{
			var pattern:RegExp = /(\d+)(\d{3}(\.|,|$))/gi;
			var str:String = value.toString();
			
			while ( str.match(pattern).length != 0 )
			{
				str = ( str.replace( pattern, "$1,$2" ) );	
			}
			
			return str;
		}
		
		public static function roundToDecimals( value:Number, toXDecimals:Number = 2) {
			var pow:Number = Math.pow(10, toXDecimals);
			value = Math.round( value * pow ) / pow;
			return value;
		}
		
		/**
		 * Returns a hex value at the specified ratio between the to specified hex values.
		 * @param	hex		Start hex value.
		 * @param	hex2	End hex value.
		 * @param	ratio	A number between 0 and 1 representing the distance between the two values to calculate.
		 * @return
		 */
		public static function getGradientColor( hex:uint, hex2:uint, ratio:Number ):uint
		{
			var r:uint = hex >> 16;
			var g:uint = hex >> 8 & 0xFF;
			var b:uint = hex & 0xFF;
			r += ((hex2 >> 16)-r)*ratio;
			g += ((hex2 >> 8 & 0xFF)-g)*ratio;
			b += ((hex2 & 0xFF)-b)*ratio;
			return ( r<<16 | g<<8 | b );
		}
		
		/**
		 * Returns an array of hex values representing a gradient between the two specified hex values.
		 * @param	hex1	Start hex value.
		 * @param	hex2	End hex value.
		 * @param	steps	The amount of gradient steps to create.
		 * @return	An array of hex values.
		 */
		public static function getGradientSteps( hex1:uint, hex2:uint, steps:int ):Array
		{
			var newArry:Array = [hex1];
			
			var r:uint = hex1 >> 16;
			var g:uint = hex1 >> 8 & 0xFF;
			var b:uint = hex1 & 0xFF;
			
			var rd:uint = ( hex2 >> 16 ) - r;
			var gd:uint = ( hex2 >> 8 & 0xFF ) - g;
			var bd:uint = ( hex2 & 0xFF ) - b;
			
			steps++;
			
			for ( var i:int = 1; i < steps; i++ )
			{
				var ratio:Number = i / steps;
				
				newArry.push( ( r + rd * ratio ) << 16 | ( g + gd * ratio ) << 8 | ( b + bd * ratio ) );
			}
			
			newArry.push( hex2 );
			return newArry;
		}
		
		/**
		 * Returns a String with all non-number characters stripped.
		 * @param	str	String value
		 * @return	String with non-numbers characters stripped.
		 */
		public static function stripNonNumbers( str:String ):String {
			var returnStr:String = "";
			var chr:String;
			for (var i:uint = 0; i < str.length; i++) {
				chr = str.charAt(i);
				if (chr == "." || chr == "-" || chr == "0" || chr == "1" || chr == "2" || chr == "3" || chr == "4" || 
				chr == "5" || chr == "6" || chr == "7" || chr == "8" || chr == "9" ) {
					returnStr += chr;
				}
			}
			
			return returnStr;
		}
		
	}
	
}