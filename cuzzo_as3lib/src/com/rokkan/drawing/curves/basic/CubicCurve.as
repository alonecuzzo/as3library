/**
* CubicCurve Class
* @author Chunxi Jiang
* @version 0.1
*/
package com.rokkan.drawing.curves.basic 
{
	
	public class CubicCurve 
	{
		
		private var _xx:Array;
		private var _yy:Array;
		
		public function CubicCurve(xData:Array, yData:Array) 
		{
			_xx = xData;
			_yy = yData;
		}
		private function checkt(t:Number):Number 
		{
			if (t < 0) {
				return 0;
			}else if (t > 1) {
				return 1;
			}else
				return t;
		}
		public function getY(p:Number):Number 
		{
			p = checkt(p);
			var a0:Number, a1:Number, a2:Number, a3:Number;
			var p2:Number = p * p;
			a0 = _yy[3] - _yy[2] -_yy[0] + _yy[1];
			a1 = _yy[0] - _yy[1] -a0;
			a2 = _yy[2] - _yy[0];
			a3 = _yy[1];
			var ypos:Number = a0 * p * p2 + a1 * p2 + a2 * p + a3;
			return ypos;
		}
		public function getX(p:Number):Number 
		{
			p = checkt(p);
			var a0:Number, a1:Number, a2:Number, a3:Number;
			var p2:Number = p * p;
			a0 = _xx[3] - _xx[2] - _xx[0] + _xx[1];
			a1 = _xx[0] - _xx[1] -a0;
			a2 = _xx[2] - _xx[0];
			a3 = _xx[1];
			var xpos:Number = a0 * p * p2 + a1 * p2 + a2 * p + a3;
			return xpos;
		}
		public function getPosition(t:Number):Array 
		{
			var point:Array = new Array(2);
			t = checkt(t);
			point[0] = getX(t);
			point[1] = getY(t);
			return point;
		}
		public function arcLength():Number {
			var t:Number = 0;
			var tt:Number = 0.02;
			var l:Number = 0;
			var dt:Array = [0, 0];
			var dtt:Array = [0, 0];
			while (t < 0.98) 
			{
				dt = getPosition(t);
				dtt = getPosition(tt);
				var dx:Number = dtt[0] - dt[0];
				var dy:Number = dtt[1] - dt[1];
				var arc:Number = dx * dx + dy * dy;
				l += Math.sqrt(arc);
				t += 0.02;
				tt += 0.02;
			}
			return l;
		}
	}
	
}