package com.atmospherebbdo.util.string
{
	import com.atmospherebbdo.util.number.truncate;	
	
	/**
	 * Turns a number into a string padded with the given number
	 * of digits.
	 * 
	 * @param	raw	Number to pad
	 * @param	decimals	int, desired width
	 * 
	 * @return	String
	 */
	public function padFloat(raw:Number, digitsAfterDecimal:int = 2):String
	{
		if (0 == digitsAfterDecimal)
		{
			return Math.floor( raw ).toString();
		}
		
	    var num:Number = truncate(raw, digitsAfterDecimal);
	    var numStr:String = num.toString();
	    
	    if (numStr.indexOf(".") == -1)
	        numStr += ".0";
	    
	    var buf:Array = [];
	    var i:int;
	    
	    for (i = 0; i < digitsAfterDecimal - numStr.substr(numStr.indexOf(".") + 1).length; i++)
	    {
	        buf.push("0");
	    }
	    buf.unshift(numStr);
	    
	    return buf.join("");
	}}