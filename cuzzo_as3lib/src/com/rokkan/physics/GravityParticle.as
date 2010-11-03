package com.rokkan.physics 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class GravityParticle
	{
		public var resistance:Number;
		
		private var dX:Number = 0;
		private var dY:Number = 0;
		private var _calcResist:Number;
		public var mc:Sprite;
		
		public function GravityParticle(resistance:Number = 0.05) 
		{
			this.resistance = resistance;
		}
		
		public function init( vis_mc:Sprite ) {
			mc = vis_mc;
		}
		
		public function die() {
			mc.parent.removeChild( mc );
		}
		
		public function updatePosition(multiplier:Number = 1) {
			mc.x += dX * multiplier;
			mc.y += dY * multiplier;
			
			_calcResist = Math.max(0, (1 - resistance * multiplier));
			dX *= _calcResist;
			dY *= _calcResist;
		}
		
		public function push(x:Number = 0, y:Number = 0) {
			dX += x;
			dY += y;
		}
		
		public function checkHit( disp:DisplayObject, xOff:Number = 0, yOff:Number = 0 ):Boolean {
			return disp.hitTestPoint( mc.x - xOff, mc.y + yOff, true );
		}
		
		public function set x(x:Number) {
			mc.x = x;
		}
		
		public function set y(y:Number) {
			mc.y = y;
		}
		
		public function get x():Number {
			return mc.x;
		}
		
		public function get y():Number {
			return mc.y;
		}
		
	}
	
}