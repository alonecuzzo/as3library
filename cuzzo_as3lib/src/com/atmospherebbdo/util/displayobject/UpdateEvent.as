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
 * 
 * Hijacked for use in the rest of the as3Lib by mark.
 */

package com.atmospherebbdo.util.displayobject
{
	import flash.events.Event;

	/**
	 * The class for particle related events dispatched by classes in the Flint project.
	 */
	public class UpdateEvent extends Event
	{
		/**
		 * The event dispatched on the enter frame
		 */
		public static var UPDATE:String = "update";
		
		/**
		 * The number of seconds since the last UPDATE event.
		 */
		public var time:Number;
		
		/**
		 * The constructor creates a UpdateEvent object.
		 * 
		 * @param type The type of the event, accessible as Event.type.
		 * @param time	Number, the number of secondssince the last UPDATE event
		 * @param bubbles Determines whether the Event object participates 
		 * in the bubbling stage of the event flow. The default value is false.
		 * @param cancelable Determines whether the Event object can be 
		 * canceled. The default values is false.
		 */
		public function UpdateEvent( type : String, time:Number = NaN, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super(type, bubbles, cancelable);
			this.time = time;
		}
		
		/**
		 * Returns the current frames per second.
		 * 
		 * @return Number
		 */
		public function get fps() :Number
		{
			 return 1 / time;
		}
		
		/**
		 * Creates a copy of this event.
		 * 
		 * @return The copy of this event.
		 */
		override public function clone():Event
		{
			return new UpdateEvent( type, time, bubbles, cancelable );
		}
	}
}