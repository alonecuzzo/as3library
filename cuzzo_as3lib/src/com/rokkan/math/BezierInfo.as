package com.rokkan.math {
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class BezierInfo {
		
		private var _descrArr:Array;
		private var _ratioArr:Array;
		
		public function BezierInfo(descArr:Array) { // in the form [ [ [startRefX, controlX, endRefX], [startRefY, controlY, endRefY], ( [startRefZ, controlZ, endRefZ] ) ], and repeat for next bezier ... ]
			_descrArr = descArr;
			
			this.ratioArr = _descrArr;			
		}
		
		public function set ratioArr( descrArr:Array ) {
			var totalLength:Number = 0;
			var length:Number;
			_ratioArr = new Array();
			for (var i:uint = 0; i < descrArr.length; i++) {
				if (descrArr[i][2] != null) {
					length = BezierInfo.lengthEstimate( descrArr[i][0], descrArr[i][1], descrArr[i][2] );
				}else {
					length = BezierInfo.lengthEstimate( descrArr[i][0], descrArr[i][1] );
				}
				
				_ratioArr.push( length );
				totalLength += length;
			}
			
			for (var i:uint = 0; i < _ratioArr.length; i++) {
				_ratioArr[i] = _ratioArr[i] / totalLength;
			}
			
			//trace("_ratioArr:" + _ratioArr);
		}
		
		public function set descrArr( arr:Array ) {
			_descrArr = arr;
		}
		
		public function get descrArr():Array {
			return _descrArr;
		}
		
		public function get orderedArr():Array {
			var ordArr:Array = new Array();
			for (var i:uint = 0; i < _descrArr.length; i++) {
				for (var j:uint = 0; j < descrArr[i].length; j++) {
					for (var k:uint = 0; k < descrArr[i][j].length; k++) {
						if (ordArr[ i * 2 + k ] == null) {
							ordArr[ i * 2 + k ] = { };
						}
						if (j == 0) {
							//trace("descrArr[" + i + "][" + j + "][" + k + "]:" + descrArr[i][j][k]);
							ordArr[ i * 2 + k ].x = descrArr[i][j][k];
						}else if(j==1){
							ordArr[ i * 2 + k ].y = descrArr[i][j][k];
						}else if (j == 2) {
							ordArr[ i * 2 + k ].z = descrArr[i][j][k];
						}
					}
				}
			}
			
			return ordArr;
		}
		
		public function set orderedArr( arr:Array ) {
			var orderIncr:Number = 0;
			_descrArr = new Array();
			for (var i:uint = 0; i < arr.length - 2; i += 2) {
				_descrArr[orderIncr] = [ [ arr[i].x, arr[i + 1].x, arr[i + 2].x ], [ arr[i].y, arr[i + 1].y, arr[i + 2].y ] ];
				orderIncr++;
			}
			
			this.ratioArr = _descrArr;
		}
		
		// returns [x,y,(z)]
		public function getPoints( ratio:Number ):Array {
			for (var i:uint = 0; i < _ratioArr.length; i++) {
				if (ratio > _ratioArr[i]) {
					return [0];
					break;
				}
			}
			return [0];
		}
		
		public function getPoint( ratio:Number, xyzPt:uint):Number {
			if (ratio > 1) {
				ratio = 1;
			}else if ( ratio < 0) {
				ratio = 0;
			}
			var totalRatio:Number = 0;
			var foundI:uint;
			for (var i:uint = 0; i < _ratioArr.length; i++) {
				foundI = i;
				
				if ( ratio >= totalRatio && ratio <= totalRatio + _ratioArr[i] ) {
					break;
				}
				
				totalRatio += _ratioArr[i];
			}
			
			var subRatio:Number = (ratio - totalRatio) / _ratioArr[foundI];
			
			return getPtOnBezier(_descrArr[foundI][xyzPt][0], _descrArr[foundI][xyzPt][1], _descrArr[foundI][xyzPt][2], subRatio);
		}
		
		public static function lengthEstimate(cntrlPtsX:Array, cntrlPtsY:Array, cntrlPtsZ:Array = null, granularity:uint = 100):Number {
			var length:Number = 0;
			
			var lastX:Number = cntrlPtsX[0];
			var lastY:Number = cntrlPtsY[0];
			var lastZ:Number = cntrlPtsZ == null ? 0 : cntrlPtsZ[0];
			
			var output:String = "";
			var xTo:Number;
			var yTo:Number;
			var zTo:Number;
			var zSecondPow:Number = 0;
			
			for (var i:uint = 0; i <= granularity; i++) {
				xTo = BezierInfo.getPtOnBezier( cntrlPtsX[0], cntrlPtsX[1], cntrlPtsX[2], i / granularity);
				var diffX:Number = xTo - lastX;
				yTo = BezierInfo.getPtOnBezier( cntrlPtsY[0], cntrlPtsY[1], cntrlPtsY[2], i / granularity);
				var diffY:Number = yTo - lastY;
				if (cntrlPtsZ != null) {
					zTo = BezierInfo.getPtOnBezier( cntrlPtsZ[0], cntrlPtsZ[1], cntrlPtsZ[2], i / granularity);
					var diffZ:Number = zTo - lastZ;
					zSecondPow = Math.pow(diffY, 2);
				}
				
				var subLength:Number = Math.sqrt( Math.pow(diffX, 2) + Math.pow(diffY, 2) + zSecondPow);
				//output += " xTo:" + xTo.toFixed(2) + " diffX:" + diffX.toFixed(2) + " subLength:" + subLength.toFixed(2);
				
				length += subLength;
				
				lastX = xTo;
				lastY = yTo;
				lastZ = zTo;
			}
			
			return length;
		}
		
		public static function getPtOnBezier(ref1:Number, control:Number, ref2:Number, ratio:Number = 0.5):Number {
			return ref1 + ratio * (2 * (1 - ratio) * (control - ref1) + ratio * (ref2 - ref1));
		}
	}
	
}