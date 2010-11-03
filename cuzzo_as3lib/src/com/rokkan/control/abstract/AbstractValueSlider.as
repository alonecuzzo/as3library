package com.rokkan.control.abstract 
{
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	/**
	 * The <code>AbstractValueSlider</code> class is a base class to use when creating custom sliders.
	 * The difference between <code>AbstractValueSlider</code> and <code>AbstractSlider</code> is that, 
	 * <code>AbstractValueSlider</code> adds additional functionality to allow the slider to to modify 
	 * a value between a specified range. Whereas <code>AbstractSlider</code> only modifies a value 
	 * between 0 and 1. When extending <code>AbstractValueSlider</code> be sure to supply the super's 
	 * constructor with a reference to your custom class or will receive an IllegalOperationError. 
	 */
	public class AbstractValueSlider extends AbstractSlider
	{
		/**
		 * The distance between the <code>minValue</code> and <code>maxValue</code>.
		 */
		protected var _valueDistance:Number;		
		
		/**
		 * The minimum value of the slider's range.
		 */
		protected var _minValue:Number;
		
		/**
		 * The maximum value of the slider's range.
		 */
		protected var _maxValue:Number;
		
		/**
		 * The current value of the slider.
		 */
		protected var _value:Number;
		
		/**
		 * Creates a new <code>AbstractValueSlider</code> instance
		 * @param	self	A reference to the object/class extending <code>AbstractValueSlider</code>
		 * @throws flash.errors.IllegalOperationError The constructor must receive a reference to
		 * the object/class extending <code>AbstractValueSlider</code>.
		 */
		public function AbstractValueSlider( self:AbstractValueSlider ) 
		{
			super( this );
			
			if ( self != this )
			{
				throw new IllegalOperationError( "AbstractValueSlider did not receive reference to self. " +
					"AbstractValueSlider cannot be instantiated directly and must be extended." );
			}
		}
		
		/**
		 * Place holder method meant to validate the value based on the specified range.
		 * @return The value between the specified range.
		 */
		protected function validateValue( v:Number ):Number
		{
			return Math.max( _minValue, Math.min( _maxValue, v ) );
		}
		
		/**
		 * Specifies the minimum value for the slider.
		 */
		public function get minValue():Number
		{
			return _minValue;
		}
		
		public function set minValue( v:Number ):void
		{
			_minValue = v;
			_valueDistance = _maxValue - _minValue;
		}
		
		/**
		 * Specifies the maximum value for the slider.
		 */
		public function get maxValue():Number
		{
			return _maxValue;
		}
		
		public function set maxValue( v:Number ):void
		{
			_maxValue = v;
			_valueDistance = _maxValue - _minValue;
		}
		
		/**
		 * Specifies the value of the slider between the specified minimum and maxmium values.
		 */
		public function get value():Number
		{
			return _minValue + ( _valueDistance * position );
		}
		
		public function set value( v:Number ):void
		{
			_value = validateValue( v );
			_position = validatePosition( _value - _minValue / _valueDistance );
			moveThumbToPosition();
			notifySliderChange();
		}
		
		/**
		 * Specifies the position of the slider. The position is represented by a number between 0 and 1.
		 */
		override public function set position( v:Number ):void 
		{
			_position = validatePosition( v );
			_value = validateValue( _minValue + ( _maxValue * _position ) );
			moveThumbToPosition();
			notifySliderChange();
		}
		
		
	}
	
}