package com.rokkan.control.abstract 
{
	
	import com.rokkan.control.interfaces.IButton;
	import com.rokkan.core.UIComponent;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
     * Dispatched when the button is selected.
     * @eventType flash.events.Event.SELECT
     */
	[Event(name="select", type="flash.events.Event")]
	
	/**
     * Dispatched when the button is deselected.
     * @eventType flash.events.Event.CANCEL
     */
	[Event(name="cancel", type="flash.events.Event")]
	
	/**
	 * The <code>AbstractButton</code> class is a base class to be used when creating custom buttons. Most
	 * custom buttons will have unique mouse interactivity and this class is designed with that in mind. 
	 * Common button behavior has been abstracted and provided through protected properties and methods 
	 * so that your custom button may make use of them or override them with custom functionality. In
	 * most cases a custom button simply needs to override the <code>onRollOver</code> and 
	 * <code>onRollOut</code> methods. If the button is meant to be selectable, override the 
	 * <code>select</code> method as well. When extending <code>AbstractButton</code> be sure to supply 
	 * the super's constructor with a reference to your custom class or will receive an IllegalOperationError. 
	 * 
	 * @example <div class="listing"><pre>package
	 * {
	 *     import com.rokkan.control.abstract.AbstractButton
	 *     import flash.display.Sprite;
	 * 
	 *     class CustomButton extends AbstractButton
	 *     {
	 * 
	 *         public var back:Sprite
	 *         
	 *         public function CustomButton()
	 *         {
	 *             super( this );
	 *             back = new Sprite();
	 *             back.graphics.beginFill( 0x000000, 1 );
	 *             back.graphics.lineTo( 50, 0 );
	 *             back.graphics.lineTo( 50, 20 );
	 *             back.graphics.lineTo( 0, 20 );
	 *             back.graphics.lineTo( 0, 0 );
	 *             back.graphics.endFill();
	 *             this.addChild( back );
	 *         }
	 * 
	 *         override protected function onRollOver( event:MouseEvent ):void
	 *         {
	 *             super.onRollOver( event );
	 *             back.alpha = 0.5;
	 *         }
	 * 
	 *         override protected function onRollOut( event:MouseEvent ):void
	 *         {
	 *             super.onRollOut( event );
	 *             back.alpha = 1;
	 *         }
	 *     }
	 * }</div></pre>
	 */
	public class AbstractButton extends UIComponent
	{
		
		/**
		 * String representing the <code>UP</code> state of the button. A button is considered in 
		 * the <code>UP</code> state when the user's mouse is not within the bounds of the button.
		 */
		public static var UP:String = "up";
		
		/**
		 * String representing the <code>OVER</code> state of the button. A button is considered in 
		 * the <code>OVER</code> state when the user's mouse is over the button and the user's mouse
		 * button is not being pressed.
		 */
		public static var OVER:String = "over";
		
		/**
		 * String representing the <code>DOWN</code> state of the button. A button is considered in 
		 * the <code>DOWN</code> state when the user is pressing their mouse button over the button.
		 */
		public static var DOWN:String = "down";
		
		/**
		 * The enabled state.
		 * @default true
		 */
		protected var _enabled:Boolean = true;
		
		/**
		 * The selected state.
		 * @default false
		 */
		protected var _selected:Boolean = false;
		
		/**
		 * The button state.
		 * @default AbstractButton.UP
		 */
		protected var _state:String = AbstractButton.UP;
		
		/**
		 * Creates a new <code>AbstractButton</code> instance
		 * @param	self	A reference to the object/class extending <code>AbstractButton</code>
		 * @throws flash.errors.IllegalOperationError The constructor must receive a reference to
		 * the object/class extending <code>AbstractButton</code>.
		 */
		public function AbstractButton( self:AbstractButton ) 
		{
			if ( self != this )
			{
				throw new IllegalOperationError("AbstractButton did not receive reference to self. " +
					"AbstractButton cannot be instantiated directly and must be extended.");
			}
			
			mouseEnabled = false;
			initMouseEvents();
		}
		
		/**
		 * Utility method which dispatches <code>Event.SELECT</code> event.
		 */
		protected function notifyButtonSelect():void
		{
			dispatchEvent( new Event( Event.SELECT ) );
		}
		
		/**
		 * Utility method which dispatches <code>Event.CANCEL</code> event.
		 */
		protected function notifyButtonCancel():void
		{
			dispatchEvent( new Event( Event.CANCEL ) );
		}
		
		/**
		 * Abstracted <code>MouseEvent.ROLL_OVER</code> event functionality. Override with custom roll over behavior.
		 * @param	event	MouseEvent object
		 */
		protected function onRollOver( event:MouseEvent ):void
		{
			_state = AbstractButton.OVER;
			addEventListener( MouseEvent.ROLL_OUT, onRollOut );
		}
		
		/**
		 * Abstracted <code>MouseEvent.ROLL_OUT</code> event functionality. Override with custom roll out behavior.
		 * @param	event	MouseEvent object
		 */
		protected function onRollOut( event:MouseEvent ):void
		{
			_state = AbstractButton.UP;
			removeEventListener( MouseEvent.ROLL_OUT, onRollOut );
		}
		
		/**
		 * Abstracted <code>MouseEvent.MOUSE_DOWN</code> event functionality. Override with custom mouse down behavior.
		 * @param	event	MouseEvent object
		 */
		protected function onMouseDown( event:MouseEvent ):void
		{
			_state = AbstractButton.DOWN;
			removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			
			addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUpOutside );
		}
		
		/**
		 * Abstracted <code>MouseEvent.MOUSE_UP</code> event functionality. Override with custom mouse up behavior.
		 * @param	event	MouseEvent object
		 */
		protected function onMouseUp( event:MouseEvent ):void
		{
			_state = AbstractButton.UP;
			
			removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseUpOutside );
			
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		}
		
		/**
		 * Abstracted event functionality for when the users's cursor moves outside the button and the mouse button 
		 * is released. Override with custom mouse down behavior.
		 * @param	event	MouseEvent object
		 */
		protected function onMouseUpOutside( event:MouseEvent ):void 
		{
			removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		}
		
		/**
		 * Activates mouse events for the button.
		 */
		protected function initMouseEvents():void
		{
			if ( !mouseEnabled )
			{
				addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
				addEventListener( MouseEvent.ROLL_OVER, onRollOver );
				buttonMode = mouseEnabled = true;
			}
		}
		
		/**
		 * Deactivates mouse events for the button.
		 */
		protected function killMouseEvents():void
		{
			if ( mouseEnabled )
			{
				removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
				removeEventListener( MouseEvent.ROLL_OVER, onRollOver );
				removeEventListener( MouseEvent.ROLL_OUT, onRollOut );
				if( stage ) stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
				buttonMode = mouseEnabled = false;
			}
		}
		
		/**
		 * Selects the button.
		 */
		public function select():void
		{
			_selected = true;
			notifyButtonSelect();
		}
		
		/**
		 * Deselects the button.
		 */
		public function deselect():void
		{
			_selected = false;
			notifyButtonCancel();
		}
		
		/**
		 * Enables the button and activates mouse events.
		 */
		public function enable():void
		{
			_enabled = true;
			initMouseEvents();
		}
		
		/**
		 * Disables the button and deactivates mouse events.
		 */
		public function disable():void
		{
			_enabled = false;
			killMouseEvents();
		}
		
		/**
		 * Is equal to <code>true</code> if the button is enabled and vice versa.
		 */
		public function get isEnabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * Is equal to <code>true</code> if the button is selected and vice versa.
		 */
		public function get isSelected():Boolean
		{
			return _selected;
		}
		
		/**
		 * A string representing the state of the button. The button's state is equal to one 
		 * of three values: <code>AbstractButton.UP</code>, <code>AbstractButton.OVER</code>
		 * or <code>AbstractButton.DOWN</code>.
		 */
		public function get state():String
		{
			return _state;
		}
		
		public function destroy():void
		{
			killMouseEvents();
		}
	}
	
}
