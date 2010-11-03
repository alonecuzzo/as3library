package com.atmospherebbdo.util.geometry 
{
	/**
	 * Converts an angle from degrees to radians.
	 * 
	 * @param degrees		The angle in degrees
	 * @return				The angle in radians
	 */
	public function degreesToRadians(degrees:Number):Number
	{
		return degrees * Math.PI / 180;
	}
}
