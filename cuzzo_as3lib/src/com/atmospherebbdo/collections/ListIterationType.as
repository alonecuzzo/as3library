package com.atmospherebbdo.collections {	import com.atmospherebbdo.collections.IterationType;		/**	 * @author markhawley	 * 	 * Enumeration of types of iterators that work on Lists.	 */	public class ListIterationType extends IterationType 	{		public static const RANDOM:IterationType = new IterationType();		public static const ORDERED:IterationType = new IterationType();		public static const LOOPING:IterationType = new IterationType();		public static const REVERSE:IterationType = new IterationType();	}}