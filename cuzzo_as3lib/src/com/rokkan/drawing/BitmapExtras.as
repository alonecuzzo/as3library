package com.rokkan.drawing 
{
	import away3d.core.utils.Cast;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	
	/**
	* Extra functions for working with Bitmaps and BitmapData
	* @author Russell Savage
	*/
	public class BitmapExtras 
	{
		
		public function BitmapExtras() 
		{
			
		}
		
		public static function cropObject( obj, cropWidth:Number, cropHeight:Number, offSetX:Number = 0, offSetY:Number = 0, overrideWidth:Number = NaN, overrideHeight:Number = NaN):BitmapData 
		{
			if (isNaN(overrideWidth)){
				overrideWidth = obj.width;
			}
			if (isNaN(overrideHeight)){
				overrideHeight = obj.height;
			}
			var bData:BitmapData = new BitmapData(overrideWidth, overrideHeight, true, 0xFFFFFF);
			var drawingRectangle:Rectangle =  new Rectangle(offSetX, offSetY, obj.width, obj.height);
			var transformMatrix:Matrix = new Matrix();
			transformMatrix.tx = -offSetX + Math.round(cropWidth/2);
			transformMatrix.ty = -offSetY + Math.round(cropHeight/2);
			
			bData.draw(obj, transformMatrix, null, null, drawingRectangle, false);
			
			var croppedBData:BitmapData = new BitmapData( cropWidth, cropHeight, true, 0xFFFFFF );
			croppedBData.draw( new Bitmap(bData) );
			return croppedBData;
		}
		
		public static function cropObject2( obj, cropWidth:Number, cropHeight:Number, offSetX:Number = 0, offSetY:Number = 0, overrideWidth:Number = NaN, overrideHeight:Number = NaN):BitmapData 
		{
			if (isNaN(overrideWidth)){
				overrideWidth = obj.width;
			}
			if (isNaN(overrideHeight)){
				overrideHeight = obj.height;
			}
			var bData:BitmapData = new BitmapData(obj.width, obj.height, true, 0x00FFFFFF);
			var mat:Matrix = obj.transform.matrix.clone();
			mat.tx = -offSetX;
			mat.ty = -offSetY;
			bData.draw(obj, mat, obj.transform.colorTransform, obj.blendMode, new Rectangle(0, 0, cropWidth, cropHeight), true);
			
			return bData;
		}
	}
	
}