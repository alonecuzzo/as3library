package com.atmospherebbdo.util.number 
{
	/**
	 * Adapted from Yahoo! Flash Developer utilities.
	 * 
	 * Rounds a Number to the nearest multiple of an input. For example, by rounding
	 * 16 to the nearest 10, you will receive 20. Similar to the built-in function Math.round().
	 * 
	 * @param	numberToRound		the number to round
	 * @param	nearest				the number whose mutiple must be found
	 * @return	the rounded number
	 * 
	 * @see Math#round
	 */
	public function roundToNearest(number:Number, nearest:Number = 1):Number
	{
		return Math.round(roundToPrecision(number / nearest, 10)) * nearest;
	}}