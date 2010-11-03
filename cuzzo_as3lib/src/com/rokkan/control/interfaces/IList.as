package com.rokkan.control.interfaces 
{
	import flash.events.IEventDispatcher;
	
	public interface IList extends IEventDispatcher
	{
		/**
		 * Sets the selected item of the list.
		 * @param	item	The item to select.
		 */
		function selectItem( item:IListItem ):void;
		
		/**
		 * The currently selected item in the list.
		 */
		function get selectedItem():Object;
		
		/**
		 * Specifies the display objects to place into the list control. All items should be a 
		 * valid display object and not be added to the stage yet.
		 */
		function get listItems():Array;
		function set listItems( v:Array ):void;
	}
	
}