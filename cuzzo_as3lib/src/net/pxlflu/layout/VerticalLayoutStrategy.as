package com.atmospherebbdo.layout 
{
	import com.atmospherebbdo.layout.ILayoutStrategy;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;	

	/**
	 * @author mark hawley
	 * 
	 * Layout strategy that lays out the children of a 
	 * DisplayObjectContainer on top of each other.
	 */
	public class VerticalLayoutStrategy implements ILayoutStrategy 
	{
		private var padding:Number;
		
		/**
		 * Constructor.
		 * 
		 * @param	padding	Number (optional, defaults to 0.) Pixels
		 * 					to space the children out.
		 */
		public function VerticalLayoutStrategy( padding:Number = 0 )
		{
			this.padding = padding;
		}
		
		/**
		 * Performs the strategy's layout.
		 * 
		 * @param	obj	DisplayObjectContainer
		 */
		public function layout(obj:DisplayObjectContainer):void
		{
			var y:Number = 0;
			for (var i:int = 0; i < obj.numChildren; i++)
			{
				var child:DisplayObject = obj.getChildAt(i);
				child.y = y;
				y = child.y + child.height + padding;
			}
		}
	}
}
