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
 * Hijacked for use in the rest of the AS3library by mark.
 */

package com.atmospherebbdo.util.displayobject 
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	import com.atmospherebbdo.util.displayobject.UpdateEvent;	

	[Event(name="update", type="com.atmospherebbdo.util.displayobject.UpdateEvent")]
	
	/**
	 * This class is used to provide a constant tick event to update the emitters
	 * every frame. This is the internal tick that is used when the useInternalTick
	 * property of the emitter is set to true.
	 * 
	 * <p>Usually developers don't need to use this class at all - its use is
	 * internal to the Emitter classes.</p>
	 * 
	 * @see org.flintparticles.common.emitters.Emitter.Emitter()
	 */
	public class FrameUpdater extends EventDispatcher
	{
		private static var _instance:FrameUpdater;
		
		/**
		 * This is a singleton instance. There's no requirement to use this singleton -
		 * the constructor isn't private (or in any other way restricted) and nothing
		 * will go wrong if you create multiple instances of the class. The singleton
		 * instance is provided for speed and memory optimization - it is usually 
		 * possible for all code to use the same instance and this singleton makes it
		 * easy for code to do this by all code using this singleton instance.
		 */
		public static function get instance():FrameUpdater
		{
			if( _instance ==  null )
			{
				_instance = new FrameUpdater();
			}
			return _instance;
		}
		
		private var _shape:Shape;
		private var _time:Number;
		private var _running:Boolean = false;
		
		/**
		 * Constructor.
		 */
		public function FrameUpdater()
		{
			_shape = new Shape();
		}
		
		/**
		 * Adds an event listener, and saves on resources by only running the
		 * updater if something is currently listening.
		 * 
		 * @param	type	String
		 * @param	listener	Function
		 * @param	useCapture	Boolean (defaults to false)
		 * @param	priority	int (defaults to 0)
		 * @param	weakReference	Boolean (defaults to false)
		 */
		override public function addEventListener( type:String, listener:Function,
			useCapture:Boolean = false, priority:int = 0, weakReference:Boolean = false ):void
		{
			super.addEventListener( type, listener, useCapture, priority, weakReference );
			if( ! _running && hasEventListener( UpdateEvent.UPDATE ) )
			{
				startTimer();
			}
		}
		
		/**
		 * Removes an event listener, and saves on resources by only running the
		 * updater if something is still listening.
		 * 
		 * @param	type	String
		 * @param	listener	Function
		 * @param	useCapture	Boolean (defaults to false)
		 */
		override public function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ):void
		{
			super.removeEventListener( type, listener, useCapture );
			if( _running && ! hasEventListener( UpdateEvent.UPDATE ) )
			{
				stopTimer();
			}
		}
		
		/**
		 * Starts broadcasting each ENTER_FRAME.
		 */
		private function startTimer():void
		{
			_shape.addEventListener( Event.ENTER_FRAME, frameUpdate, false, 0, true );
			_time = getTimer();
			_running = true;
		}
		
		/**
		 * Stops broadcasting each ENTER_FRAME.
		 */
		private function stopTimer():void
		{
			_shape.removeEventListener( Event.ENTER_FRAME, frameUpdate );
			_running = false;
		}

		/**
		 * Broadcasts an ENTER_FRAME.
		 * 
		 * @param	ev	Event
		 */
		private function frameUpdate( ev:Event ):void
		{
			var oldTime:int = _time;
			_time = getTimer();
			var frameTime:Number = ( _time - oldTime ) * 0.001;
			dispatchEvent( new UpdateEvent( UpdateEvent.UPDATE, frameTime ) );
		}
	}
}
