package com.rokkan.control.interfaces 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * Defines a set of common methods for a slider component.
	 */
	public interface ISlider extends IEventDispatcher
	{
		/**
		 * Specifies the position of the slider expressed as a number between 0 and 1.
		 */
		function get position():Number;
		function set position( v:Number ):void;
	}
	
}