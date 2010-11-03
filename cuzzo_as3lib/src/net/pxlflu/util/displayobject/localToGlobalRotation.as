package com.atmospherebbdo.util.displayobject 
{
	import flash.display.DisplayObject;	
			
	
	/**
	 * Converts a rotation in the coordinate system of a display object 
	 * to a global rotation relative to the stage.
	 * 
	 * Stolen from Flint Particle Effects Library.
	 * 
	 * @param obj The display object
	 * @param rotation The rotation
	 * 
	 * @return The rotation relative to the stage's coordinate system.
	 */
	public function localToGlobalRotation( obj:DisplayObject, rotation:Number ):Number
	{
		var rot:Number = rotation + obj.rotation;
		for( var current:DisplayObject = obj.parent; current && current != obj.stage; current = current.parent )
		{
			rot += current.rotation;
		}
		return rot;
	}}