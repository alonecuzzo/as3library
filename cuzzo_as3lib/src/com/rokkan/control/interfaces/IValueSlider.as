package com.rokkan.control.interfaces
{
	import flash.events.IEventDispatcher;
	
	/**
	 * Defines a set of common methods for a slider component.
	 */
	public interface IValueSlider extends IEventDispatcher
	{
		/**
		 * Specifies the minimum value for the slider.
		 */
		function get minValue():Number;
		function set minValue( v:Number ):void;
		
		/**
		 * Specifies the maximum value for the slider.
		 */
		function get maxValue():Number;
		function set maxValue( v:Number ):void;
		
		/**
		 * Specifies the value of the slider between the specified minimum and maxmium values.
		 */
		function get value():Number;
		function set value( v:Number ):void;
	}	
}
