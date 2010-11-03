/**
* BezierCurve Class
* @author Chunxi Jiang
* @version 0.1
*/
package com.rokkan.drawing.curves.basic 
{

	public class BezierCurve
	{
		
		private var _xx:Array;
		private var _yy:Array;
		private var _num:uint;
		private var _co:Array;
		private var _nfac:Number;
		
		public function BezierCurve(xData:Array, yData:Array) 
		{
			_xx = xData;
			_yy = yData;
			init();
		}
		//private functions
		private function init():void 
		{
			if (_xx.length != _yy.length) 
			{
				trace("Error input data");
				return;
			}
			_num = _xx.length;
			_nfac = factorial(_num - 1);
			_co = new Array(_num);
			for (var i:uint = 0; i < _num; i++) 
			{
				_co[i] = calCo(i);
			}
		}
		private function factorial(n:uint):Number 
		{
			var r:Number = 1;
			for (var i:uint = 1; i <= n; i++)
				r *= i;
			return r;
		}
		private function calCo(p:uint ):Number 
		{
			if (p >= _num) return -1;
			var f:Number = factorial(_num - p - 1) * factorial(p);
			var co:Number = _nfac / f;
			return co;
		}
		private function checkt(t:Number):Number 
		{
			if (t < 0)
			{
				return 0;
			}else if (t > 1) 
			{
				return 1;
			}else
				return t;
		}
		//public functions
		public function getX(t:Number):Number 
		{
			var destx:Number = 0;
			t = checkt(t);
			for (var i:uint = 0; i < _num; i++) 
			{
				destx += _xx[i] * Math.pow((1 - t), (_num - i - 1)) * Math.pow(t, i)*_co[i];
			}
			return destx;
		}
		public function getY(t:Number):Number 
		{
			var desty:Number = 0;
			t = checkt(t);
			for (var i:uint = 0; i < _num; i++) 
			{
				desty += _yy[i] * Math.pow((1 - t), (_num - i - 1)) * Math.pow(t, i)*_co[i];
			}
			return desty;
		}
		public function getPosition(t:Number):Array 
		{
			var point:Array = [0, 0];
			t = checkt(t);
			for (var i:uint = 0; i < _num; i++) 
			{
				point[0] += _xx[i] * Math.pow((1 - t), (_num - i - 1)) * Math.pow(t, i)*_co[i];
				point[1] += _yy[i] * Math.pow((1 - t), (_num - i - 1)) * Math.pow(t, i)*_co[i];
			}
			return point;
		}
		public function arcLength():Number 
		{
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
				var arc:Number = dx * dx + dy * dy
				l += Math.sqrt(arc);
				t += 0.02;
				tt += 0.02;
			}
			return l;
		}
	}
}