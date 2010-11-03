/**
* Pixelate Class
* @author Chunxi Jiang
* @version 0.1
* under development
*/

package com.rokkan.effects 
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.MovieClip;
	import com.rokkan.tween.TweenLite;
	import com.rokkan.tween.easing.Elastic;
	import com.rokkan.effects.base.Pixel;
	import flash.geom.Matrix;
	public class Pixelate 
	{
		public var pixels:Array;
		public var _pic:Sprite;
		private var _con:Sprite;
		public var H:uint;
		public var W:uint;
		private const _d:uint = 0x00FFFFFF;
		private var _pixelW:uint;
		private var _pixelH:uint;
		private var _shape:String;
		
		public function Pixelate(pixelWidth:uint, pixelHeight:uint ) 
		{
			_pixelW = pixelWidth;
			_pixelH = pixelHeight;
		}
		
		public function copytoBitmap(mc:DisplayObject):Sprite
		{
			_con = new Sprite();
			_con.mouseChildren = false;
			pixels = new Array();
			_pic = new Sprite();
			var pt:Pixel;
			_con.addChild(_pic);
			W = Math.floor(mc.width);
			H = Math.floor(mc.height);
			var mt:Matrix = new Matrix();
			for(var i:uint = 0; i<=W; i+=_pixelW){
				for (var j:uint = 0; j <=H; j += _pixelH)
				{
					var bd: BitmapData = new BitmapData( _pixelW, _pixelH, true, 0x00FF0000);
                    mt.tx = -i;
                    mt.ty = -j;
                    bd.draw(mc, mt);
					pt = new Pixel(true);
					pt.init(i, j, 0, 1, new Bitmap(bd));
					pt.sizeW = _pixelW;
					pt.sizeH = _pixelH;
					pixels.push(pt);
					_pic.addChild(pt.bitmap);
				}
			}
			trace("TOTAL PIXELS: " + pixels.length);
			return _con;
		}
		
		public function copytoShape(mc:DisplayObject, shape:String="rectangle"):Sprite
		{
			_con = new Sprite();
			_con.mouseChildren = false;
			_shape = shape;
			var bm:BitmapData = new BitmapData(mc.width, mc.height, true, 0x00FFFFFF);
			bm.draw(mc);
			var d:uint = 0x00FFFFFF;
			pixels = new Array();
			var c:uint;
			_pic = new Sprite();
			var pt:Pixel;
			_con.addChild(_pic);
			W = Math.floor(bm.width);
			H = Math.floor(bm.height);
			for(var i:uint = 0; i<=W; i+=_pixelW){
				for(var j:uint = 0; j<=H; j+=_pixelH){
					c = bm.getPixel32(i,j);
					var a:uint = c >> 24 && 255;
					if(a>0){
						pt = new Pixel(false);
						pt.init(i, j, c, a);
						pt.sizeW = _pixelW;
						pt.sizeH = _pixelH;
						draw(pt)
						pixels.push(pt);
					}
				}
			}
			trace("TOTAL PIXELS: " + pixels.length);
			return _con;
		}
		private function draw(pt:Pixel):void
		{
			_pic.graphics.beginFill(pt.color);
			switch (_shape)
			{
				case "ellipse":
					_pic.graphics.drawEllipse(pt.x, pt.y, pt.sizeW, pt.sizeH);
					break;
				default:
					_pic.graphics.drawRect(pt.x, pt.y, pt.sizeW, pt.sizeH);
					break;
			}
			_pic.graphics.endFill();
		}
		public function update():void
		{
			var pt:Pixel;
			_pic.graphics.clear();
			for (var i:uint = 0; i < pixels.length; i++)
			{
				pt = pixels[i];
				draw(pt);
			}
		}
	}
	
}