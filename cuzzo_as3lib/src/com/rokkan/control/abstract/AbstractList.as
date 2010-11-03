package com.rokkan.control.abstract 
{
	import com.rokkan.control.interfaces.IListItem;
	import com.rokkan.core.UIComponent;
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * The <code>AbstractList</code> class is a base class to use when creating custom display lists.
	 * A display list is a collection if display objects organized in a vertical manner.When extending 
	 * <code>AbstractList</code> be sure to supply the super's constructor with a reference to your 
	 * custom class or will receive an IllegalOperationError.
	 * @see com.rokkan.control.abstract.AbstractListItem
	 */
	public class AbstractList extends UIComponent
	{
		
		protected var _listItems:Array;
		protected var _selectedItem:IListItem;
		protected var _selectable:Boolean;
		
		/**
		 * Creates a new <code>AbstractList</code> instance
		 * @param	self	A reference to the object/class extending <code>AbstractList</code>
		 * @throws flash.errors.IllegalOperationError	The constructor must receive a reference to
		 * the object/class extending <code>AbstractList</code>.
		 */
		public function AbstractList( self:AbstractList ) 
		{
			if ( self != this )
			{
				throw new IllegalOperationError("AbstractList did not receive reference to self. " +
					"AbstractList cannot be instantiated directly and must be extended.");
			}
		}
		
		/**
		 * Utility method which dispatches <code>Event.SELECT</code> event.
		 */
		protected function notifyItemSelected():void
		{
			dispatchEvent( new Event( Event.SELECT ) );
		}
		
		protected function onListItemClick( event:MouseEvent ):void
		{
			var item:IListItem = event.target as IListItem;
			selectItem( item );
		}
		
		/**
		 * Place holder method. Override with custom behavior.
		 */
		protected function addListItems():void
		{
			trace( "AbstractList.addListItems" );
			var nextY:Number = 0;
			for ( var i:int = 0; i < listItems.length; i++ )
			{
				var item:DisplayObject = _listItems[i] as DisplayObject;
				item.x = 0;
				item.y = nextY;
				this.addChild( item );
				nextY += item.height;
			}
			
			configureItemListeners();
		}
		
		protected function configureItemListeners():void
		{
			for ( var i:int = 0; i < listItems.length; i++ )
			{
				var item:DisplayObject = _listItems[i] as DisplayObject;
				
				if ( _selectable )
				{
					if( !item.hasEventListener( MouseEvent.CLICK ) )
						item.addEventListener( MouseEvent.CLICK, onListItemClick );
				}
				else
				{
					if( item.hasEventListener( MouseEvent.CLICK ) )
						item.removeEventListener( MouseEvent.CLICK, onListItemClick );
				}
			}
		}
		
		/**
		 * Abstracted method which removes the current items from the list.
		 */
		protected function removeListItems():void
		{
			while( this.numChildren > 0 )
			{
				this.removeChildAt( 0 );
			}
			_listItems = null;
		}
		
		/**
		 * Sets the selected item of the list.
		 * @param	item	The item to select.
		 */
		public function selectItem( item:IListItem ):void
		{
			_selectedItem = item;
			notifyItemSelected();
		}
		
		/**
		 * Removes all items from the list.
		 */
		public function clearList():void
		{
			removeListItems();
		}
		
		/**
		 * The currently selected item in the list.
		 */
		public function get selectedItem():Object
		{
			return _selectedItem.data;
		}
		
		/**
		 * Specifies the display objects to place into the list control. All items should be a 
		 * valid display object and not be added to the stage yet.
		 */
		public function get listItems():Array
		{
			return _listItems;
		}
		
		public function set listItems( v:Array ):void
		{
			removeListItems();
			
			_listItems = v;
			
			if( _listItems )
				addListItems();
		}
		
		
		/**
		 * Specifies if the list items are selectable.
		 */
		public function get selectable():Boolean 
		{
			return _selectable;
		}
		
		public function set selectable( v:Boolean ):void 
		{
			if ( _selectable != v )
			{
				_selectable = v;
				
				if( _listItems )
					configureItemListeners();
			}
		}
		
	}
	
}