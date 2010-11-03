package com.atmospherebbdo.animation 
{
	import gs.TweenLite;
	import gs.plugins.AutoAlphaPlugin;
	import gs.plugins.EndArrayPlugin;
	import gs.plugins.FramePlugin;
	import gs.plugins.RemoveTintPlugin;
	import gs.plugins.TintPlugin;
	import gs.plugins.TweenPlugin;
	import gs.plugins.VisiblePlugin;
	import gs.plugins.VolumePlugin;
	
	import com.atmospherebbdo.animation.IAnimationPackage;
	import com.atmospherebbdo.assertions.checkState;	

	/**
	 * @author mark hawley
	 * 
	 * Animation package with all default TweenLite plugins enabled.
	 */
	public class TweenLiteAnimationPackage implements IAnimationPackage
	{
		public static var instance:IAnimationPackage;
		
		private static const PLUGINS:Array =
		[
			TintPlugin,					//tweens tints
			RemoveTintPlugin,			//allows you to remove a tint
			FramePlugin,				//tweens MovieClip frames
			AutoAlphaPlugin,			//tweens alpha and then toggles "visible" to false if/when alpha is zero
			VisiblePlugin,				//tweens a target's "visible" property
			VolumePlugin,				//tweens the volume of a MovieClip or SoundChannel or anything with a "soundTransform" property
			EndArrayPlugin				//tweens numbers in an Array	
		];
		
		/**
		 * Constructor. Should only be called once, as this is a
		 * singleton class.
		 * 
		 * @throws	IllegalStateError
		 */
		public function TweenLiteAnimationPackage()
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
			return new TweenLiteAnimation(TweenLite.to(obj, duration, params));
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
				TweenPlugin.activate(PLUGINS);
			}
			return instance;
		}
	}
}
