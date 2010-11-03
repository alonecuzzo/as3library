/**
* FreeTrans Class
* @author Chunxi Jiang
* @version 0.1
*/
package com.rokkan.effects
{
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class FreeTransform {
		
		private var _bmpW:Number;
		private var _bmpH:Number;
		private var _vertices:Array;
		private var _newVertices:Array;
		private var _segmentsW:uint;
		private var _segmentsH:uint;
		private var _bmpData:BitmapData;
		public var smooth:Boolean;
		
		public function FreeTransform(src:DisplayObject, segmentsW:uint = 1, segmentsH:uint = 1)
		{
			this._bmpW = src.width;
			this._bmpH = src.height;
			_bmpData = new BitmapData(_bmpW, _bmpH, true, 0x00FFFFFF);
			_bmpData.draw(src);
			this._segmentsW = segmentsW;
			this._segmentsH = segmentsH;
			this._vertices = new Array();
			this._newVertices = new Array();
			this.smooth = false;
			initVertices();
		}
		
		private function initVertices():void 
		{
			var xStep:Number = _bmpW / _segmentsW;
			var yStep:Number = _bmpH / _segmentsH;
			for (var j:uint = 0; j <= _segmentsH; j++)
			{
				_vertices[j]=[];
				for (var i:uint = 0; i <= _segmentsW; i++)
					_vertices[j][i] = new Point(i * xStep, j * yStep);
			}
		}
				
		private function calVertices(p0:Point, p1:Point, p2:Point, p3:Point):void
		{
			var vl:Point = new Point((p3.x - p0.x), (p3.y - p0.y));
			var vr:Point = new Point((p2.x - p1.x), (p2.y - p1.y));
			var curVert:Point;
			var curPointLeft:Point = new Point();
			var curPointRight:Point = new Point();
			var newVert:Point = new Point();
			var yp:Number;
			var xp:Number;
			for (var j:uint = 0; j <= _segmentsH; j++)
			{
				_newVertices[j] = new Array(_segmentsH + 1);
				for (var i:uint = 0; i <= _segmentsW; i++)
				{
					curVert = _vertices[j][i];
					yp = j / _segmentsH;
					xp = i / _segmentsH;
					curPointLeft.x = p0.x + yp * vl.x;
					curPointLeft.y = p0.y + yp * vl.y;
					curPointRight.x = p1.x + yp * vr.x;
					curPointRight.y = p1.y + yp * vr.y;
					newVert.x = curPointLeft.x + (curPointRight.x - curPointLeft.x) * xp;
					newVert.y = curPointLeft.y + (curPointRight.y - curPointLeft.y) * xp;
					_newVertices[j][i] = new Point(newVert.x, newVert.y);
				}
			}
		}
		public function transform(container:Sprite, p0:Point, p1:Point, p2:Point, p3:Point):void 
		{
			var iv0:Point;
			var iv1:Point;
			var iv2:Point;
			var v0:Point;
			var v1:Point;
			var v2:Point;
			var m0:Matrix = new Matrix();
			var m1:Matrix = new Matrix();
			
			calVertices(p0, p1, p2, p3);
			
			for (var j:uint = 0; j <_segmentsH; j++)
			{
				for (var i:uint = 0; i <_segmentsW; i++)
				{
					//draw triangle
					iv0 = _vertices[j][i];
					iv1 = _vertices[j + 1][i];
					iv2 = _vertices[j][i + 1];
					
					v0 = _newVertices[j][i];
					v1 = _newVertices[j + 1][i];
					v2 = _newVertices[j][i + 1];
					
				    m0.tx = iv0.x;
				    m0.ty = iv0.y;
				    m0.a = 0;
				    m0.b = (iv1.y - iv0.y) / _bmpW;
				    m0.c = (iv2.x - iv0.x) / _bmpH;
				    m0.d = 0;
				    m1.a = (v1.x - v0.x) / _bmpW;
				    m1.b = (v1.y - v0.y) / _bmpW;
				    m1.c = (v2.x - v0.x) / _bmpH;
				    m1.d = (v2.y - v0.y) / _bmpH;
				    m1.tx = v0.x;
				    m1.ty = v0.y;
				    m0.invert();
				    m0.concat(m1);
					
				    container.graphics.beginBitmapFill(_bmpData, m0, false, smooth);
				    container.graphics.moveTo(v0.x, v0.y);
				    container.graphics.lineTo(v1.x, v1.y);
				    container.graphics.lineTo(v2.x, v2.y);
					container.graphics.lineTo(v0.x, v0.y);
				    container.graphics.endFill();
					
					//the other triangle
					iv0 = _vertices[j + 1][i + 1];
					iv1 = _vertices[j][i + 1];
					iv2 = _vertices[j + 1][i];
					
					v0 = _newVertices[j + 1][i + 1];
					v1 = _newVertices[j][i + 1];
					v2 = _newVertices[j + 1][i];
					
				    m0.tx = iv0.x;
				    m0.ty = iv0.y;
				    m0.a = 0;
				    m0.b = (iv1.y - iv0.y) / _bmpW;
				    m0.c = (iv2.x - iv0.x) / _bmpH;
				    m0.d = 0;
				    m1.a = (v1.x - v0.x) / _bmpW;
				    m1.b = (v1.y - v0.y) / _bmpW;
				    m1.c = (v2.x - v0.x) / _bmpH;
				    m1.d = (v2.y - v0.y) / _bmpH;
				    m1.tx = v0.x;
				    m1.ty = v0.y;
				    m0.invert();
				    m0.concat(m1);
					
				    container.graphics.beginBitmapFill(_bmpData, m0, false, smooth);
				    container.graphics.moveTo(v0.x, v0.y);
				    container.graphics.lineTo(v1.x, v1.y);
				    container.graphics.lineTo(v2.x, v2.y);
					container.graphics.lineTo(v0.x, v0.y);
				    container.graphics.endFill();
				}
			}
		}		
	}
}