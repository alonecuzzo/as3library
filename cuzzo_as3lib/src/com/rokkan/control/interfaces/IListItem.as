package com.rokkan.control.interfaces 
{
	import flash.events.IEventDispatcher;
	
	public interface IListItem extends IEventDispatcher
	{
		/**
		 * Specifies the list item's data object.
		 */
		function get data():Object;
		function set data( v:Object ):void;

	}
	
}