package com.rokkan.control 
{
	import com.rokkan.control.abstract.AbstractButton;
	import com.rokkan.control.interfaces.IButton;
	import com.rokkan.core.UIComponent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * The Button control is a generic, square button with a text label. The label text
	 * is always centered both horizontally and vertically within the shape of the button.
	 * This class also serves as an example of how to use the AbstractButton class and the
	 * IButton interface.
	 */
	public class Button extends AbstractButton implements IButton
	{

		protected var _labelText:String;
		protected var _labelColor:uint;
		protected var _labelFont:String;
		protected var _labelSize:int;
		protected var _baseColor:uint;
		protected var _outlineColor:uint;
		protected var _upFilters:Array;
		protected var _overFilters:Array;
		protected var _downFilters:Array;
		protected var _label:TextField
		protected var _base:Sprite;
		
		/**
		 * Creates a Button control instance.
		 * @param	x	x position of the button
		 * @param	y	y position of the button
		 * @param	width	Button width
		 * @param	height	Button height
		 * @param	labelText	Button label
		 * @param	labelFont	Button label font
		 * @param	labelSize	Button label font size
		 * @param	labelColor	Button label color
		 * @param	baseColor	Button base color
		 * @param	outlineColor	Button outline color
		 */
		public function Button( x:Number, 
								y:Number, 
								width:Number = 100, 
								height:Number = 30, 
							    labelText:String = "Button", 
								labelFont:String = "Arial", 
								labelSize:int = 12, 
								labelColor:uint = 0x333333, 
								baseColor:uint = 0xCCCCCC,
								outlineColor:uint = 0x999999) 
		{
			super( this );
			
			_labelText = labelText;
			_labelFont = labelFont;
			_labelSize = labelSize;
			_labelColor = labelColor;
			_baseColor = baseColor;
			_outlineColor = outlineColor;
			
			_upFilters = [new GlowFilter( _outlineColor, 1, 2, 2, 10, 1, true )];
			_overFilters = [new GlowFilter( _outlineColor, 1, 2, 2, 10, 1, true )];
			_downFilters = [new GlowFilter( _outlineColor, 1, 2, 2, 10, 1, true ),
							new DropShadowFilter( 2, 45, _outlineColor, 1, 5, 5, 1.5, 1, true )];
			
			addChildren();
			
			_width = width;
			_height = height;
			
			this.move( x, y );
			
			draw();
			
			enable();
		}
		
		
		/* Event Handlers */
		override protected function onRollOver( event:MouseEvent ):void
		{
			super.onRollOver( event );
			_base.filters = _overFilters;
		}
		
		override protected function onRollOut( event:MouseEvent ):void
		{
			super.onRollOut( event );
			_base.filters = _upFilters;
		}
		
		override protected function onMouseDown( event:MouseEvent ):void
		{
			super.onMouseDown( event );
			_base.filters = _downFilters;
		}
		
		override protected function onMouseUp( event:MouseEvent ):void
		{
			super.onMouseUp( event );
			_base.filters = _upFilters;
		}
		
		
		/* Protected Overrides */
		
		override protected function addChildren():void
		{
			_base = new Sprite();
			_base.filters = _upFilters;
			this.addChild( _base );
			
			_label = new TextField();
			this.addChild( _label );
		}
		
		
		/* Protected Methods */
		
		protected function setLabel():void
		{
			_label.embedFonts = false;
			_label.selectable = false;
			_label.textColor = _labelColor;
			_label.autoSize = TextFieldAutoSize.LEFT;
			_label.wordWrap = false;
			_label.multiline = false;
			_label.htmlText = '<font face="' + _labelFont + '" size="' + _labelSize + '">' + _labelText + '</font>';
		}
		
		protected function positionLabel():void
		{
			_label.x = ( _base.width / 2 ) - ( _label.width / 2 );
			_label.y = ( _base.height / 2 ) - ( _label.height / 2 );
		}
		
		
		/**
		 * Redraws the button control.
		 */
		override public function draw():void
		{
			_base.graphics.clear();
			_base.graphics.beginFill( _baseColor, 1 );
			_base.graphics.lineTo( _width, 0 );
			_base.graphics.lineTo( _width, _height );
			_base.graphics.lineTo( 0, _height );
			_base.graphics.lineTo( 0, 0 );
			_base.graphics.endFill();
			
			setLabel();
			positionLabel();
		}
		
		/**
		 * Selects the button.
		 */
		override public function select():void
		{
			super.select();
			disable();
		}
		
		/**
		 * Deselects the button.
		 */
		override public function deselect():void
		{
			super.deselect();
			enable();
		}

		
		/**
		 * Specifies the label text.
		 */
		public function get labelText():String
		{
			return _labelText;
		}
		
		public function set labelText( v:String ):void
		{
			_labelText = v;
			draw();
		}
		
	}
	
}
