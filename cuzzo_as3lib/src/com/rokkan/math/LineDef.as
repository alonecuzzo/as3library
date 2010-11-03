package com.rokkan.math {
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class LineDef {
		public static const PI_TIMESTWO:Number = Math.PI * 2;
		public static const PI_DIVIDEBYTWO:Number = Math.PI / 2;
		public var x1:Number;
		public var y1:Number;
		public var x2:Number;
		public var y2:Number;
		
		public function LineDef(lineX1:Number=0, lineY1:Number=0, lineX2:Number=1, lineY2:Number=1) {
			x1 = lineX1;
			y1 = lineY1;
			x2 = lineX2;
			y2 = lineY2;
		}
		
		public function get slope():Number {
			// derived equation [(y2 - y1) / (x2 - x1)]·x - [(y2 - y1) / (x2 - x1)]*x1 + y1
			var slope:Number = (y2 - y1) / (x2 - x1);
			return slope;
		}
		
		public function get offset():Number {
			var offset:Number = (0 - ((y2 - y1) / (x2 - x1)) * x1) + y1;
			if (isFinite(offset) == false) {
				offset = x1;
			}
			
			return offset;
		}
		
		public function get distance():Number {
			var dist:Number = Math.sqrt( Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2) );
			return dist;
		}
		
		public function get rotation():Number {
			// trace("slope:" + slope + " x1:" + x1 + " y1:" + y1 + " x2:" + x2 + " y2:" + y2);
			var rot:Number = Math.atan( slope );
			if (x1 > x2) {
				rot = Math.PI + rot;
			}
				
			return rot;
		}
		
		public function get rotationDegrees():Number {
			var deg:Number = radiansToDegrees(rotation);
			
			return sanitizeDegree(deg);
		}
		
		public static function distanceFrom(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			return Math.sqrt( Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2) );
		}
		
		public static function radianDifference(rad1:Number, rad2:Number):Number {
			rad1 = sanitizeRadianPos(rad1);
			rad2 = sanitizeRadianPos(rad2);
			var returnVar:Number;
			//trace("rad1:" + rad1.toFixed(4) + " rad2:" + rad2.toFixed(4));
			returnVar = sanitizeRadian( rad1 - rad2);
			return returnVar;
		}
		
		public static function radiansToDegrees(rad:Number) {
			return (rad / PI_TIMESTWO) * 360;
		}
		
		public static function degreesToRadians(deg:Number) {
			return (deg / 180) * Math.PI;
		}
		
		public static function sanitizeDegree(deg:Number) {
			deg = deg % (360);
			
			if (deg > 180) {
				deg = -(360 - deg);
			}
			if (deg < -180) {
				deg = 360 + deg;
			}
			
			return deg;
		}
		
		public static function sanitizeRadian( rad:Number ) {
			rad = rad % PI_TIMESTWO;
			if ( rad > Math.PI ) {
				rad = -(PI_TIMESTWO - rad);
			}
			if (rad < -Math.PI) {
				rad = PI_TIMESTWO + rad;
			}
			
			return rad;
		}

		public static function sanitizeDegreePos( deg:Number ) {
			deg = deg % 360;
			if ( deg < 0) {
				deg = 360 + deg;
				deg = deg % 360;
			}
			
			return deg;
		}
		
		public static function sanitizeRadianPos( rad:Number ) {
			rad = rad % PI_TIMESTWO;
			if ( rad < 0) {
				rad = PI_TIMESTWO + rad;
				rad = rad % PI_TIMESTWO;
			}
			
			return rad;
		}
		
		public static function nearestDegree( fromDegree:Number, toDegree:Number ):Number	 {
			var sign:Number = fromDegree < 0 ? -1 : 1;
			toDegree = sign * Math.abs( toDegree ); // Make same sign as fromDegree
			var floor:Number = Math.floor( fromDegree / 360 ) * 360 + toDegree;
			var ceiling:Number = Math.ceil( fromDegree / 360 ) * 360 + toDegree;
			
			//var returner:String = "Math.abs( fromDegree - floor ):" + Math.abs( fromDegree - floor ) + " Math.abs( fromDegree - ceiling ):" + Math.abs( fromDegree - ceiling );
			
			if (Math.abs( fromDegree - floor ) < Math.abs( fromDegree - ceiling ) ) {
				return floor;
			}else {
				return ceiling;
			}
		}
		
		public static function areEqual(line1:LineDef, line2:LineDef):Boolean {
			if (line1.x1 == line2.x1 && line1.y1 == line2.y1 && line1.x2 == line2.x2 && line1.y2 == line2.y2) {
				return true;
			}
			return false;
		}
		
		public function toString():String {
			return "{LineDef x1:" + x1.toFixed(2) + " y1:" + y1.toFixed(2) + " x2:" + x2.toFixed(2) + " y2:" + y2.toFixed(2) + "}";
		}
	}	
}