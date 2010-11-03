package com.atmospherebbdo.animation 
{
	import gs.TweenLite;
	
	import com.atmospherebbdo.animation.IAnimationPackage;
	import com.atmospherebbdo.assertions.checkState;	

	/**
	 * @author mark hawley
	 * 
	 * Bare minimum TweenLite class.
	 */
	public class TweenLiteMinimalAnimationPackage implements IAnimationPackage 
	{
		public static var instance:IAnimationPackage;
		
		/**
		 * Constructor.
		 */
		public function TweenLiteMinimalAnimationPackage()
		{
			checkState(instance == null, "Use getInstance() instead.");
		}
		
		/**
		 * Animate to a set of values over a duration.
		 * 
		 * @param	obj	Object to animate
		 * @param	duration	Number, in seconds
		 * @param	params	Object, hash of name/values to animate to
		 * 
		 * @return	IAnimation
		 */
		public function to(obj:Object, duration:Number, params:*): IAnimation
		{
			return new TweenLiteAnimation(TweenLite.to(obj, duration, params));
		}
		
		/**
		 * Animate from a set of values over a duration, to the 
		 * current values.
		 * 
		 * @param	obj	Object to animate
		 * @param	duration	Number, in seconds
		 * @param	params	Object, hash of name/values to animate 
		 * 					from
		 * 
		 * @return	IAnimation
		 */
		public function from(obj:Object, duration:Number, params:*): IAnimation
		{
			return new TweenLiteAnimation(TweenLite.from(obj, duration, params));
		}
		
		/**
		 * Singleton accessor.
		 * 
		 * @return	IAnimationPackage
		 */
		public static function getInstance():IAnimationPackage
		{
			if (instance == null)
			{
				instance = new TweenLiteMinimalAnimationPackage();
			}
			return instance;
		}
		
		/**
		 * String dump.
		 * 
		 * @return	String
		 */
		public function toString() : String 
		{
			return "com.atmospherebbdo.animation.TweenLiteAnimationPackage";
		}
	}
}
