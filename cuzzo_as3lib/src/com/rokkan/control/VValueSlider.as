/**
 * Slider Class
 * @author Matt Wright
 * @version 0.1
 */

package com.rokkan.control
{
	
	import com.rokkan.control.interfaces.ISlider;
	import com.rokkan.control.interfaces.IValueSlider;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * The HSlider control lets users modify a value between a specified minimum and
	 * maxmium value by moving the slider _thumb between the end points of a vertical 
	 * slider _track. This class also serves as an example of how to use the ISlider and
	 * IValueSlider interfaces.
	 */
	public class VValueSlider extends ValueSlider implements ISlider, IValueSlider
	{
		
		/**
		 * Creates an VValueSlider instance.
		 * @param	x	x position
		 * @param	y	y position
		 * @param	width	Slider width
		 * @param	height	Slider height
		 * @param	minValue	Minimum value
		 * @param	maxValue	Maximum value
		 * @param	startPosition	Slider starting position
		 * @param	thumbWidth	Slider _thumb width
		 * @param	thumbHeight	Slider _thumb height
		 * @param	thumbColor	Slider _thumb color
		 * @param	trackColor	Slider _track color
		 * @param	trackOutlineColor	Slider _track color outline
		 */
		public function VValueSlider( x:Number,
									  y:Number,
									  width:Number = 15,
									  height:Number = 200,
									  minValue:Number = 0,
									  maxValue:Number = 1,
									  startValue:Number = 0,
									  thumbWidth:Number = 15, 
									  thumbHeight:Number = 15,
									  thumbColor:uint = 0xFFFFFF,
									  trackColor:uint = 0xCCCCCC,
									  trackOutlineColor:uint = 0x999999 ) 
		{
			super( x, y, width, height, minValue, maxValue, thumbWidth, thumbHeight, thumbColor, trackColor, trackOutlineColor );
			
			_dragBounds = new Rectangle( _thumb.x, _thumb.y, 0, height - _thumbHeight );
			
			value = startValue;
		}
		
		override protected function getPositionFromThumb():Number 
		{
			return _thumb.y / _dragBounds.height;
		}
		
		override protected function moveThumbToPosition():void
		{
			_thumb.x = _dragBounds.height * _position;
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
