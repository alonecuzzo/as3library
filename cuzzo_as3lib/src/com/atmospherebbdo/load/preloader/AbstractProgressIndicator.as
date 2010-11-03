package com.atmospherebbdo.load.preloader {	import com.atmospherebbdo.errors.AbstractMethodCallError;	import com.atmospherebbdo.util.instantiatedAs;		import flash.display.Sprite;		/**	 * @author markhawley	 * 	 * An abstract class that preloader applications can subclass for use in	 * simple loading bars.	 */	public class AbstractProgressIndicator extends Sprite 	{		/**		 * Constructor. Since this is an abstract class, it throws an error if		 * called as part of a direct instantiation of an AbstractProgessIndicator		 * instead of a subclass of itself.		 * 		 * @throws AbstractMethodCallError		 */		public function AbstractProgressIndicator()		{			if (instantiatedAs(this, AbstractProgressIndicator))			{				throw new AbstractMethodCallError("Cannot " +					"instantiate Abstract class.");			}		}				/**		 * Sets the progress state visually. Must be overridden by subclasses.		 * 		 * @param	current	Number		 * @param	max	Number		 * 		 * @throws AbstractMethodCallError		 */		public function setProgress( current:Number, max:Number ) :void		{			throw new AbstractMethodCallError();		}	}}