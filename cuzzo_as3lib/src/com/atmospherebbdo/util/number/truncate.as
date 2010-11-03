package com.atmospherebbdo.util.number 
{
	/**
	 * Truncates a number to a certain precision.
	 * 
	 * @param	raw	Number to truncate
	 * @param	decimals uint, desired precision in digits
	 * 
	 * @return Number
	 */
	public function truncate(raw:Number, decimals:uint=2) :Number 
	{
		var power:int = Math.pow(10, decimals);
		return Math.floor(raw * ( power )) / power;
	}}