package com.atmospherebbdo.layout 
{
	import flash.display.DisplayObjectContainer;		

	/**
	 * @author mark hawley
	 * 
	 * Interface for objects that automatically lay out children
	 * within them.
	 */
	public interface ILayoutStrategy 
	{
		function layout( obj:DisplayObjectContainer ) :void;
	}
}
