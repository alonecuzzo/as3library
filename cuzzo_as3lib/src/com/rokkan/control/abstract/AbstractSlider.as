package com.rokkan.control.abstract
{
	import com.rokkan.core.UIComponent;
	import com.rokkan.events.SliderEvent;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
     * Dispatched when the position of the slider has changed.
     * @eventType flash.events.Event.CHANGE
     */
	[Event(name="change", type="flash.events.Event")]
	
	/**
     * Dispatched when the slider's thumb has been pressed and is about to start being dragged.
     * @eventType com.rokkan.events.SliderEvent.THUMB_PRESS
     */
	[Event(name = "thumbPress", type = "com.rokkan.events.SliderEvent")]
	
	/**
     * Dispatched when the slider's thumb has been released and is done being dragged.
     * @eventType com.rokkan.events.SliderEvent.THUMB_PRESS
     */
	[Event(name="thumbRelease", type="com.rokkan.events.SliderEvent")]
	
	/**
	 * The <code>AbstractSlider</code> class is a base class to use when creating custom sliders. Most
	 * custom sliders will have unique mouse interactivity and this class is designed with that in mind. 
	 * This class is designed around the assumption that a slider will have a "thumb". The thumb is a
	 * display object that the user is able to click and drag within a specified horizontal or vertical
	 * range. The position of the thumb is then used to calculate a position value between 0 and 1. This
	 * common functionlity has abstracted and provided through protected properties and methods so that 
	 * your custom sliders may make use of them or override them with custom functionality. When extending 
	 * <code>AbstractSlider</code> be sure to supply the super's constructor with a reference to your 
	 * custom class or will receive an IllegalOperationError. 
	 */
	public class AbstractSlider extends UIComponent
	{
		/**
		 * The position value.
		 */
		protected var _position:Number;
		
		/**
		 * The draggable range of the thumb.
		 */
		protected var _dragBounds:Rectangle;
		
		/**
		 * Creates a new <code>AbstractSlider</code> instance
		 * @param	self	A reference to the object/class extending <code>AbstractSlider</code>
		 * @throws flash.errors.IllegalOperationError The constructor must receive a reference to
		 * the object/class extending <code>AbstractSlider</code>.
		 */
		public function AbstractSlider( self:AbstractSlider ) 
		{
			if ( self != this )
			{
				throw new IllegalOperationError("AbstractSlider did not receive reference to self. " +
					"AbstractSlider cannot be instantiated directly and must be extended.");
			}
		}
		
		/**
		 * Utility method which dispatches <code>SliderEvent.THUMB_PRESS</code> event.
		 */
		protected function notifyThumbPress():void
		{
			dispatchEvent( new SliderEvent( SliderEvent.THUMB_PRESS ) );
		}
		
		/**
		 * Utility method which dispatches <code>SliderEvent.THUMB_RELEASE</code> event.
		 */
		protected function notifyThumbRelease():void
		{
			dispatchEvent( new SliderEvent( SliderEvent.THUMB_RELEASE ) );
		}
		
		/**
		 * Utility method which dispatches <code>Event.CHANGE</code> event.
		 */
		protected function notifySliderChange():void
		{
			dispatchEvent( new Event( Event.CHANGE ) );
		}
		
		/**
		 * Abstracted <code>MouseEvent.MOUSE_DOWN</code> event functionality of the slider's thumb. 
		 * Override with custom (dragging) behavior.
		 * @param event MouseEvent object.
		 */
		protected function onThumbMouseDown( event:MouseEvent ):void
		{
			notifyThumbPress();
			if( stage ) stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			if( stage ) stage.addEventListener( MouseEvent.MOUSE_UP, onThumbMouseUp );
		}
		
		/**
		 * Abstracted <code>MouseEvent.MOUSE_UP</code> event functionality of the slider's thumb. 
		 * Override with custom (dragging) behavior.
		 * @param event MouseEvent object.
		 */
		protected function onThumbMouseUp( event:MouseEvent ):void
		{
			notifyThumbRelease();
			if( stage ) stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			if( stage ) stage.removeEventListener( MouseEvent.MOUSE_UP, onThumbMouseUp );
		}
		
		/**
		 * Place holder method. Override with custom behavior.
		 * @param event MouseEvent object.
		 */
		protected function onMouseMove( event:MouseEvent ):void
		{
			
		}
		
		/**
		 * Place holder method. Override with custom behavior.
		 */
		protected function moveThumbToPosition():void
		{
			
		}
		
		/**
		 * Abstracted position calculation. Override with custom calculation.
		 */
		protected function getPositionFromThumb():Number
		{
			return _position;
		}
		
		/**
		 * Utility method that ensures value of position is a number between 0 and 1.
		 * @param	position	A position value
		 * @return	A number between 0 and 1.
		 */
		protected function validatePosition( position:Number ):Number
		{
			return Math.max( 0, Math.min( 1, position ) );
		}
		
		/**
		 * The position of the slider. The position is represented by a number between 0 and 1.
		 */
		public function get position():Number
		{
			return getPositionFromThumb();
		}
		
		public function set position( v:Number ):void
		{
			_position = validatePosition( v );
			moveThumbToPosition();
		}
		
	}
	
}
