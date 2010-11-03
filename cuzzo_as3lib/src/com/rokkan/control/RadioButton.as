/**
 * RadioButton Class
 * @author Matt Wright
 * @version 0.1
 */

package com.rokkan.control 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	/**
	 * The RadioButton control lets the user make a single choice within a set of mutually exclusive choices.
	 */
	public class RadioButton extends Button
	{
		
		private static var BUTTONS:Array = new Array();
		
		private static function onButtonSelect( event:Event ):void
		{
			var button:RadioButton = event.target as RadioButton;
			var group:String = button.group;
			
			for ( var i:Number = 0; i < RadioButton.BUTTONS.length; i++ )
			{
				var btn:RadioButton = RadioButton.BUTTONS[i];
				
				if ( btn.group == group && btn != button )
					btn.deselect();
			}
		}
		
		private static function addButton( button:RadioButton ):void
		{
			RadioButton.BUTTONS.push( button );
			button.addEventListener( Event.SELECT, onButtonSelect );
		}
		
		private var _group:String;
		private var _buttonColor:uint;
		private var _buttonFilters:Array;
		private var _button:Sprite;
		
		/**
		 * Creates a RadioButton control instance.
		 * @param	x	x position of the radio button
		 * @param	y	y position of the radio button
		 * @param	width	Radio button width
		 * @param	height	Radio button height
		 * @param	group	Radio button group
		 * @param	selected	Specifies if the radio button is initially selected
		 * @param	labelText	Radio button label
		 * @param	labelFont	Radio button label font
		 * @param	labelSize	Radio button label font size
		 * @param	labelColor	Radio button label color
		 * @param	baseColor	Radio button base color
		 * @param	outlineColor	Radio button outline color
		 * @param	buttonColor	Radio button dot color
		 */
		public function RadioButton( x:Number, 
								     y:Number, 
								     width:Number = 13,
									 height:Number = 13,
									 group:String = "radio",
									 selected:Boolean = false,
							         labelText:String = "Radio Button", 
								     labelFont:String = "Arial", 
								     labelSize:int = 12, 
								     labelColor:uint = 0x333333,
								     baseColor:uint = 0xCCCCCC,
								     outlineColor:uint = 0x999999,
								     buttonColor:uint = 0xFFFFFF )
 
		{
			RadioButton.addButton( this );
			
			_group = group;
			_buttonColor = buttonColor;
			_buttonFilters = [new DropShadowFilter( 1, 45, 0x000000, 0.5, 0, 0 )];
							
			super( x, y, width, height, labelText, labelFont, labelSize, labelColor, baseColor, outlineColor );
			
			if ( selected ) select();
			else deselect();
		}
		
		
		/* Event Handlers */
		protected function onClick( event:MouseEvent ):void
		{
			select();
		}
		
		
		override protected function addChildren():void
		{
			super.addChildren();
			
			_button = new Sprite();
			_button.filters = _buttonFilters;
			this.addChild( _button );
		}
		
		override protected function positionLabel():void
		{
			_label.x = _base.width + 5;
			_label.y = ( _base.height / 2 ) - ( _label.height / 2 );
		}
		
		override protected function initMouseEvents():void
		{
			super.initMouseEvents();
			addEventListener( MouseEvent.CLICK, onClick );
		}
		
		override protected function killMouseEvents():void
		{
			super.killMouseEvents();
			removeEventListener( MouseEvent.CLICK, onClick );
		}
		
		/**
		 * Redraws the RadioButton control.
		 */
		override public function draw():void
		{
			_base.graphics.clear();
			_base.graphics.beginFill( _baseColor, 1 );
			_base.graphics.drawEllipse( 0, 0, _width, _height );
			_base.graphics.endFill();
			
			var dW:Number = Math.max( 1, _width - 6 );
			var dH:Number = Math.max( 1, _height - 6 );
			
			_button.graphics.clear();
			_button.graphics.beginFill( _buttonColor, 1 );
			_button.graphics.drawEllipse( 0, 0, dW, dH );
			_button.x = 3;
			_button.y = 3;
			
			setLabel();
			positionLabel();
		}
		
		/**
		 * Selects the radio button.
		 */
		override public function select():void
		{
			_selected = true;
			_button.visible = true;
			killMouseEvents();
			notifyButtonSelect();
		}
		
		/**
		 * deselects the radio button.
		 */
		override public function deselect():void
		{
			_selected = false;
			_button.visible = false;
			initMouseEvents();
			notifyButtonCancel();
		}
		
		/**
		 * Specifies the radio button's group.
		 */
		public function get group():String
		{
			return _group;
		}
		
		public function set group( v:String ):void
		{
			_group = v;
		}
		
		
		/* Getter & Setter Overrides */
		/**
		 * The radio button's width.
		 */
		override public function set width( v:Number ):void
		{
			_width = Math.max( 7, v );
			draw();
		}
		
		/**
		 * The radio button's height.
		 */
		override public function set height( v:Number ):void
		{
			_height = Math.max( 7, v );
			draw();
		}
	}
	
}
