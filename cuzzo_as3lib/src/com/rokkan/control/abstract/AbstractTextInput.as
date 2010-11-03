package com.rokkan.control.abstract 
{
	
	import com.rokkan.core.UIComponent;
	import com.rokkan.events.GenericEvent;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	/**
     * Dispatched when the text has changed.
     * @eventType flash.events.Event.CHANGE
     */
	[Event(name="change", type="flash.events.Event")]
	
	/**
     * Dispatched when the text input gains focus.
     * @eventType flash.events.FocusEvent.FOCUS_IN
     */
	[Event(name="focusIn", type="flash.events.FocusEvent")]
	
	/**
     * Dispatched when the text input loses focus.
     * @eventType flash.events.FocusEvent.FOCUS_OUT
     */
	[Event(name="focusOut", type="flash.events.FocusEvent")]
	
	/**
     * Dispatched when the user presses the ENTER button on their keyboard and the TextInput has focus .
     * @eventType flash.events.Event.CHANGE
     */
	[Event(name="enter", type="com.rokkan.events.GenericEvent")]
	
	/**
	 * The <code>AbstractTextInput</code> class is a base class to use when creating custom text inputs. 
	 * This class is designed around the assumption that a text input will have, at the bare minimum, one
	 * text field that allows the user to input text. Common functionlity has abstracted and provided 
	 * through protected properties and methods so that your custom text input may make use of them or 
	 * override them with custom functionality. When extending <code>AbstractTextInput</code> be sure to 
	 * supply the super's constructor with a reference to your custom class or will receive an IllegalOperationError. 
	 */
	public class AbstractTextInput extends UIComponent
	{
		/**
		 * The text value.
		 */
		protected var _text:String = "";
		
		/**
		 * The user input text field.
		 */
		protected var _textField:TextField;
		
		/**
		 * Creates a new <code>AbstractTextInput</code> instance
		 * @param	self	A reference to the object/class extending <code>AbstractTextInput</code>
		 * @throws flash.errors.IllegalOperationError The constructor must receive a reference to
		 * the object/class extending <code>AbstractTextInput</code>.
		 */
		public function AbstractTextInput( self:AbstractTextInput ) 
		{
			if ( self != this )
			{
				throw new IllegalOperationError( "AbstractTextInput did not receive reference to self. " +
					"AbstractTextInput cannot be instantiated directly and must be extended." );
			}
		}
		
		/**
		 * Utility method which dispatches <code>Event.CHANGE</code> event.
		 */
		protected function notifyInputChange():void
		{
			dispatchEvent( new Event( Event.CHANGE ) );
		}
		
		/**
		 * Utility method which dispatches <code>GenericEvent.ENTER</code> event.
		 */
		protected function notifyEnterButton():void
		{
			dispatchEvent( new GenericEvent( GenericEvent.ENTER ) );
		}
		
		/**
		 * Abstracted <code>Event.CHANGE</code> event functionality of the text field. 
		 * Override with custom behavior. Note: By default, the text field is not configued 
		 * with this event handler. You must add it yourself.
		 * @param event Event object.
		 */
		protected function onTextFieldChange( event:Event ):void
		{
			_text = _textField.text;
			notifyInputChange();
		}
		
		/**
		 * Abstracted <code>FocusEvent.FOCUS_IN</code> event functionality of the text field. 
		 * Override with custom behavior. Note: By default, the text field is not configued 
		 * with this event handler. You must add it yourself.
		 * @param event FocusEvent object.
		 */
		protected function onTextFieldFocusIn( event:FocusEvent ):void
		{
			this.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
			dispatchEvent( event.clone() );
		}
		
		/**
		 * Abstracted <code>FocusEvent.FOCUS_OUT</code> event functionality of the text field. 
		 * Override with custom behavior. Note: By default, the text field is not configued 
		 * with this event handler. You must add it yourself.
		 * @param event FocusEvent object.
		 */
		protected function onTextFieldFocusOut( event:FocusEvent ):void
		{
			this.removeEventListener( KeyboardEvent.KEY_UP, onKeyUp );
			dispatchEvent( event.clone() );
		}
		
		/**
		 * Abstracted <code>KeyboardEvent.KEY_UP</code> event functionality. This event handler
		 * becomes active only when the text field gains focus to manage the dispatching of a
		 * <code>GenericEvent.ENTER</code> event. Override with custom behavior.
		 * @param event KeyboardEvent object.
		 */
		protected function onKeyUp( event:KeyboardEvent ):void
		{
			if ( event.charCode == Keyboard.ENTER )
			{
				notifyEnterButton();
			}
		}
		
		/**
		 * Text text value. This value should be void of HTML tags.
		 */
		public function get text():String
		{
			return _text;
		}
		
		public function set text( v:String ):void
		{
			_text = _textField.text = v;
		}
		
		/**
		 * A string of characters that are allowed in the text input.
		 */
		public function get restrict():String
		{
			return _textField.restrict;
		}
		
		public function set restrict( v:String ):void
		{
			_textField.restrict = v;
		}
		
		/**
		 * The maxmium amount of characters allowed in the text input.
		 */
		public function get maxChars():int
		{
			return _textField.maxChars;
		}
		
		public function set maxChars( v:int ):void
		{
			_textField.maxChars = v;
		}
		
		/**
		 * Equal to <code>true</code> if the text input should conceal the text input.
		 */
		public function get displayAsPassword():Boolean
		{
			return _textField.displayAsPassword;
		}
		
		public function set displayAsPassword( v:Boolean):void
		{
			_textField.displayAsPassword = v;
		}
		
		/**
		 * Equal to <code>true</code> if the text input should render the text using embedded fonts.
		 */
		public function get embedFonts():Boolean
		{
			return _textField.embedFonts;
		}
		
		public function set embedFonts( v:Boolean ):void
		{
			_textField.embedFonts = v;
		}
		
		/**
		 * The default <code>TextFormat</code> object for the text input.
		 */
		public function get textFormat():TextFormat
		{
			return _textField.defaultTextFormat;
		}
		
		public function set textFormat( v:TextFormat ):void
		{
			_textField.defaultTextFormat = v;
		}
		
		/**
		 * Equal to <code>true</code> if the text input is editable.
		 */
		public function get editable():Boolean
		{
			return ( TextFieldType.INPUT ) ? true : false;
		}
		
		public function set editable( v:Boolean ):void
		{
			_textField.type = ( v ) ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
		}
		
		/**
		 * Equal to <code>true</code> if the text input is selectedable.
		 */
		public function get selectable():Boolean
		{
			return _textField.selectable;
		}
		
		public function set selectable( v:Boolean ):void
		{
			_textField.selectable = ( v ) ? true : false;
		}
		
	}
	
}