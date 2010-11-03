package com.rokkan.core 
{
	
	import flash.display.MovieClip;
	
	/**
	 * Base class for custom display objects.
	 */
	public class UIComponent extends MovieClip
	{
		
		/**
		 * A hard coded width value for component's width that require redrawing when 
		 * adjusting the display object's width.
		 */
		protected var _width:Number = 0;
		
		/**
		 * A hard coded width value for component's height that require redrawing when 
		 * adjusting the display object's height.
		 */
		protected var _height:Number = 0;
		
		/**
		 * Creates an instance of the <code>UIComponent</code> class.
		 */
		public function UIComponent() 
		{
			
		}
		
		/* Protected Methods */
		
		/**
		 * Place holder method. Override with functionality that adds component children to display list.
		 */
		protected function addChildren():void
		{
			// Meant to me overrided.
		}
		
		
		/* Public Methods */
		
		/**
		 * Place holder method. Override with functionality that draws necessary display objects.
		 */
		public function draw():void
		{
			// Meant to me overrided.
		}
		
		/**
		 * Moves the display object to the specified x and y position
		 * @param	x	x position
		 * @param	y	y position
		 */
		public function move( x:Number, y:Number ):void
		{
			this.x = x;
			this.y = y;
		}
		
		/**
		 * Makes the display object visible.
		 */
		public function show():void
		{
			this.visible = true;
		}
		
		/**
		 * Makes the display object invisible.
		 */
		public function hide():void
		{
			this.visible = false
		}
		
	}
	
}
