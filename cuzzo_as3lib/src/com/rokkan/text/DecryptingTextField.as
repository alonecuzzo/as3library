package com.rokkan.text
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
     * Dispatched after the text has fully decrypted.
     * @eventType flash.events.Event.COMPLETE
     */
	[Event(name="complete",type="flash.events.Event")]
	
	/**
	 * The DecryptingTextField class creates a textfield that "animates" the specified text
	 * using a decrypting effect.
	 */
	public class DecryptingTextField extends TextField
	{
		
		private var _typingTimer:Timer;
		private var _text:String = "";
		private var _keepSpaces:Boolean = false;
		private var _position:int;
		private var _delay:Number = 30;
	
		/**
		 * Creates a DecryptingTextField instance.
		 */
		public function DecryptingTextField()
		{
			super();
			this._typingTimer = new Timer(this.delay);
			this._typingTimer.addEventListener(TimerEvent.TIMER, timerUpdateHandler);
		}
		
		private function timerUpdateHandler(event:TimerEvent):void
		{
			//it might change during the typing
			this._typingTimer.delay = this.delay;
			
			this._position++;
			if(this._position > this._text.length)
			{
				//if we've typed the full text, we can stop
				this._typingTimer.stop();
				this.dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			super.text = this._text.substr(0, this._position) + this.randomChars(this._text.substr(this._position));
		}
		

		private function randomChars(value:String):String
		{
			var result:String = "";
			var count:int = value.length;
			for(var i:int = 0; i < count; i++)
			{
				//for best results on word wrapped textfields,
				//spaces should be kept in the same locations.
				//a monospaced font makes it even better.
				if(this.keepSpaces && value.charAt(i) == " ")
				{
					result += " ";
				}
				else
				{
					result += String.fromCharCode(int(33 + Math.random() * 93));
				}
			}
			return result;
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
		 * Specifies the text.
		 */
		override public function get text():String
		{
			return this._text;
		}
		
		override public function set text(value:String):void
		{
			this._text = value;
			super.text = this.randomChars(value);
			this._position = 0;
			
			if(value.length > 0)
			{
				this._typingTimer.delay = this.delay;
				this._typingTimer.start();
			}
		}
		
		/**
		 * Specifies wether or not to count spaces as a character.
		 */
		public function get keepSpaces():Boolean
		{
			return this._keepSpaces;
		}

		public function set keepSpaces(value:Boolean):void
		{
			this._keepSpaces = value;
		}
		
	}
}
