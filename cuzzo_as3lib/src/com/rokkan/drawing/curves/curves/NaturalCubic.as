/**
* NaturalCubic Class
* @author Chunxi Jiang
* @version 0.1
*/
package com.rokkan.drawing.curves.curves 
{
	
	import com.rokkan.drawing.curves.basic.CubicCurve;
	
	public class NaturalCubic 
	{
		
		private var _xx:Array;
		private var _yy:Array;
		private var _curves:Array;
		private var _num:uint;
		private var _totallength:Number;
		private var _lengths:Array;
		private var _ilengths:Array;
		
		/**
		 * using cubic curves connect points from point[1] to point[length-2]
		 * point[_xx[i], _xx[i]]; 0<=i<=length-1;
		 */
		public function NaturalCubic(xData:Array, yData:Array) 
		{
			_xx = xData;
			_yy = yData;
			init();
		}
		private function init():void 
		{
			_num = _xx.length - 1;
			_curves = new Array(_num);
			_lengths = new Array(_num);
			_ilengths = new Array(_num);
			_totallength = 0;
			for (var i:uint = 0; i < _num - 2; i++) 
			{
				var xdata:Array = [_xx[i], _xx[i+1], _xx[i+2], _xx[i+3]];
				var ydata:Array = [_yy[i], _yy[i + 1], _yy[i + 2], _yy[i + 3]];
				var c:CubicCurve = new CubicCurve(xdata, ydata);
				_curves[i] = c;
				var l:Number = c.arcLength();
				_totallength += l;
				_lengths[i] = _totallength;
				_ilengths[i] = l;
			}
		}
		public function getArc(p:Number):int 
		{
			for (var i:uint = 0; i < _num; i++) 
			{
				if (p * _totallength < _lengths[i])
					break;
			}
			return i;
		}
		public function getX(p:Number):Number 
		{
			var sec:int = getArc(p);
			var pct:Number;
			if (sec == 0) 
			{
				pct = p * _totallength / _ilengths[0];
			}else 
			{
				pct = (p * _totallength - _lengths[sec - 1]) / _ilengths[sec];
			}
			var xpos:Number = _curves[sec].getX(pct);
			return xpos;
		}
		public function getY(p:Number):Number 
		{
			var sec:int = getArc(p);
			var pct:Number;
			if (sec == 0) 
			{
				pct = p * _totallength / _ilengths[0];
			}else {
				pct = (p * _totallength - _lengths[sec - 1]) / _ilengths[sec];
			}
			var ypos:Number = _curves[sec].getY(pct);
			return ypos;
		}
		public function getPosition(p:Number):Array 
		{
			var sec:int = getArc(p);
			var pct:Number;
			if (sec == 0) 
			{
				pct = p * _totallength / _ilengths[0];
			}else 
			{
				pct = (p * _totallength - _lengths[sec - 1]) / _ilengths[sec];
			}
			var point:Array = _curves[sec].getPosition(pct);
			return point;
		}
	}
	
}