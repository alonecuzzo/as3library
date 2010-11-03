/**
* Pixel Class
* @author Chunxi Jiang
* @version 0.1
* under development
*/
package com.rokkan.effects.base
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	public class Pixel
	{
		
		public var color:uint;
		public var vx:Number;
		public var vy:Number;
		public var alpha:Number;
		public var count:Number;
		public var sizeW:uint;
		public var sizeH:uint;
		public var bitmap:Bitmap;
		public var x:Number;
		public var y:Number;
		
		private var _isBitmap:Boolean;
		
		public function Pixel(isBitmap:Boolean) 
		{
			vx = 0;
			vy = 0;
			_isBitmap = isBitmap;
		}
		public function init(xpos:Number, ypos:Number, RGB:uint=0, alpha:Number=1, bm:Bitmap = null):void
		{
			if (_isBitmap)
			{
				this.bitmap = bm;
				this.bitmap.x = xpos;
				this.bitmap.y = ypos;
			}else
			{
				this.x = xpos;
				this.y = ypos;
				this.color = RGB;
				this.alpha = alpha;
			}
		}
		public function update():void
		{
			if (_isBitmap)
			{
				this.bitmap.y += vy;
				this.bitmap.x += vx;
			}else{
				this.y += vy;
				this.x += vx;
			}
		}
		
	}
}