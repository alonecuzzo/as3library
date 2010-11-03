package com.rokkan.control 
{
	
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
	
}