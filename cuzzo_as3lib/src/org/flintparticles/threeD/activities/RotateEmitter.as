/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord (Big Room)
 * Copyright (c) Big Room Ventures Ltd. 2008
 * http://flintparticles.org
 * 
 * 
 * Licence Agreement
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package org.flintparticles.threeD.activities
{
	import org.flintparticles.common.activities.ActivityBase;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.threeD.emitters.Emitter3D;
	import org.flintparticles.threeD.geom.Quaternion;
	import org.flintparticles.threeD.geom.Vector3D;	

	/**
	 * The RotateEmitter activity rotates the emitter at a constant rate.
	 */
	public class RotateEmitter extends ActivityBase
	{
		private var _angularVelocity:Vector3D;
		private var q:Quaternion;
		private var temp:Quaternion;

		/**
		 * The constructor creates a RotateEmitter activity for use by 
		 * an emitter. To add a RotateEmitter to an emitter, use the
		 * emitter's addActvity method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter::addActivity()
		 * 
		 * @para angularVelocity The angular velocity for the emitter in 
		 * radians per second.
		 */
		public function RotateEmitter( angularVelocity:Vector3D )
		{
			_angularVelocity = angularVelocity.clone();
			temp = new Quaternion();
			q = new Quaternion(0, angularVelocity.x * 0.5, angularVelocity.y * 0.5, angularVelocity.z * 0.5);
		}

		/**
		 * The angular velocity for the emitter in 
		 * radians per second.
		 */
		public function get angularVelocity():Vector3D
		{
			return _angularVelocity;
		}

		public function set angularVelocity( value:Vector3D ):void
		{
			_angularVelocity = value.clone();
			q.w = 0;
			q.x = _angularVelocity.x * 0.5;
			q.y = _angularVelocity.y * 0.5;
			q.z = _angularVelocity.z * 0.5;
		}

		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, time:Number ):void
		{
			var e:Emitter3D = Emitter3D(emitter);
			temp.assign(q);
			temp.postMultiplyBy(e.rotation);
			e.rotation.incrementBy(temp.scaleBy(time)).normalize();
		}
	}
}