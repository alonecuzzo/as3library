package com.atmospherebbdo.util.displayobject {	import com.atmospherebbdo.assertions.fail;	import com.atmospherebbdo.util.displayobject.AbstractAlignment;		/**	 * @author markhawley	 */	public class HorizontalAlignment extends AbstractAlignment 	{		private static var initialized:Boolean = false;				public static const LEFT:HorizontalAlignment = new HorizontalAlignment( "left" );		public static const RIGHT:HorizontalAlignment = new HorizontalAlignment( "right" );		public static const CENTER:HorizontalAlignment = new HorizontalAlignment( "center" );				{			initialized = true;		}				public function HorizontalAlignment(name:String)		{			if (initialized)			{				fail("This class is intended to only be instantiated at " +					"compile time.");			}						super(name);		}	}}