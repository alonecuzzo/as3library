package com.atmospherebbdo.animation 
{
	import com.atmospherebbdo.assertions.checkArgument;
	import com.atmospherebbdo.dbc.precondition;
	import com.atmospherebbdo.errors.IllegalStateError;
	import com.atmospherebbdo.util.IDestroyable;	

	/**
	 * @author mark hawley
	 * 
	 * Handles animations via one of the animation packages for a 
	 * specific object.
	 */
	public class Animator implements IDestroyable
	{
		public static var defaultAnimationPackage:IAnimationPackage;

		// the thing to animate
		private var animated:Object;
		private var animationPackage:IAnimationPackage = null;
		
		private var _isDestroyed:Boolean = false;

		/**
		 * Constructor.
		 * 
		 * @param	obj	Object to animate
		 */
		public function Animator( obj:Object, animationPackage:IAnimationPackage=null )
		{
			checkArgument(!(obj is Animator), "Cannot animate an " +
				"animator.");
			
			animated = obj;
			
			if (animationPackage == null)
			{
				animationPackage = defaultAnimationPackage;
			}
			if (animationPackage == null)
			{
				animated = null;
				throw new IllegalStateError("Cannot create Animator: No " +
					"animation package defined.");
			}
			this.animationPackage = animationPackage;
		}

		/**
		 * Animates the animated object to the endpoint described in the tween
		 * description from current values.
		 * 
		 * @param	duration	Number, in seconds
		 * @param	td			Object, describing the end point.
		 */
		public function to( duration:Number, td:* ):*
		{
			precondition(!isDestroyed());
			
			return animationPackage.to(animated, duration, td);
		}
	
		/**
		 * Animates the animated object from the endpoint described in the tween
		 * description to current values.
		 * 
		 * @param	duration	Number, in seconds
		 * @param	td			Object, describing the start point.
		 */
		public function from( duration:Number, td:* ):*
		{
			precondition(!isDestroyed());
			
			return animationPackage.from(animated, duration, td);
		}
	
		/**
		 * Cleans up when finished.
		 */
		public function destroy():void
		{
			animated = null;
			animationPackage = null;
			
			_isDestroyed = false;
		}
		public function isDestroyed():Boolean		{
			return _isDestroyed;
		}
	}
}
