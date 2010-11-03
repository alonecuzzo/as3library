package com.atmospherebbdo.util 
{
	import com.atmospherebbdo.util.displayobject.cloneDisplayObject;
	
	import flash.display.DisplayObject;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;	
	
	
		
	
	/**
	 * Attempts to clone any object.
	 * 
	 * @param	source	*
	 * 
	 * @return *
	 */
	public function clone( source:* ) :*
	{
		var output:* = null;
		var copier:ByteArray = new ByteArray();
		var clazz:Class = null;
		
		if (source is Array)
		{
			output = [];
			for (var i:uint=0; i < source.length; i++)
			{
				output[i] = clone(source[i]);
			}
		}
		else if (source is DisplayObject)
		{
			var disObj:DisplayObject = source as DisplayObject;
			return cloneDisplayObject(disObj);
		}
		else
		{
			if (source is Function)
			{
				clazz = Function;
			}
			else
			{
				var className:String = getQualifiedClassName( source );
				var qualifiedClassName:String = className.replace( "::", "." );
				clazz = getDefinitionByName( qualifiedClassName ) as Class;
				
				registerClassAlias( qualifiedClassName, clazz );
			}
			
			copier.writeObject(source);
			copier.position = 0;
			
			output = copier.readObject();
			output = output as clazz;
		}
		return output;
	}
}
