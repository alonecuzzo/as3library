package com.atmospherebbdo.application
{
	import com.atmospherebbdo.animation.IAnimationPackage;
	import com.atmospherebbdo.load.ILoader;		
	/**
	 * A value object used to configure an application.
	 */
	public class ApplicationDescription
	{
		/**
		 * a list of places to send logging information to.
		 */
		public var logDestinations:Array;
		
		/**
		 * the default animation package to use in the application.
		 */
		public var animationPackage:IAnimationPackage = null;
		
		/**
		 * flash vars to use when no 'real' flash vars are passed in.
		 * (used in the IDE, for example.)
		 */
		public var defaultFlashVars:Object = {};
		
		/**
		 * a loader full of files required by the application and already
		 * loaded and ready for it.
		 */
		public var preloadedFiles:ILoader = null;
	}
}

