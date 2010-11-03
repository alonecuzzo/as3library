package com.atmospherebbdo.load {	import com.atmospherebbdo.assertions.checkState;		/**	 * @author markhawley	 * 	 * Defines a type of loadable object.	 */	public class LoadItemType 	{		// stops instances of this type from being defined at runtime		private static var allowInstantiation:Boolean = true;				/**		 * Binary file type.		 */		public static const BINARY:LoadItemType = new LoadItemType("binary");		/**		 * Image file type.		 */		public static const IMAGE:LoadItemType = new LoadItemType("image");		/**		 * SWF file type.		 */		public static const MOVIECLIP:LoadItemType = new LoadItemType("movieclip");		/**		 * Sound file type.		 */		public static const SOUND:LoadItemType = new LoadItemType("sound");		/**		 * Text file type.		 */		public static const TEXT:LoadItemType = new LoadItemType("text");		/**		 * XML file type.		 */		public static const XML:LoadItemType = new LoadItemType("xml");		/**		 * Video file type.		 */		public static const VIDEO:LoadItemType = new LoadItemType("video");				{			// cannot instantiate LoadItemTypes once the compiler sees this			allowInstantiation = false;		}				/**		 * String representation of this type.		 */		private var name:String;				/**		 * Constructor.		 * 		 * @param	name	String, used as the primitive type for this object		 */		public function LoadItemType( name:String )		{			checkState(allowInstantiation);						this.name = name;		}				/**		 * Redefines primitive type of this object to be the object's name.		 * 		 * @return Object, the name of the object as a string		 */		public function valueOf() :Object		{			return name;		}				/**		 * Simple string dump.		 * 		 * @return String		 */		public function toString() :String		{			return name;		}	}}