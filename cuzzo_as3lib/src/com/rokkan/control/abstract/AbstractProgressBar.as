package com.rokkan.control.abstract 
{
	import com.rokkan.core.UIComponent;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	/**
	 * The <code>AbstractProgressBar</code> class is a base class that can be used when creating a custom
	 * progress bar. Most custom progress bars will have unique behavior and this class is designed with 
	 * that in mind. Common progress bar behavior has been abstracted and provided through protected 
	 * properties and methods so that your custom progress bar may make use of them or override them with 
	 * custom functionality. In most cases a custom progress bar simply needs to override the 
	 * <code>progress</code> setter method. When extending <code>AbstractProgressBar</code> be sure to supply 
	 * the super's constructor with a reference to your custom class or will receive an IllegalOperationError. 
	 * 
	 * @example <div class="listing"><pre>package
	 * {
	 *     import com.rokkan.control.abstract.AbstractProgressBar
	 *     import flash.display.Sprite;
	 * 
	 *     class CustomProgressBar extends AbstractProgressBar
	 *     {
	 *          
	 *         public var bar:Sprite;
	 * 
	 *         public function CustomProgressBar()
	 *         {
	 *             super( this );
	 *             bar = new Sprite();
	 *             bar.graphics.beginFill( 0x000000, 1 );
	 *    	       bar.graphics.lineTo( 100, 0 );
	 *             bar.graphics.lineTo( 100, 10 );
	 *             bar.graphics.lineTo( 0, 10 );
	 *             bar.graphics.lineTo( 0, 0 );
	 *             bar.graphics.endFill();
	 *             this.addChild( bar );
	 *             this.progress = 0;
	 *         }
	 * 
	 *         override public function set progress( v:Number ):void
	 *         {
	 *             super.progress = v;
	 *             bar.scaleX = this.progress;
	 *         }
	 * 
	 *     }
	 * }</div></pre>
	 */
	public class AbstractProgressBar extends UIComponent
	{
		/**
		 * The progress value.
		 */
		protected var _progress:Number;
		
		/**
		 * Creates a new <code>AbstractProgressBar</code> instance
		 * @param	self	A reference to the object/class extending <code>AbstractProgressBar</code>
		 * @throws flash.errors.IllegalOperationError The constructor must receive a reference to
		 * the object/class extending <code>AbstractProgressBar</code>.
		 */
		public function AbstractProgressBar( self:AbstractProgressBar ) 
		{
			if ( self != this )
			{
				throw new IllegalOperationError("AbstractProgressBar did not receive reference to self. " +
					"AbstractProgressBar cannot be instantiated directly and must be extended.");
			}
		}
		
		/**
		 * Specifies the progress value. This value is a number between 0 and 1.
		 */
		public function get progress():Number
		{
			return _progress;
		}
		
		public function set progress( v:Number ):void
		{
			_progress = Math.min( 1, Math.max( 0, v ) );
		}
		
	}
	
}
