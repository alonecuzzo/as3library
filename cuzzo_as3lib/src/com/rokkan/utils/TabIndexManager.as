package com.rokkan.utils 
{
	
	public class TabIndexManager 
	{
		
		private static var CURRENT_INDEX:int = -1;
		
		public static function getNextTabIndex():int
		{
			CURRENT_INDEX++;
			return CURRENT_INDEX;
		}
		
	}
	
}