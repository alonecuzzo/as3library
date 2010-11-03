package com.atmospherebbdo.animation 
{
	import gs.TweenMax;
	
	import com.atmospherebbdo.animation.IAnimationPackage;
	import com.atmospherebbdo.assertions.checkState;	

	/**
	 * @author mark hawley
	 * 
	 * Bare minimum TweenMax animation package.
	 */
	public class TweenMaxMinimalAnimationPackage implements IAnimationPackage 
	{
		public static var instance:IAnimationPackage;
		
		/**
		 * Constructor. Should only be called once, as this is a
		 * singleton class.
		 * 
		 * @throws	IllegalStateError
		 */
		public function TweenMaxMinimalAnimationPackage()
		{
			checkState(instance == null, "Use getInstance() instead.");
		}
		
		/**
		 * Animates to the given values over a duration.
		 * 
		 * @param obj	Object to animate
		 * @param duration	Number, in seconds
		 * @param params	Object hash of names/values
		 * 
		 * @return	IAnimation
		 */
		public function to(obj:Object, duration:Number, params:*): IAnimation
		{
			return new TweenLiteAnimation(TweenMax.to(obj, duration, params));
		}
		
		/**
		 * Animates from the given values over a duration.
		 * 
		 * @param obj	Object to animate
		 * @param duration	Number, in seconds
		 * @param params	Object hash of names/values
		 * 
		 * @return	IAnimation
		 */
		public function from(obj:Object, duration:Number, params:*): IAnimation
		{
			return new TweenLiteAnimation(TweenMax.from(obj, duration, params));
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
				instance = new TweenMaxMinimalAnimationPackage();
			}
			return instance;
		}
	}
}
