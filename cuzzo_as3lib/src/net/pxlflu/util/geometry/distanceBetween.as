package com.atmospherebbdo.util.geometry 
{
	/**
	 * Calculates the distance between two locations. Anything
	 * with an x and y may be passed to this function.
	 * 
	 * @param 	a	Something with an x and y
	 * @param	b	Something with an x and y
	 * 
	 * @return		The distance between a and b
	 */
	public function distanceBetween(a:*, b:*):Number
	{
		return Math.sqrt(Math.pow(a.x - b.x, 2) + Math.pow(a.y - b.y, 2));
	}
}
