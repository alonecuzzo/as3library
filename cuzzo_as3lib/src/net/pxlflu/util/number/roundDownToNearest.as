package com.atmospherebbdo.util.number 
{
	/**
	 * Adapted from Yahoo! Flash Developer utilities.
	 * 
	 * Rounds a Number <em>down</em> to the nearest multiple of an input. For example, by rounding
	 * 16 down to the nearest 10, you will receive 10. Similar to the built-in function Math.floor().
	 * 
	 * @param	numberToRound		the number to round down
	 * @param	nearest				the number whose mutiple must be found
	 * @return	the rounded number
	 * 
	 * @see Math#floor
	 */
	public function roundDownToNearest(number:Number, nearest:Number = 1):Number
	{
		return Math.floor(roundToPrecision(number / nearest, 10)) * nearest;
	}}