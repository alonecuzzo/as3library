﻿package com.atmospherebbdo.util.geometry {	import uk.co.bigroom.utils.ObjectPool;		import com.atmospherebbdo.dbc.precondition;	import com.atmospherebbdo.util.IPoolable;	import com.atmospherebbdo.util.string.sprintf;import com.atmospherebbdo.dbc.postcondition;			/**	 * @author markhawley	 * 	 * A two-dimensional vector. In expectation that many Vector2D objects will	 * be created and discarded, Vector2D implements IPoolable and makes use	 * of static methods to handle pooling. (Vector2D objects can still be	 * instantiated directly if desired.)	 * 	 * Many of the methods of Vector2D come in a 'past-tense' version -- these	 * return a new Vector2D while the 'present-tense' versions alter the	 * vector in-place. (a.multiply(s) multiplies a by a given scalar, but	 * a.multiplied(s) returns a new Vector2D equivalent to this vector multiplied	 * by the given scalar.	 */	public class Vector2D implements IPoolable	{		public var x:Number;		public var y:Number;				internal var _valid:Boolean = true;				/**		 * Object-pooling friendly way to get a Vector2D object. If you'll		 * be using and discarding many Vector2Ds, getting them via this		 * method is more performant than directly instantiating them.		 * 		 * @param	x	Number		 * @param	y	Number		 * 		 * @return Vector2D		 */		public static function getFromPool( x:Number, y:Number ) :Vector2D		{			// get or create a Vector2D			var v:Vector2D = ObjectPool.getObject( Vector2D, x, y ) as Vector2D;			v.restoreFromPooling( x, y );			return v;		}				/**		 * Object-pooling friendly way to discard Vector2D objects, zeroing and		 * sending the to an object pool for re-use. The vector passed to it		 * should no longer referenced by outside code -- null all references		 * to it after sending it to the pool!		 * 		 * @param	v	Vector2D		 */		public static function sendToPool( v:Vector2D ) :void		{			v.prepareForPooling();			ObjectPool.disposeObject(v, Vector2D);		}				/**		 * Returns true if the given vector has zero length.		 * 		 * @param	v	Vector2D		 * 		 * @return	Boolean		 */		public static function isZeroVector( v:Vector2D ) :Boolean		{			return v.length == 0;		}				/**		 * Constructor		 * 		 * @param	x	Number		 * @param	y	Number		 */		public function Vector2D( x:Number=0, y:Number=0 )		{			this.x = x;			this.y = y;		}				/**		 * Return angle from x-axis in radians		 * 		 * @param	Number		 */		public function get angle() :Number		{			precondition(_valid);						if (x == 0)			{				if (y == 0)				{					return 0;				}				else if (y > 0)				{					// pointing up					return 1.5 * Math.PI;				}				else				{					// pointing down					return .5 * Math.PI;				}			}			else if (y == 0)			{				if (x > 0)				{					// pointing right					return 0;				}				else				{					// pointing left					return Math.PI;				}			}			else			{				var ang:Number = Math.atan(y / x);				if (x > 0 && y > 0)				{					// x and y are positive, Quadrant I					return ang;				}				else if (x < 0 && y > 0)				{					// x neg, y pos, Quadrant II					return ang + Math.PI * 2;				}				else if (x > 0 && y < 0)				{					// x pos, y neg, Quadrant III					return ang + Math.PI;				}				else				{					// x neg, y neg, Quadrant IV					return ang + Math.PI;				}			}		}				/**		 * Sets the angle in radians.		 * 		 * @param	a	Number in radians.		 */		public function set angle( a:Number ) :void		{			x = length * Math.cos(a);			y = length * Math.sin(a);		}				/**		 * Returns the distance from the origin.		 * 		 * @return Number		 */		public function get length() :Number		{			precondition(_valid);						return Math.sqrt( x*x + y*y );			}				/**		 * Sets the distance from the origin, maintaining the current angle.		 * 		 * @param	s	Number		 */		public function set length( s:Number ) :void		{			precondition(_valid);						normalize();			multiply(s);		}				/**		 * Returns a copy of this vector.		 * 		 * @return	Vector2D		 */		public function clone() :Vector2D		{			precondition(_valid);						return Vector2D.getFromPool( x, y );		}				/**		 * Returns a normalized copy of this vector.		 * 		 * @return	Vector2D		 */		public function normalized() :Vector2D		{			var c:Vector2D = clone();			c.normalize();			return c;		}				/**		 * Normalizes this vector. Zero vectors are unaffected.		 */		public function normalize() :void		{			precondition(_valid);						var l:Number = length;						if (l != 0)			{				x /= l;				y /= l;			}			else			{				// leave the length at zero if this is a zero vector				return;			}						postcondition(1 == length, "Normalized vectors have a length of 1.");		}				/**		 * Returns a copy of this vector reflected about a given vector.		 * 		 * @param	v	Vector2D		 * 		 * @return Vector2D		 */		public function reflected( v:Vector2D ) :Vector2D		{			var c:Vector2D = clone();			c.reflect(v);			return c;		}				/**		 * Reflects this vector about a given vector.		 * 		 * @param	v	Vector2D		 */		public function reflect( v:Vector2D ) :void		{			precondition(_valid);						var n:Vector2D = v.normalized();			var r:Vector2D = n.reversed();			r.multiply(2 * dotProduct(n));			add(r);						sendToPool(n);			sendToPool(r);		}				/**		 * Returns a copy of this vector, reversed.		 * 		 * @return Vector2D		 */		public function reversed() :Vector2D		{			var c:Vector2D = clone();			c.reverse();			return c;		}				/**		 * Reverses the direction of this vector.		 */		public function reverse() :void		{			multiply(-1);		}				/**		 * Returns a copy of this vector added to a given one.		 * 		 * @param	v	Vector2D		 * 		 * @return	Vector2D		 */		public function added( v:Vector2D ) :Vector2D		{			var c:Vector2D = clone();			c.add(v);			return c;		}				/**		 * Adds a vector to the current Vector.		 * 		 * @param	v	Vector2D		 */		public function add( v:Vector2D ) :void		{			precondition(_valid);						x += v.x;			y += v.y;		}				/**		 * Returns a copy of this vector rotated a given amount.		 * 		 * @param	a	Number, rotation in radians.		 * 		 * @return	Vector2D		 */		public function rotated( a:Number ) :Vector2D		{			var c:Vector2D = clone();			c.rotate( a );			return c;		}				/**		 * Rotates this vector a given amount.		 * 		 * @param	a	Number, rotation in radians		 */		public function rotate( a:Number ) :void		{			var x1:Number = Math.cos( a ) * x - Math.sin( a ) * y;			var y1:Number = Math.sin( a ) * x + Math.cos( a ) * y;			x = x1;			y = y1;		}				/**		 * Returns a copy of this vector multiplied by a scalar.		 * 		 * @param	s	Number		 * 		 * @return Vector2D		 */		public function multiplied( s:Number ) :Vector2D		{			var c:Vector2D = clone();			c.multiply(s);			return c;		}				/**		 * Multiplies the vector by a scalar.		 * 		 * @param	s	Number		 */		public function multiply( s:Number ) :void		{			x *= s;			y *= s;		}				/**		 * Returns the dot product of this vector and another vector.		 * 		 * @param	v	Vector2D		 * 		 * @return	Number		 */		public function dotProduct( v:Vector2D ) :Number		{			return (x * v.x) + (y * v.y);		}				/**		 * Returns the cross product of this vector and another vector.		 * 		 * @param v	Vector2D		 * 		 * @return	Number		 */		public function crossProduct( v:Vector2D ) :Number		{			return (x * v.y) - (y * v.x); 		}				/**		 * Returns the angle from this vector to another vector.		 * 		 * @param	v	Vector2D		 * 		 * @return	Number, angle in radians		 */		public function angleTo( v:Vector2D ) :Number		{			return Math.acos( dotProduct(v) / (length * v.length));		}				/**		 * Readies a vector for reuse in an object pool.		 */		internal function prepareForPooling():void		{			precondition(_valid);			x = 0;			y = 0;			_valid = false;		}				/**		 * Called internally when a pooled vector is called back to life from		 * an object pool.		 * 		 * @param	x	Number		 * @param	y	Number		 */		internal function restoreFromPooling( x:Number, y:Number ) :void		{			this.x = x;			this.y = y;			this._valid = true;		}				/**		 * Allows for error checking -- no vector that's been sent to an object		 * pool should ever be in use afterwards.		 * 		 * @param	Boolean, true if the object has been sent to an object pool.		 */		public function get inPool() :Boolean		{			return !_valid;		}				/**		 * Simple string dump.		 * 		 * @return String		 */		public function toString() :String		{			return sprintf("[Vector2D (%s, %s) (%sº)]", x, y, radiansToDegrees(angle));		}	}}