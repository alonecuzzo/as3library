package com.rokkan.math {
	import com.rokkan.math.LineDef;

	/**
	* Functions for dealing with Lines Segments and their relationship to one another
	* @author Russell Savage
	*/
	public class LineIntersect {
		
		public function LineIntersect() {
			
		}
		
		/**
		 * do two lines overlap? If yes return the point that they overlap
		 * @param	first line
		 * @param	second line
		 * @return 	false if they do not overlap or the an array where they do [x,y]
		*/
		public static function doLinesIntersect(line1:LineDef, line2:LineDef):Object {
			var x:Number = (line1.offset - line2.offset) / (line2.slope - line1.slope); // x intersection point
			var y:Number; // y intersection point
			if (isFinite(line2.slope) == false) { // Slope 2 is infinite
				x = line2.offset;
				y = line1.slope * x + line1.offset;
			}else if (isFinite(line1.slope) == false) { // Slope 1 is infinite
				x = line1.offset;
				y = line2.slope * x + line2.offset;
			}else if (isFinite(line1.slope) == false && isFinite(line2.slope) == false ){
				return false;
			}else {
				y = line1.slope * x + line1.offset;
			}
			
			if( withinBounds(line1, x, y) && withinBounds(line2, x, y) ){
				return [x , y];
			}else {
				return false;
			}
		}
		
		/**
		 * Finds the angle that the first line reflects off the second
		 * @param	first line
		 * @param	second line
		 * @return 	angle that the first line reflects off the second
		 */
		public static function lineReboundAngle(line1:LineDef, line2:LineDef):Number {
			var rot1:Number = line1.rotation;
			var rot1reversed:Number = sanitizeRad(rot1 + Math.PI);
			var ninety2:Number = sanitizeRad( line2.rotation - Math.PI / 2 );
			
			//trace("rot1reversed:" + rot1reversed + " deg:"+LineDef.radiansToDegrees(rot1reversed));
			//trace("ninety2:" + LineDef.radiansToDegrees(ninety2));
			
			var ninety2neg:Number = ninety2 < 0 ? sanitizeRad(ninety2) : sanitizeRad(ninety2 - Math.PI);
			var ninety2pos:Number = ninety2 < 0 ? sanitizeRad(ninety2 + Math.PI) : ninety2;
			//trace("ninety2neg:" + ninety2neg + " deg:" + LineDef.radiansToDegrees(ninety2neg) + " ninety2pos:" + ninety2pos + " deg:" + LineDef.radiansToDegrees(ninety2pos));
			
			var rightRightAngle:Number;
			if ( distBetweenRads(rot1reversed, ninety2neg) < distBetweenRads(rot1reversed, ninety2pos)) {
				rightRightAngle = ninety2neg;
			}else {
				rightRightAngle = ninety2pos;
			}
			
			
			var diffBetween:Number = distBetweenRads(rot1, rightRightAngle);
			var diff1:Number = rightRightAngle + diffBetween;
			var diff2:Number = rightRightAngle - diffBetween;
			
			if (distBetweenRads(diff1, rot1) > distBetweenRads(diff2, rot1)) {
				return (diff1);
			}else {
				return (diff2);
			}
		}
		
		public static function distBetweenRads(rad1:Number, rad2:Number):Number {
			var diff1:Number = sanitizeRad(rad1 - rad2);
			var diff2:Number = sanitizeRad(rad2 - rad1);
			if (diff1 < diff2) {
				return diff1;
			}else {
				return diff2;
			}
		}
		
		// Because a line can have two different angles which describe it, this function calculates 
		// what is the smallest difference between the two possible angles for both given radians
		public static function distBetweenEveryAngle(rad1:Number, rad2:Number):Number { 
			rad1 = sanitizeRad(rad1);
			rad2 = sanitizeRad(rad2);
			//trace("sanitized rad1:" + rad1 + " rad2:" + rad2);
			var radArr:Array = [rad1, null, rad2, null];
			
			// calculate the angles other possible angle
			for (var i = 0; i < 4; i += 2) {
				if (radArr[i] > Math.PI) {
					radArr[i+1] = Math.PI - (2 * Math.PI - radArr[i]);
				}else {
					radArr[i+1] = 2*Math.PI - radArr[i];
				}
			}
			
			var leastAngle:Number = Number.POSITIVE_INFINITY;
			for (i = 0; i < 2; i++) {
				for (var j = 0; j < 2; j++) {
					var angle:Number =  radArr[i] - radArr[j + 2];
					//trace("diff for pt:" + (i*j) + " is:" + angle +" i:"+i+" j:"+j);
					if (Math.abs(angle) < Math.abs(leastAngle)){
						leastAngle = angle;
					}
				}
			}
			
			//trace("less than pi 0:" + radArr[0].toFixed(2) + " 1:" + radArr[1].toFixed(2) + " 2:" + radArr[2].toFixed(2) + " 3:" + radArr[3].toFixed(2));
			//trace("leastAngle:" + leastAngle);
			return leastAngle;
		}
		
		private static function sanitizeRad(rad:Number) {
			rad = rad % (Math.PI * 2);
			if (rad < 0)
				rad = Math.PI * 2 + rad;
			
			return rad;
		}
		
		public static function radToDegrees(radAng:Number) {
			return (radAng / Math.PI) * 180;
		}
		
		public static function withinBounds(line:LineDef, x:Number, y:Number) {
			if ( x < line.x1 && x < line.x2  && (line.x1 - x)>0.01 && (line.x2 - x)>0.01) {
				return false;
			}
			if (x > line.x1 && x > line.x2 && (x - line.x1)>0.01 && (x - line.x2)>0.01) {
				return false;
			}
			if (y < line.y1 && y < line.y2 && (line.y1 - y)>0.01 && (line.y2 - y)>0.01) { // to avoid a rounding error the distance off has to be greater than 0.01
				return false;
			}
			if (y > line.y1 && y > line.y2 && (y - line.y1)>0.01 && (y - line.y2)>0.01) { // ditto
				return false;
			}
			return true;
		}
		
	}
	
}