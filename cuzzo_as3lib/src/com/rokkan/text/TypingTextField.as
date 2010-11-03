package com.rokkan.text
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;

	/**
     * Dispatched after the text has finished typing.
     * @eventType flash.events.Event.COMPLETE
     */
	[Event(name="complete",type="flash.events.Event")]
	
	/**
	 * The TypingTextField class creates a textfield that "animates" the specified text
	 * using a keyboard typing effect.
	 */
	public class TypingTextField extends TextField
	{
	
		private var _typingTimer:Timer;
		private var _position:int;
		private var _cursorOn:Boolean = true;
		private var _delay:Number = 25;
		private var _showBlinkingCursor:Boolean = true;
		private var _cursorText:String = "_";
		private var _text:String = "";
		
		/**
		 * Creates a new TypingTextField instance.
		 */
		public function TypingTextField()
		{
			super();
			this._typingTimer = new Timer( this.delay );
			this._typingTimer.addEventListener( TimerEvent.TIMER, onTimer );
		}
		
		private function onTimer( event:TimerEvent ):void
		{
			//it might change during the typing
			this._typingTimer.delay = this.delay;
			
			this._position++;
			if(this._position > this._text.length)
			{
				//if we've typed the full text, we can stop
				super.text = this._text; //make sure the cursor is gone!
				this._typingTimer.stop();
				this.dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			
			this._cursorOn = !this._cursorOn;
			
			super.text = this._text.substr(0, this._position) + (this._showBlinkingCursor && this._cursorOn ? this._cursorText : "");
		}
		
		/**
		 * Specifies the delay to decrypt the characters.
		 */
		public function get delay():Number
		{
			return this._delay;
		}
		
		public function set delay(value:Number):void
		{
			this._delay = value;
		}
		
		/**
		 * Specifies wether or not to show a blinking cursor.
		 */
		public function get showBlinkingCursor():Boolean
		{
			return this._showBlinkingCursor;
		}
		
		public function set showBlinkingCursor(value:Boolean):void
		{
			this._showBlinkingCursor = value;
		}
		
		/**
		 * Specifies the cursor text.
		 */
		public function get cursorText():String
		{
			return this._cursorText;
		}
		
		public function set cursorText(value:String):void
		{
			this._cursorText = value;
		}
		
		/**
		 * Specifies the text.
		 */
		override public function get text():String
		{
			return this._text;
		}
		
		override public function set text( value:String ):void
		{
			if(this._showBlinkingCursor && value.length > 0)
			{
				super.text = this.cursorText;
			}
			else super.text = "";
			this._position = 0;
			this._text = value;
			if(value.length > 0)
			{
				this._typingTimer.delay = this.delay;
				this._typingTimer.start();
			}
		}
	}
}
