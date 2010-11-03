package com.atmospherebbdo.sfx.boids {
	import com.atmospherebbdo.assertions.assert;
	import com.atmospherebbdo.assertions.fail;
	import com.atmospherebbdo.util.instantiatedAs;
	
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;	
	/**	 * @author markhawley	 * 	 * Hijacked from electrotank.com demo and slighly modified.	 */	public class Boid extends MovieClip	{
		public var xvelocity:Number;
		public var yvelocity:Number;
		public var centerOfMass:Object = {};
		public var averageVelocity:Object = {};
		public var angle:Number = 0;		private var neighbors:Array = [];
		private var rotations:Array = [];
		private var totalRots:Number = 0;
		private var lastRot:Number = 0;
		private var numRotAvgs:Number = 0;		private var animation:MovieClip;
		public function Boid( className:String = null ) 		{			if (className == null)			{				if (instantiatedAs(this, Boid))				{					fail("A class name is required for Boids if you aren't " + 					"subclassing Boid.");				}			}			else			{				initializeWithClassName(className);			}
		}		private function initializeWithClassName( className:String ):void		{			var animationClass:Class = getDefinitionByName(className) as Class;			animation = new animationClass() as MovieClip;						assert(animation != null);						// start on a random frame of the boid animation			addChild(animation);			animation.gotoAndPlay(1 + Math.floor(Math.random() * animation.totalFrames));
		}		public function getSpeed():Number 		{
			return Math.sqrt(Math.pow(xvelocity, 2) + Math.pow(yvelocity, 2));
		}
		public function reset():void 		{
			neighbors = [];
			centerOfMass.x = 0;
			centerOfMass.y = 0;
			averageVelocity.xvelocity = 0;
			averageVelocity.yvelocity = 0;
		}
		public function addNeighbor(b:Boid):void 		{
			neighbors.push(b);
			centerOfMass.x += b.x;
			centerOfMass.y += b.y;
			averageVelocity.xvelocity += b.xvelocity;
			averageVelocity.yvelocity += b.yvelocity;
		}
		public function determineAverages():void 		{
			if (getNeighbors().length > 0) 			{
				centerOfMass.x = centerOfMass.x / getNeighbors().length;
				centerOfMass.y = centerOfMass.y / getNeighbors().length;
				averageVelocity.xvelocity = averageVelocity.xvelocity / getNeighbors().length;
				averageVelocity.yvelocity = averageVelocity.yvelocity / getNeighbors().length;
			} 			else 			{
				centerOfMass.x = x;
				centerOfMass.y = y;
				averageVelocity.xvelocity = xvelocity;
				averageVelocity.yvelocity = yvelocity;
			}
		}
		public function getNeighbors():Array 		{
			return neighbors;
		}
		public function getAngle():Number 		{
			return angle;
		}
		public function run():void 		{
			var a:Number = .3;
			xvelocity += a * (Math.random() - Math.random());
			yvelocity += a * (Math.random() - Math.random());
			var speed:Number = getSpeed();
			angle = Math.atan2(yvelocity, xvelocity);
			if (speed > 12) 			{
				speed = 12;
			} else if (speed < 2) 			{
				speed = 2;
			}
			xvelocity = speed * Math.cos(getAngle());
			yvelocity = speed * Math.sin(getAngle());
			x += xvelocity;
			y += yvelocity;
			if (rotations.length >= 20) 			{
				rotations.shift();
			}
			var rot:Number = getAngle() * 180 / Math.PI;
			
			//avarage the last several rotations to smooth rotation;
			var rotavg:Number = 0;
			rotations.push(rot);
			totalRots += rot;
			if (rotations.length > 10) 			{
				totalRots -= rotations[0];
				rotations.shift();
			}
			rotavg = totalRots / rotations.length;
			rotation = rotavg;																																										
		}
	}
}