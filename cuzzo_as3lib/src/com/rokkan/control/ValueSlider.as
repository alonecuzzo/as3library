package com.rokkan.control 
{
	
	import com.rokkan.control.abstract.AbstractValueSlider;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/**
	 * The ValueSlider class is the base class for both the vertical and horizontal 
	 * value slider controls. This class also serves as an example of how to use the 
	 * AbstractValueSlider class.
	 * @see com.rokkan.control.abstract.AbstractValueSlider
	 */
	internal class ValueSlider extends AbstractValueSlider
	{
		
		protected var _thumbWidth:Number;
		protected var _thumbHeight:Number;
		protected var _thumbColor:uint;
		protected var _trackColor:uint;
		protected var _trackOutlineColor:uint;
		protected var _track:Sprite;
		protected var _thumb:Sprite;
		
		/**
		 * Creates a new ValueSlider control instance.
		 * @param	x	x position
		 * @param	y	y position
		 * @param	width	Slider width
		 * @param	height	Slider height
		 * @param	minValue	The minimum value of the slider
		 * @param	maxValue	The maximum value of the slider
		 * @param	thumbWidth	Slider _thumb width
		 * @param	thumbHeight	Slider _thumb height
		 * @param	thumbColor	Slider _thumb color
		 * @param	trackColor	Slider _track color
		 * @param	trackOutlineColor	Slider _track color outline
		 */
		public function ValueSlider( x:Number,
									 y:Number,
									 width:Number,
									 height:Number,
									 minValue:Number,
									 maxValue:Number,
									 thumbWidth:Number, 
									 thumbHeight:Number,
									 thumbColor:uint,
									 trackColor:uint,
									 trackOutlineColor:uint )
		{
			super( this );
			
			this.x = x;
			this.y = y;
			
			_width = width;
			_height = height;
			
			_minValue = minValue;
			_maxValue = maxValue;
			_valueDistance = _maxValue - _minValue;
			
			_thumbHeight = thumbHeight;
			_thumbWidth = thumbWidth;
			_thumbColor = thumbColor;
			_trackColor = trackColor;
			_trackOutlineColor = trackOutlineColor;
			
			addChildren();
			draw();
			
			_thumb.addEventListener( MouseEvent.MOUSE_DOWN, onThumbMouseDown );
		}
		
		override protected function onMouseMove( event:MouseEvent ):void 
		{
			var oldPosition:Number = _position;
			
			_position = validatePosition( getPositionFromThumb() );
			_value = validateValue( _minValue + ( _maxValue * _position ) );
			
			if( oldPosition != position ) notifySliderChange();
		}
		
		override protected function onThumbMouseDown( event:MouseEvent ):void
		{
			super.onThumbMouseDown( event );
			
			_thumb.removeEventListener( MouseEvent.MOUSE_DOWN, onThumbMouseDown );
			_thumb.startDrag( false, _dragBounds );
		}
		
		override protected function onThumbMouseUp( event:MouseEvent ):void
		{
			super.onThumbMouseUp( event );
			
			_thumb.addEventListener( MouseEvent.MOUSE_DOWN, onThumbMouseDown );
			_thumb.stopDrag();
			
			onMouseMove( event );
		}
		
		override protected function addChildren():void
		{
			super.addChildren();
			
			_track = new Sprite();
			_track.filters = [new GlowFilter( _trackOutlineColor, 1, 2, 2, 10, 1, true ),
							 new DropShadowFilter( 2, 45, _trackOutlineColor, 1, 5, 5, 1.5, 1, true )];
			this.addChild( _track );
			
			_thumb = new Sprite();
			_thumb.filters = [new GlowFilter( _trackOutlineColor, 1, 2, 2, 10, 1, true )];
			this.addChild( _thumb );
		}
		
		
		/**
		 * Redraws the value slider control.
		 */
		override public function draw():void
		{
			_track.graphics.clear();
			_track.graphics.beginFill( _trackColor, 1 );
			_track.graphics.lineTo( _width, 0 );
			_track.graphics.lineTo( _width, _height );
			_track.graphics.lineTo( 0, _height );
			_track.graphics.lineTo( 0, 0 );
			_track.graphics.endFill();
			
			_thumb.graphics.clear();
			_thumb.graphics.beginFill( _thumbColor, 1 );
			_thumb.graphics.lineTo( _thumbWidth, 0 );
			_thumb.graphics.lineTo( _thumbWidth, _thumbHeight );
			_thumb.graphics.lineTo( 0, _thumbHeight );
			_thumb.graphics.lineTo( 0, 0 );
			_thumb.buttonMode = true;
		}
		
	}
	
}
