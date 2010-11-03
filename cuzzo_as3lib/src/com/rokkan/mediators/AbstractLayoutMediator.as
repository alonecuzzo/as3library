package com.rokkan.mediators
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.events.FullScreenEvent;
	
	/**
	 * The <code>AbstractLiquidLayoutMediator</code> class helps separate the code for 
	 * adjusting the positions of display objects when the dimensions of the stage/browser
	 * can be changed by the user. This class should be created within the constructor
	 * of a display object and will automatically adjust the positions of items. If any new
	 * child display objects are added during runtime, call the <code>refresh</code> method
	 * to update the display.
	 */
	public class AbstractLayoutMediator extends AbstractEventMediator
	{
		/**
		 * Creates a new AbstractLiquidLayoutMediator instance.
		 * @param	subject	The display object to control.
		 */
		public function AbstractLayoutMediator( subject:DisplayObject ) 
		{
			super( subject );
			
			if ( _subject.stage ) 
				onAddedToStage( null );
			else 
				onRemovedFromStage( null );
		}
		
		private function onAddedToStage( event:Event ):void 
		{
			_subject.removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			
			_subject.addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );
			_subject.stage.addEventListener( Event.RESIZE, onStageResize );
			_subject.stage.addEventListener( FullScreenEvent.FULL_SCREEN, onStageFullScreen );
			
			refresh();
		}
		
		private function onRemovedFromStage( event:Event ):void 
		{
			_subject.removeEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );
			_subject.stage.removeEventListener( Event.RESIZE, onStageResize );
			_subject.stage.removeEventListener( FullScreenEvent.FULL_SCREEN, onStageFullScreen );
			
			_subject.addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		/**
		 * Override with custom layout routine (adjust self and child objects).
		 */
		protected function onStageResize( event:Event ):void 
		{
			
		}
		
		/**
		 * Override with custom layout routine (adjust self and child objects).
		 */
		protected function onStageFullScreen( event:FullScreenEvent ):void 
		{
			
		}
		
		/**
		 * Prepares the mediator for being removed from memory.
		 */
		override public function kill():void
		{
			_subject.removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			_subject.removeEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );
			
			if ( _subject.stage )
			{
				_subject.stage.removeEventListener( Event.RESIZE, onStageResize );
				_subject.stage.removeEventListener( FullScreenEvent.FULL_SCREEN, onStageFullScreen );
			}
			
			super.kill();
		}
		
		/**
		 * Allows for manual refresh of layout.
		 */
		public function refresh():void
		{
			onStageResize( null );
		}
		
	}
	
}