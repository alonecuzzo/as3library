package com.atmospherebbdo.pathfinding 
{
	import flash.events.Event;
	
	/**
	 * @author Mark Hawley
	 */
	public class PathFindingEvent extends Event 
	{
		public static const PATH_FOUND:String = "pathFound";
		public static const PATH_ERROR:String = "pathError";
		public static const CYCLE_COMPLETE:String = "cycleComplete";
		
		public function PathFindingEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
