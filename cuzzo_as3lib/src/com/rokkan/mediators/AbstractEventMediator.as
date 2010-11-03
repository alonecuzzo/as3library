package com.rokkan.mediators 
{
	
	public class AbstractEventMediator 
	{
		
		private var _subject:Object;
		
		public function AbstractEventMediator( subject:Object ) 
		{
			_subject = subject;
		}
		
		/**
		 * Prepares the mediator for being removed from memory.
		 */
		public function kill():void
		{
			_subject = null;
		}
		
		/**
		 * The mediator's subject.
		 */
		public function get subject():Object  
		{
			return _subject;
		}
		
		public function set subject( value:Object ):void 
		{
			_subject = value;
		}
		
	}
	
}