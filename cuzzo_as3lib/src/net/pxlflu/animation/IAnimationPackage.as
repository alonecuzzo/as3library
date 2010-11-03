package com.atmospherebbdo.animation 
{

	/**
	 * @author mark hawley
	 * 
	 * Interface for animation packages.
	 */
	public interface IAnimationPackage 
	{
		function to(obj:Object, duration:Number, params:*) :IAnimation;
		function from(obj:Object, duration:Number, params:*) :IAnimation;
	}
}
