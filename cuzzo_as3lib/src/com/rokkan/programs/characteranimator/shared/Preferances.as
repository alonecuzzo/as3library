package com.rokkan.programs.characteranimator.shared 
{
	import flash.filesystem.*;
	import flash.net.SharedObject;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class Preferances 
	{
		
		public function Preferances() 
		{
			
		}
		
		public static function set lastDirectory( file:File ) {
			var so:SharedObject = SharedObject.getLocal("rokkanCharacterAnimator");
			so.data.lastDirectory = file.url;
			so.flush();
		}
		
		public static function get lastDirectory():File {
			var so:SharedObject = SharedObject.getLocal("rokkanCharacterAnimator");
			if (so.data.lastDirectory != null) {
				var stripName:String = so.data.lastDirectory;
				stripName = stripName.substring(0, stripName.lastIndexOf("/"));
				return new File(stripName);
			}
			return File.documentsDirectory;
		}
		
	}
	
}