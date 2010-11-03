package com.rokkan.control
{
	
	import com.rokkan.control.interfaces.ISlider;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * The HSlider control lets users modify a value between 0 and 1 by moving a slider 
	 * _thumb between the end points of the slider _track. This class also serves as an
	 * example of how to use the ISlider interface.
	 */
	public class HSlider extends Slider implements ISlider
	{
		
		/**
		 * Creates an HSlider instance.
		 * @param	x	x position
		 * @param	y	y position
		 * @param	width	Slider width
		 * @param	height	Slider height
		 * @param	startPosition	Slider starting position
		 * @param	thumbWidth	Slider _thumb width
		 * @param	thumbHeight	Slider _thumb height
		 * @param	thumbColor	Slider _thumb color
		 * @param	trackColor	Slider _track color
		 * @param	trackOutlineColor	Slider _track color outline
		 */
		public function HSlider( x:Number,
								 y:Number,
								 width:Number = 200,
								 height:Number = 15,
								 startPosition:Number = 0,
								 thumbWidth:Number = 15, 
								 thumbHeight:Number = 15,
								 thumbColor:uint = 0xFFFFFF,
								 trackColor:uint = 0xCCCCCC,
								 trackOutlineColor:uint = 0x999999 ) 
		{
			super( x, y, width, height, thumbWidth, thumbHeight, thumbColor, trackColor, trackOutlineColor );
			
			_dragBounds = new Rectangle( _thumb.x, _thumb.y, width - _thumbWidth, 0 );
			
			position = startPosition;
		}
		
		override protected function getPositionFromThumb():Number 
		{
			return _thumb.x / _dragBounds.width;
		}
		
		override protected function moveThumbToPosition():void
		{
			_thumb.x = _dragBounds.width * _position;
		}
		
		/**
		 * Redraws the slider control.
		 */
		override public function draw():void
		{
			super.draw();
			_thumb.y = -( _thumbHeight - _height ) / 2;
		}
		
	}
	
}
