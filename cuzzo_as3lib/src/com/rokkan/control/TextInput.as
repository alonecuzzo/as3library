package com.rokkan.control 
{
	
	import com.rokkan.control.abstract.AbstractTextInput;
	import com.rokkan.control.interfaces.ITextInput;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * The TextInput control is a single or multiline editable text field. This class also 
	 * serves as an example of how to use the AbstractTextInput class and ITextInput interface.
	 */
	public class TextInput extends AbstractTextInput implements ITextInput
	{
		
		private var _font:String;
		private var _fontSize:int;
		private var _fontColor:uint;
		private var _outlineColor:uint;
		private var _backColor:uint;
		private var _upFilters:Array;
		
		private var _back:Sprite;
		
		/**
		 * Creates a new TextInput control instance.
		 * @param	x	x position of the button
		 * @param	y	y position of the button
		 * @param	width	Button width
		 * @param	height	Button height
		 * @param	multiline	Specifies if the text input should allow for multiple lines
		 * @param	wordWrap	Specifies if the text should wrap within the bounds of the text input
		 * @param	password	Specifies if the text field should conceal the text input
		 * @param	maxChars	Specifies the maxmimum amount of characters that can be input
		 * @param	font	The text input font
		 * @param	fontSize	The text input font size
		 * @param	fontColor	The text input font color
		 * @param	outlineColor	The text input ountline color
		 * @param	backColor	The text input base color
		 */
		public function TextInput( x:Number, 
								   y:Number, 
								   width:Number = 200, 
								   height:Number = 22, 
								   multiline:Boolean = false,
								   wordWrap:Boolean = false,
								   password:Boolean = false,
								   maxChars:int = 0, 
								   font:String = "Arial", 
								   fontSize:int = 12,
								   fontColor:uint = 0x000000,
								   outlineColor:uint = 0x999999,
								   backColor:uint = 0xFFFFFF ) 
		{
			super( this );
			
			_font = font;
			_fontColor = fontColor;
			_fontSize = fontSize;
			_outlineColor = outlineColor;
			_backColor = backColor;
			
			_upFilters = [new GlowFilter( _outlineColor, 1, 2, 2, 10, 1, true ),
						  new DropShadowFilter( 2, 45, _outlineColor, 1, 3, 3, 1.5, 1, true )];
			
			addChildren();
			
			_textField.displayAsPassword = password;
			_textField.embedFonts = false;
			_textField.textColor = _fontColor;
			_textField.wordWrap = wordWrap;
			_textField.multiline = multiline;
			
			_textField.addEventListener( Event.CHANGE, onTextFieldChange );
			_textField.addEventListener( FocusEvent.FOCUS_IN, onTextFieldFocusIn );
			_textField.addEventListener( FocusEvent.FOCUS_OUT, onTextFieldFocusOut );
			
			_width = width;
			_height = height;
			
			this.editable = true;
			this.move( x, y );
			
			draw();
			
			setText();
		}
		
		override protected function onTextFieldChange( event:Event ):void
		{
			_text = _textField.htmlText.replace( new RegExp("<[^>]*>", "gi"), "" );
			setText();
			notifyInputChange();
		}
		
		override protected function addChildren():void 
		{
			_back = new Sprite();
			_back.filters = _upFilters;
			this.addChild( _back );
			
			_textField = new TextField();
			this.addChild( _textField );
		}
		
		/**
		 * Redraws the text input control.
		 */
		override public function draw():void 
		{
			_back.graphics.beginFill( _backColor );
			_back.graphics.lineTo( _width, 0 );
			_back.graphics.lineTo( _width, _height );
			_back.graphics.lineTo( 0, _height );
			_back.graphics.lineTo( 0, 0 );
			_back.graphics.endFill();
			
			_textField.width = _width - 4;
			_textField.height = _height - 2;
			_textField.x = 2;
			_textField.y = 2;
		}
		
		private function setText():void
		{
			_textField.htmlText = '<font face="' + _font + '" size="' + _fontSize + '">' + _text + '</font>';
		}
		
		override public function set text( v:String ):void 
		{
			_text = v;
			setText();
		}
		
	}
	
}