package com.rokkan.control 
{
	
	import com.rokkan.control.abstract.AbstractScrollable;
	import com.rokkan.control.interfaces.IScrollable;
	
	/**
	 * The ScrollableContent control is a container to place content in which needs to
	 * be scrollable. Create an instance of this class and use the <code>addChild()</code> 
	 * method to add the scrollable content, then define the vertical and/or horizontal 
	 * scroll bars. This class also serves as an example of how to use the AbstractScrollable
	 * class and IScrollable interface.
	 */
	public class ScrollableContent extends AbstractScrollable implements IScrollable
	{
		
		/**
		 * Creates a new ScrollableContent instance.
		 */
		public function ScrollableContent() 
		{
			super( this );
		}
		
	}
	
}