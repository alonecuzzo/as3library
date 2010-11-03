package com.atmospherebbdo.util.string
{
	/**
	 * Pads a string to a given width.
	 * 
	 * @param	str	String to pad
	 * @param	paddingNum	int, desired width
	 * @param	paddingChar	String used to pad
	 * 
	 * @return String
	 */
	public function padString(str:String, paddingNum:int, paddingChar:String=" " ):String
	{
	    var i:int;
	    var buf:Array = [];
	    for (i = 0; i < Math.abs(paddingNum) - str.length; i++)
	    {
	        buf.push(paddingChar);
	    }
	    if (paddingNum < 0)
	    {
	        buf.unshift(str);
	    }
	    else
	    {
	        buf.push(str);
	    }
	    return buf.join("");
	}}