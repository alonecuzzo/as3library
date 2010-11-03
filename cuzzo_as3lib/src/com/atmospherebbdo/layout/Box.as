package com.atmospherebbdo.layout 
{
	import com.atmospherebbdo.dbc.precondition;
	import com.atmospherebbdo.layout.ILayoutStrategy;
	import com.atmospherebbdo.util.IDestroyable;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventPhase;	

	/**
	 * @author mark hawley
	 * 
	 * A basic sprite that performs layout of its children as they
	 * are added or removed.
	 */
	public class Box extends Sprite implements IDestroyable
	{
		private var layoutManager:ILayoutStrategy;
		
		private var _isDestroyed:Boolean = false;
		
		/**
		 * Constructor.
		 * 
		 * @param layout	ILayoutStrategy
		 */
		public function Box( layout:ILayoutStrategy )
		{
			layoutManager = layout;
			addEventListener(Event.ADDED, onAdded, false, 0, true);			addEventListener(Event.REMOVED, onRemoved, false, 0, true);
		}
		
		public function destroy() :void
		{
			precondition(!isDestroyed());
			
			layoutManager = null;
			
			_isDestroyed = true;
		}
		
		/**
		 * Discards all children of the box.
		 */
		public function empty() :void
		{
			precondition(!isDestroyed());
			
			while ( numChildren > 0 )
			{
				removeChildAt( numChildren - 1 );
			}
		}

		public function performLayout() :void
		{
			precondition(!isDestroyed());
			
			layoutManager.layout(this);
		}
		
		/**
		 * 
		 */
		private function onAdded(event:Event) :void
		{
			if (event.eventPhase == EventPhase.AT_TARGET)
			{
				performLayout();
			}
		}
		
		/**
		 * 
		 */
		private function onRemoved(event:Event) :void
		{
			if (event.eventPhase == EventPhase.AT_TARGET)
			{
				performLayout();
			}
		}				public function isDestroyed():Boolean		{
			return _isDestroyed;
		}
	}
}
