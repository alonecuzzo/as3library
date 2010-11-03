package com.rokkan.utils {
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class ArrayMethods {
		
		public function ArrayMethods() {
			
		}
		
		public static function arrayRemoveElem(arr:Array, pt:uint):Array {
			var newArr:Array = new Array( arr.length - 1);
			var k:uint = 0;
			for (var i:uint = 0; i < arr.length; i++) {
				if(i!=pt){
					newArr[k] = arr[i];
					k++;
				}
			}
			return newArr;
		}
		
		public static function arrayRemoveElemFind(arr:Array, obj:Object):Array {
			var newArr:Array = new Array( arr.length - 1);
			var k:uint = 0;
			for (var i:uint = 0; i < arr.length; i++) {
				if(obj!==arr[i]){
					newArr[k] = arr[i];
					k++;
				}
			}
			return newArr;
		}
		
		public static function combine( first:Array, second:Array ) {
			second.unshift.apply(null, first);
			
			return second;
		}
		
		public static function insertElem(arr:Array, elem, afterI:uint):Array {
			var firstArr:Array = arr.slice(0, afterI+1);
			firstArr.push(elem);
			firstArr = firstArr.concat( arr.slice(afterI+1));
			
			return firstArr;
		}
		
		public static function trace(arr:Array, func:Function = null ):String {
			
			var returnStr:String = "";
			for (var i:uint = 0; i < arr.length; i++) {
				if (arr[i] is Array) {
					returnStr += "[" + ArrayMethods.trace(arr[i], func) + "],";
				}else {
					if (func!=null) {
						returnStr = returnStr + func( arr[i] ) + ",";
					}else {
						returnStr = returnStr + arr[i] + ",";
					}
				}
				if (i+1==arr.length)
					returnStr = returnStr.substring(0, returnStr.length - 1);
			}
			
			
			return returnStr;
		}
		
		// Loops through the array, if an object in the array exists with the given name/value pair, it returns it
		public static function getObjectWithProperty(arr:Array, prop:String, val):Object { 
			for (var i:uint = 0; i < arr.length; i++) {
				if (arr[i][prop] != null && arr[i][prop]==val)
					return arr[i];
			}
			return false;
		}
		
		public static function isStrInArray(arr:Array, str:String):Boolean {
			for (var i:uint = 0; i < arr.length; i++) {
				if (arr[i] == str)
					return true;
			}
			return false;
		}
		
		public static function isValArray(arr:Array, varName:String, valEqual:String):int {
			for (var i:uint = 0; i < arr.length; i++) {
				if (arr[i][ varName ] == valEqual)
					return i;
			}
			return -1;
		}
		
		public static function traceProp(arr:Array, prop:String):String {
			var returnStr = "";
			for (var i:uint = 0; i < arr.length; i++) {
				returnStr += arr[i][prop] + ",";
			}
			returnStr = returnStr.substring(0, returnStr.length - 1);
			return returnStr;
		}
	}
	
}