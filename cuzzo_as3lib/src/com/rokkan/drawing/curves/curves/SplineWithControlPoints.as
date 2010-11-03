/**
* SplineWithControlPoints Class
* @author Chunxi Jiang
* @version 0.1
*/
package com.rokkan.drawing.curves.curves 
{
	
	import com.rokkan.drawing.curves.basic.BezierCurve;
	
	public class SplineWithControlPoints 
	{
		
		private var _xx:Array;
		private var _yy:Array;
		private var _Ixx:Array;
		private var _Oxx:Array;
		private var _Iyy:Array;
		private var _Oyy:Array;
		private var _Blines:Array;
		private var _num:uint;
		private var _totallength:Number;
		private var _lengths:Array;
		private var _ilengths:Array;
		/**
		 * bezier curves from point[0] to point[length-1]
		 * point[_xx[i], _xx[i]]; 0<=i<=length-1;
		 */
		public function SplineWithControlPoints(xData:Array, yData:Array, ICtlxData:Array, ICtlyData:Array, OCtlxData:Array, OCtlyData:Array) 
		{
			_xx = xData;
			_yy = yData;
			_Ixx = ICtlxData;
			_Iyy = ICtlyData;
			_Oxx = OCtlxData;
			_Oyy = OCtlyData;
			init();
		}
		private function init():void 
		{
			_num = _xx.length - 1;
			_Blines = new Array(_num);
			_lengths = new Array(_num);
			_ilengths = new Array(_num);
			_totallength = 0;
			for (var i:uint = 0; i < _num; i++) 
			{
				var xdata:Array = [_xx[i], _Ixx[i], _Oxx[i], _xx[i + 1]];
				var ydata:Array = [_yy[i], _Iyy[i], _Oyy[i], _yy[i + 1]];
				var Bline:BezierCurve = new BezierCurve(xdata, ydata);
				_Blines[i] = Bline;
				var l:Number = Bline.arcLength();
				_totallength += l;
				_lengths[i] = _totallength;
				_ilengths[i] = l;
			}
		}
		//public functions
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
			var xpos:Number = _Blines[sec].getX(pct);
			return xpos;
		}
		public function getY(p:Number):Number {
			var sec:int = getArc(p);
			var pct:Number;
			if (sec == 0) 
			{
				pct = p * _totallength / _ilengths[0];
			}else 
			{
				pct = (p * _totallength - _lengths[sec - 1]) / _ilengths[sec];
			}
			var ypos:Number = _Blines[sec].getY(pct);
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
			var point:Array = _Blines[sec].getPosition(pct);
			return point;
		}
	}
	
}