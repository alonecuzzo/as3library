package com.atmospherebbdo.util.displayobject 
{
	import flash.display.DisplayObject;	
	
	/**
	 * Adapted from Yahoo! Flash Developer utilities.
	 * 
	 * Resizes a DisplayObject to fit into specified bounds such that the
	 * aspect ratio of the target's width and height does not change.
	 * 
	 * @param target		The DisplayObject to resize.
	 * @param width			The desired width for the target.
	 * @param height		The desired height for the target.
	 * @param aspectRatio	The desired aspect ratio. If NaN, the aspect
	 * 						ratio is calculated from the target's current
	 * 						width and height.
	 */
	public function resizeAndMaintainAspectRatio(target:DisplayObject, width:Number, height:Number, aspectRatio:Number = NaN):void
	{
		var currentAspectRatio:Number = !isNaN(aspectRatio) ? aspectRatio : target.width / target.height;
		var boundsAspectRatio:Number = width / height;
		
		if(currentAspectRatio < boundsAspectRatio)
		{
			target.width = Math.floor(height * currentAspectRatio);
			target.height = height;
		}
		else
		{
			target.width = width;
			target.height = Math.floor(width / currentAspectRatio);
		}
	}}