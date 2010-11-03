package com.rokkan.control.interfaces 
{
	
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	
	/**
	 * Defines a set of common properties for a scrollable display object.
	 */
	public interface IScrollable extends IEventDispatcher
	{
		/**
		 * Sets the horizontal scroll position.
		 * @param	position	A number between 0 and 1 specifying the scroll position
		 */
		function setHScroll( position:Number ):void;
		
		/**
		 * Sets the vertical scroll position.
		 * @param	position	A number between 0 and 1 specifying the scroll position
		 */
		function setVScroll( position:Number ):void;
		
		/**
		 * The scrollable window area of the display object
		 */
		function get scrollWindow():Rectangle;
		function set scrollWindow( v:Rectangle ):void;
		
		/**
		 * The vertical scrollbar.
		 */
		function get vScrollbar():ISlider;
		function set vScrollbar( v:ISlider ):void;
		
		/**
		 * The horizontal scrollbar.
		 */
		function get hScrollbar():ISlider;
		function set hScrollbar( v:ISlider ):void;
		
		
	}
	
}