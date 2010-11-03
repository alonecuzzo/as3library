package com.atmospherebbdo.util.displayobject 
{
	import com.atmospherebbdo.dbc.precondition;
	
	import flash.display.DisplayObject;								
	
	/**
	 * Adapted from Yahoo! Flash Developer utilities.
	 * 
	 * Aligns a DisplayObject vertically and horizontally within specific bounds.
	 * 
	 * @param target			The DisplayObject to align.
	 * @param bounds			*, something with x, y, height, and width: a rectangle or display object, usually.
	 * @param hAlign	VerticalAlignment, the alignment position along the horizontal axis. If <code>null</code>,
	 * 							the target's horizontal position will not change.
	 * @param vAlign	HorizontalAlignment, the alignment position along the vertical axis. If <code>null</code>,
	 * 							the target's vertical position will not change.
	 */
	public function align(target:DisplayObject, bounds:*, hAlign:HorizontalAlignment=null, vAlign:VerticalAlignment=null):void
	{	
		// test bounds
		precondition( 
			bounds.x != undefined && 
			bounds.y != undefined && 
			bounds.height != undefined && 
			bounds.width != undefined, 
			"Bounds must have x, y, width, and height." );
		
		var horizontalDifference:Number = bounds.width - target.width;
		switch(hAlign)
		{
			case HorizontalAlignment.LEFT:
				target.x = bounds.x;
				break;
			case HorizontalAlignment.CENTER:
				target.x = bounds.x + (horizontalDifference) / 2;
				break;
			case HorizontalAlignment.RIGHT:
				target.x = bounds.x + horizontalDifference;
				break;
			default:
				// do nothing
				break;
		}
				
		var verticalDifference:Number = bounds.height - target.height;
		switch(vAlign)
		{
			case VerticalAlignment.TOP:
				target.y = bounds.y;
				break;
			case VerticalAlignment.MIDDLE:
				target.y = bounds.y + (verticalDifference) / 2;
				break;
			case VerticalAlignment.BOTTOM:
				target.y = bounds.y + verticalDifference;
				break;
			default:
				// do nothing
				break;
		}
	}}