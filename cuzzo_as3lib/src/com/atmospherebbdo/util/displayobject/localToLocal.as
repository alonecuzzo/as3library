package com.atmospherebbdo.util.displayobject 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;		
	
	/**
	 * Adapted from Yahoo! Flash Developer utilities.
	 * 
 	 * Converts a point from the local coordinate system of one DisplayObject to
	 * the local coordinate system of another DisplayObject.
	 *
	 * @param point					the point to convert
	 * @param firstDisplayObject	the original coordinate system
	 * @param secondDisplayObject	the new coordinate system
	 */
	public function localToLocal(point:Point, firstDisplayObject:DisplayObject, secondDisplayObject:DisplayObject):Point
	{
		point = firstDisplayObject.localToGlobal(point);
		return secondDisplayObject.globalToLocal(point);
	}}