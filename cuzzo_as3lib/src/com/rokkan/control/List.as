package com.rokkan.control 
{
	
	import com.rokkan.control.abstract.AbstractList;
	import com.rokkan.control.interfaces.IList;
	import flash.display.DisplayObject;
	
	/**
	 * The List control creates a container for a specified group of items.It also serves
	 * as an example of how to use the AbstractList class.
	 */
	public class List extends AbstractList implements IList
	{
		
		private var _itemMargin:Number;
		
		/**
		 * Creates a new List control instance.
		 * @param	x	x position
		 * @param	y	y position
		 * @param	listItems	Array of items that have not been added to the stage yet
		 * @param	selectable	Sepcifies if the list items are selectable or not
		 * @param	itemMargin	The space to place between each item in the list
		 */
		public function List( x:Number,
							  y:Number,
							  listItems:Array,
							  selectable:Boolean = true,
							  itemMargin:Number = 0 ) 
		{
			super( this );
			
			move( x, y );
			
			this.itemMargin = itemMargin;
			this.listItems = listItems;
			this.selectable = selectable;
		}
		
		private function adjustMargin():void
		{
			var nextY:Number = 0;
			for ( var i:int = 0; i < listItems.length; i++ )
			{
				DisplayObject( listItems[i] ).y = nextY;
				nextY += DisplayObject( listItems[i] ).height + itemMargin;
			}
		}
		
		/**
		 * Specifies the space to place between each item in the list.
		 */
		public function get itemMargin():Number
		{
			return _itemMargin;
		}
		
		public function set itemMargin( v:Number ):void
		{
			_itemMargin = v;
			
			if( _listItems )
				adjustMargin();
		}
		
		
	}
	
}
/*
import com.rokkan.control.interfaces.IButton;
import com.rokkan.control.interfaces.IListItem;

public class ListItem extends Button implements IListItem
{
	
	private var _data:Object;
	
	public function ListItem( x:Number, 
							  y:Number, 
							  width:Number = 150, 
							  height:Number = 20, 
							  labelText:String = "Button", 
							  labelFont:String = "Arial", 
							  labelSize:int = 10, 
							  labelColor:uint = 0x333333,
							  baseColor:uint = 0xCCCCCC,
							  outlineColor:uint = 0x999999 ) 
	{
		super( x, y, width, height, labelText, labelFont, labelSize, labelColor, baseColor, outlineColor );
	}
	
	public function get data():Object
	{
		return _data;
	}
	
	public function set data( v:Object ):void
	{
		_data = v;
	}
}
*/