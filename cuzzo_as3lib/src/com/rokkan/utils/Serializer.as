package com.rokkan.utils 
{
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	
	/**
	* Serializer - Serialize and Deserialize Methods
	* @author Russell Savage
	*/
	public class Serializer 
	{
		public static const FILTER_POSITIONS:uint = 0;
		public static const FILTER_POSITIONS_3D:uint = 1;
		public static const FILTER_NUMBERS:uint = 2;
		
		public static var filterDict:Dictionary;
		private static var _ser:Serializer;
		
		public function Serializer() 
		{
			filterDict = new Dictionary();
			filterDict[ FILTER_POSITIONS ] = ["x", "y", "rotationX", "rotationY"];
			filterDict[ FILTER_POSITIONS_3D ] = ["x", "y", "z", "rotationX", "rotationY", "rotationZ"];
		}
		
		/**
		 * Serialize an Object - converts an objects properties to a string form
		 * 
		 * @param	object to serialize
		 * @param	extra properties to serialize besides the standard ones (x,y,rotation,scaleX,scaleY)
		 * 			the array is in the form [ [ varName, varDefaultValue ], ...]
		 * @param	amount to restrict the number length to
		 */
		public static function serialize( obj, extraProps:Array = null, restrictNums = 5 ):String {
			var output:String = "";
			if (obj.x != null && obj.x != 0) {
				output += ",x:" + minNumChars(obj.x, restrictNums);
			}
			if (obj.y != null && obj.y != 0) {
				output += ",y:" + minNumChars(obj.y);
			}
			if (obj.rotation != null && obj.rotation != 0) {
				output += ",rotation:" + minNumChars(obj.rotation, restrictNums);
			}
			if (obj.scaleX != null && obj.scaleX != 1) {
				output += ",scaleX:" + minNumChars(obj.scaleX, restrictNums);
			}
			if (obj.scaleY != null && obj.scaleY != 1) {
				output += ",scaleY:" + minNumChars(obj.scaleY, restrictNums);
			}
			
			if (extraProps != null) {
				var value;
				for (var i:uint = 0; i < extraProps.length; i++) {
					value = obj[ extraProps[i][0] ];
					if (value != null && value != extraProps[i][2] ) {
						output += "," + extraProps[i][0] + ":" + value;
					}
				}
			}
			
			if (output.length > 1) {
				output = output.substr(1);
			}
			
			return output;
		}
		
		public static function jsonTo( obj, filter:int = -1 ):String {
			if (_ser == null) {
				_ser = new Serializer();
			}
			
			var jsonOutput:String = "{";
			
			var adjustValues = new Array();
			var xml:XML = flash.utils.describeType(obj);
			var properties = xml..variable.@name + xml..accessor.@name;
			//trace("obj:"+obj+" xml:" + xml + " properties.length():" + properties.length());
			if (properties.length() <= 0) {
				properties = obj;
			}
			for each (var k in properties){
				try {
					if (obj[k] is Number ) {
						if (filter == FILTER_NUMBERS ) {
							//trace("pushing k:" + k);
							adjustValues.push( k );
						}else if(filter<0 || (filter>=0 && ArrayMethods.isStrInArray( filterDict[ filter ], k ))){
							//trace("push normal k:" + k);
							adjustValues.push( k );
						}
						//trace("Object property: " + k + ", Property value: " + obj[k]);
					}
				}catch ( error ) {
					//trace("error with k:" + k + " error:"+error);
				}
			}
			adjustValues.sort();
			
			for (var i:uint = 0; i < adjustValues.length; i++) {
				jsonOutput += adjustValues[i] + ":" + NumberUtil.roundToDecimals( obj[ adjustValues[i] ], 4 );;
				if(i<adjustValues.length-1){
					jsonOutput += ",";
				}
			}
			
			jsonOutput += "}";
			
			return jsonOutput;
		}
		
		public static function jsonFrom( str:String, obj = null, castToClass:Class = null  ):Object {
			if (obj == null) {
				obj = new Object();
			}
			
			str = str.substr(1, str.length - 2);
			str = StringMethods.replaceStr( str, " ", "");
			//trace("cleaned:" + str);
			if (str.length <= 0) {
				return obj;
			}
			setProperties( obj, str, castToClass );
			return obj;
		}
		
		/**
		 * Restrict to Minimum Characters - Restricts the accuracy of numbers to a certain length of decimal points
		 * 
		 * @param	object to restrict number length
		 * @param	amount to restrict the length to
		 */
		public static function minNumChars( val, restr:Number = 5 ):String {
			if ( val is Number && String(val).length > restr && restr >= 0) {
				return val.toFixed( restr );
			}else {
				return String( val );
			}
		}
		
		/**
		 * Set Properties - Sets the properties of an object from a serialized string
		 * 
		 * @param	object to set properties on
		 * @param	serialized string - has properties in the format: "x:3,y:4,rotation:90"
		 */
		public static function setProperties( obj, str:String, castToClass:Class = null ):void {
			var propArr:Array = str.split(",");
			var subPairs:String;
			var propVal:String;
			var propName:String;
			
			var indexPt:uint;
			for (var i:uint = 0; i < propArr.length; i++) {
				subPairs = propArr[i];
				indexPt = subPairs.indexOf(":");
				propName = subPairs.substring(0, indexPt);
				propVal = subPairs.substring(indexPt + 1);
				obj[propName] = castToClass == null ? propVal : castToClass(propVal);
			}
		}
		
	}
	
}