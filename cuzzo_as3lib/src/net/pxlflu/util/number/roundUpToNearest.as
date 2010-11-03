package com.atmospherebbdo.util.number 
{
	/**
	 * Adapted from Yahoo! Flash Developer utilities.
	 * 
	 * Rounds a Number <em>up</em> to the nearest multiple of an input. For example, by rounding
	 * 16 up to the nearest 10, you will receive 20. Similar to the built-in function Math.ceil().
	 * 
	 * @param	numberToRound		the number to round up
	 * @param	nearest				the number whose mutiple must be found
	 * @return	the rounded number
	 * 
	 * @see Math#ceil
	 */
	public function roundUpToNearest(number:Number, nearest:Number = 1):Number
	{
		return Math.ceil(roundToPrecision(number / nearest, 10)) * nearest;
	}}