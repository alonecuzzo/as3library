package com.rokkan.control.interfaces
{
	import flash.events.IEventDispatcher;
	
	/**
	 * Defines a set of common methods for components that display the progress of something.
	 */
	public interface IProgressIndicator extends IEventDispatcher
	{
		/**
		 * Specifies the progress value expressed as a number between 0 and 1.
		 */
		function get progress():Number;
		function set progress( v:Number ):void;
	}
}
