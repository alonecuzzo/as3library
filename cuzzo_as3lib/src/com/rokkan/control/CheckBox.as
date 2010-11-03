package com.rokkan.control 
{	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	/**
	 * The CheckBox control consists of a label and a small box that can contain a check mark or not.
	 * The text is always placed to the right of the check box.
	 */
	public class CheckBox extends Button
	{
		
		private var _checkMarkColor:uint;
		private var _checkMarkFilters:Array;
		private var _checkMark:Sprite;
		
		/**
		 * Creates a CheckBox control instance.
		 * @param	x	x position
		 * @param	y	y position
		 * @param	width	Checkbox width
		 * @param	height	Checkbox height
		 * @param	selected	Specifies if the checkbox should be initially selected
		 * @param	labelText	Checkbox label text
		 * @param	labelFont	Checkbox label font
		 * @param	labelSize	Checkbox label font size
		 * @param	labelColor	Checkbox label font color
		 * @param	baseColor	Checkbox base color
		 * @param	outlineColor	Checkbox outline color
		 * @param	checkMarkColor	Checkbox check mark color
		 */
		public function CheckBox( x:Number, 
								  y:Number, 
								  width:Number = 13, 
								  height:Number = 13, 
								  selected:Boolean = false,
							      labelText:String = "Check Box", 
								  labelFont:String = "Arial", 
								  labelSize:int = 12, 
								  labelColor:uint = 0x333333,
								  baseColor:uint = 0xCCCCCC,
								  outlineColor:uint = 0x999999,
								  checkMarkColor:uint = 0xFFFFFF )
		{
			_checkMarkColor = checkMarkColor;
			_checkMarkFilters = [new DropShadowFilter( 1, 45, 0x000000, 0.5, 0, 0 )];
			
			super( x, y, width, height, labelText, labelFont, labelSize, labelColor, baseColor, outlineColor );
			
			if ( selected ) select();
			else deselect();
		}
		
		
		/* Event Handlers */
		protected function onClick( event:MouseEvent ):void
		{
			toggle();
		}
		
		
		/* Protected Overrides */
		override protected function addChildren():void
		{
			super.addChildren();
			_checkMark = new Sprite();
			_checkMark.filters = _checkMarkFilters;
			this.addChild( _checkMark );
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
		 * Redraws the checkbox control.
		 */
		override public function draw():void
		{
			var dW:Number = Math.max( 1, _width - 6 );
			var dH:Number = Math.max( 1, _height - 6 );
			_checkMark.graphics.clear();
			_checkMark.graphics.beginFill( _checkMarkColor, 1 );
			_checkMark.graphics.lineTo( dW, 0 );
			_checkMark.graphics.lineTo( dW, dH );
			_checkMark.graphics.lineTo( 0, dH );
			_checkMark.graphics.lineTo( 0, 0 );
			_checkMark.graphics.endFill();
			_checkMark.x = 3;
			_checkMark.y = 3;
			
			super.draw();
		}
		
		/**
		 * Selects the check box.
		 */
		override public function select():void
		{
			_selected = true;
			_checkMark.visible = true;
			notifyButtonSelect();
		}
		
		/**
		 * Deselects the check box.
		 */
		override public function deselect():void
		{
			_selected = false;
			_checkMark.visible = false;
			notifyButtonCancel();
		}
		
		
		/**
		 * Toggles the check box.
		 */
		public function toggle():void
		{
			if ( _selected ) deselect();
			else select();
		}
		
		
		/**
		 * Specifies the check box width.
		 */
		override public function set width( v:Number ):void
		{
			_width = Math.max( 7, v );
			draw();
		}
		
		/**
		 * Specifies the check box height.
		 */
		override public function set height( v:Number ):void
		{
			_height = Math.max( 7, v );
			draw();
		}
		
	}
	
}
