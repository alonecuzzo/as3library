package com.rokkan.control.abstract 
{
	
	import com.rokkan.control.interfaces.ISlider;
	import com.rokkan.core.UIComponent;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
     * Dispatched when the button is selected.
     * @eventType flash.events.Event.SCROLL
     */
	[Event(name="scroll", type="flash.events.Event")]
	
	/**
	 * The <code>AbstractScrollable</code> class is a base class that can be used for adding scrolling
	 * functionality to a display object. <code>AbstractScrollable</code> utilizes the display object's
	 * <code>scrollRect</code> property to achieve the effect of scrolling. Thus, be aware that if the 
	 * <code>scrollRect</code> property of this object is modified in any other means, scrolling 
	 * ability may be lost.
	 */
	public class AbstractScrollable extends UIComponent
	{
		/**
		 * The scrollable window area of the display object
		 */
		protected var _scrollWindow:Rectangle;
		
		/**
		 * The height of the display object before its <code>scrollRect</code> property is modified.
		 */
		protected var _originalHeight:Number;
		
		/**
		 * The width of the display object before its <code>scrollRect</code> property is modified.
		 */
		protected var _originalWidth:Number;
		
		/**
		 * The vertical scrollbar.
		 */
		protected var _vScrollbar:ISlider;
		
		/**
		 * The horizontal scrollbar.
		 */
		protected var _hScrollbar:ISlider;
		
		/**
		 * Creates a new <code>AbstractScrollable</code> instance
		 * @param	self	A reference to the object/class extending <code>AbstractScrollable</code>
		 * @throws flash.errors.IllegalOperationError The constructor must receive a reference to
		 * the object/class extending <code>AbstractScrollable</code>.
		 */
		public function AbstractScrollable( self:AbstractScrollable ) 
		{
			if ( self != this )
			{
				throw new IllegalOperationError("AbstractScrollable did not receive reference to self. " +
					"AbstractScrollable cannot be instantiated directly and must be extended.");
			}
		}
		
		/**
		 * Utility method which dispatches <code>Event.SCROLL</code> event.
		 */
		protected function notifyScroll():void
		{
			dispatchEvent( new Event( Event.SCROLL ) );
		}
		
		/**
		 * Vertical scrollbar <code>Event.CHANGE</code> event handler.
		 * @param	event	Event object
		 */
		protected function onvScrollbarChange( event:Event ):void
		{
			updateScrollRect( _vScrollbar.position, -1 );
		}
		
		/**
		 * Horizontal scrollbar <code>Event.CHANGE</code> event handler.
		 * @param	event	Event object
		 */
		protected function onhScrollbarChange( event:Event ):void
		{
			updateScrollRect( -1, _hScrollbar.position );
		}
		
		/**
		 * Updates the display object's <code>scrollRect</code> property to give the appearance of scrolling.
		 * @param	vScroll	Vertical scroll position
		 * @param	hScroll	Horizontal scroll position
		 */
		protected function updateScrollRect( vScroll:Number = -1, hScroll:Number = -1 ):void
		{
			if ( this.scrollRect )
			{
				var newScrollRect:Rectangle = this.scrollRect.clone();
				
				if ( vScroll >= 0 )
					newScrollRect.y = ( _originalHeight - this.scrollRect.height ) * vScroll;
					
				if( hScroll >= 0 )
					newScrollRect.x = ( _originalWidth - this.scrollRect.width ) * hScroll;
					
				this.scrollRect = newScrollRect;
				
				notifyScroll();
			}
		}
		
		/**
		 * Sets the vertical scroll position.
		 * @param	position	A number between 0 and 1 specifying the scroll position
		 */
		public function setVScroll( position:Number ):void
		{
			updateScrollRect( position, -1 );
		}
		
		/**
		 * Sets the horizontal scroll position.
		 * @param	position	A number between 0 and 1 specifying the scroll position
		 */
		public function setHScroll( position:Number ):void
		{
			updateScrollRect( -1, position );
		}
		
		/**
		 * The vertical scrollbar. Scrollbar instance must implement the ISlider interface.
		 * @see com.rokkan.control.interfaces.ISlider
		 */
		public function get vScrollbar():ISlider
		{
			return _vScrollbar;
		}
		
		public function set vScrollbar( v:ISlider ):void
		{
			if ( _vScrollbar )
				_vScrollbar.removeEventListener( Event.CHANGE, onvScrollbarChange );
				
			_vScrollbar = v;
			
			if ( _vScrollbar )
			{
				_vScrollbar.addEventListener( Event.CHANGE, onvScrollbarChange );
				onvScrollbarChange( null );
			}
		}
		
		/**
		 * The horizontal scrollbar. Scrollbar instance must implement the ISlider interface.
		 * @see com.rokkan.control.interfaces.ISlider
		 */
		public function get hScrollbar():ISlider
		{
			return _hScrollbar;
		}
		
		public function set hScrollbar( v:ISlider ):void
		{
			if ( _hScrollbar )
				_hScrollbar.removeEventListener( Event.CHANGE, onhScrollbarChange );
				
			_hScrollbar = v;
			
			if ( _hScrollbar )
			{
				_hScrollbar.addEventListener( Event.CHANGE, onhScrollbarChange );
				onhScrollbarChange( null );
			}
		}
		
		/**
		 * The scroll window of the display object.
		 */
		public function get scrollWindow():Rectangle
		{
			return _scrollWindow;
		}
		
		public function set scrollWindow( v:Rectangle ):void 
		{
			this.scrollRect = null;
			_originalHeight = this.height;
			_originalWidth = this.width;
			_scrollWindow = this.scrollRect = v;
		}
		
	}
	
}