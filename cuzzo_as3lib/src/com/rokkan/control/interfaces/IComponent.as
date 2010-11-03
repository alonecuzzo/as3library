package com.rokkan.control.interfaces 
{	
	import flash.events.IEventDispatcher;
	
	/**
	 * Defines a set of common component methods.
	 */
	public interface IComponent extends IEventDispatcher
	{
		/**
		 * Makes the component visible.
		 */
		function show():void;
		
		/**
		 * Makes the component invisible.
		 */
		function hide():void;
		
		/**
		 * Moves the component to the specified x and y positions
		 * @param	x	x position
		 * @param	y	y position
		 */
		function move( x:Number, y:Number ):void;
	}
	
}