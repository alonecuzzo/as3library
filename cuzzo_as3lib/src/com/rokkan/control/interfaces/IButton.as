package com.rokkan.control.interfaces 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * Defines a set of common button methods and properties.
	 */
	public interface IButton extends IEventDispatcher
	{
		/**
		 * Selects the button.
		 */
		function select():void;
		
		/**
		 * Deselects the button.
		 */
		function deselect():void;
		
		/**
		 * Enables the button.
		 */
		function enable():void;
		
		/**
		 * Disables the button.
		 */
		function disable():void;
		
		/**
		 * Is equal to <code>true</code> if the button is enabled and vice versa.
		 */
		function get isEnabled():Boolean;
		
		/**
		 * Is equal to <code>true</code> if the button is selected and vice versa.
		 */
		function get isSelected():Boolean;
	}
}
