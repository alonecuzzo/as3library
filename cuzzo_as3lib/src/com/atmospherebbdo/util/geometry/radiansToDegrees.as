package com.atmospherebbdo.util.geometry 
{
	/**
	 * Converts an angle from radians to degrees.
	 * 
	 * @param radians		The angle in radians
	 * @return				The angle in degrees
	 */
	public function radiansToDegrees(radians:Number):Number
	{
		return radians * 180 / Math.PI;
	}
}
