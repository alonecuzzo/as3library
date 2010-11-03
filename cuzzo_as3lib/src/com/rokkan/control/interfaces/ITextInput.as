package com.rokkan.control.interfaces 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * Defines a set of common properties for a text input component.
	 */
	public interface ITextInput extends IEventDispatcher
	{	
		/**
		 * Text text value. 
		 */
		function get text():String;
		function set text( v:String ):void;	
		
		/**
		 * A string of characters that are allowed in the text input.
		 */
		function get restrict():String;
		function set restrict( v:String ):void;	
		
		/**
		 * The maxmium amount of characters allowed in the text input.
		 */
		function get maxChars():int;
		function set maxChars( v:int ):void;
		
		/**
		 * Equal to <code>true</code> if the text input should conceal the text input.
		 */
		function get displayAsPassword():Boolean;
		function set displayAsPassword( v:Boolean ):void;
	}
	
}