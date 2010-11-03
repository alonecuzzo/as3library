package com.atmospherebbdo.log
{
	import com.atmospherebbdo.dbc.precondition;	import com.atmospherebbdo.log.LogMessage;		import flash.display.DisplayObject;	import flash.display.Stage;	import flash.text.TextField;	
	/**
	 * Simple LogDestination that sends messages to a text field hovering over
	 * the Stage. Not recommended for use in anything non-trivial.
	 * 
	 * @author hawleym
	 */
	public class DebugTextFieldDestination implements ILogDestination
	{
		private static var debugField:TextField = null;
		
		/**
		 * Constructor.
		 */
		public function DebugTextFieldDestination( display:DisplayObject ) 
		{
			precondition(display.stage != null, "Must have a stage reference.");
			
			// only at most one field is desired
			if (debugField)
			{
				return;
			}
			
			debugField = new TextField();
			debugField.width = 744;
			debugField.height = 510;
			debugField.multiline = true;
			debugField.wordWrap = true;
			debugField.selectable = false;
			debugField.mouseEnabled = false;
			display.stage.addChild(debugField);
			
			var message:LogMessage = new LogMessage();
			message.level = LogLevel.INFO;
			message.message = "Created DebugTextFieldDestination: " + debugField.width + " x " + debugField.height;
			message.origin = "NONE";
			message.time = new Date();
			log(message);	
		}
		
		/**
		 * Simple log method, appending to text field.
		 * 
		 * @param	message	Object
		 */
		public function log( message:LogMessage ) :void
		{
			debugField.appendText(message + "\n");
			debugField.scrollV = debugField.maxScrollV;
		}
	}
}