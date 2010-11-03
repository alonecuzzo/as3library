package com.rokkan.control
{
	
	import com.rokkan.control.interfaces.ISlider;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * The HSlider control lets users modify a value between 0 and 1 by moving a slider 
	 * _thumb between the end points of the slider _track.
	 */
	public class VSlider extends Slider implements ISlider
	{
		
		/**
		 * Creates an VSlider instance.
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
		public function VSlider( x:Number,
								 y:Number,
								 width:Number = 15,
								 height:Number = 200,
								 startPosition:Number = 0,
								 thumbWidth:Number = 15, 
								 thumbHeight:Number = 15,
								 thumbColor:uint = 0xFFFFFF,
								 trackColor:uint = 0xCCCCCC,
								 trackOutlineColor:uint = 0x999999 ) 
		{
			super( x, y, width, height, thumbWidth, thumbHeight, thumbColor, trackColor, trackOutlineColor );
			
			_dragBounds = new Rectangle( _thumb.x, _thumb.y, 0, height - _thumbHeight );
			
			position = startPosition;
		}
		
		override protected function getPositionFromThumb():Number 
		{
			return _thumb.y / _dragBounds.height;
		}
		
		override protected function moveThumbToPosition():void
		{
			_thumb.y = _dragBounds.height * _position;
		}
		
		/**
		 * Redraws the slider control.
		 */
		override public function draw():void
		{
			super.draw();
			_thumb.x = -( _thumbWidth - _width ) / 2;
		}
		
	}
	
}
