package com.atmospherebbdo.util.array 
{
	import com.atmospherebbdo.util.clone;	
	
	/**
	 * Generates a multidimensional array.
	 * 
	 * @param	...	Integer sizes of array dimensions. 5, 4, 3, wpuld create
	 * 			a 5 x 4 x 3 3-dimensional array.
	 * 			
	 * @return	a multidimensional Array.
	 */
	public function createMultidimensionalArray( ... rest) :Array
	{
		var output:Array;
		
		if (rest.length == 0)
		{
			output = undefined;
		}
		else
		{
			var length:uint = rest.shift();
			output = new Array( length );
			
			// recursively generate sub-dimensions
			if (rest.length > 0)
			{
				for (var i:Number = 0; i < output.length; i++)
				{
					var restClone:Array = clone(rest) as Array;
					output[i] = createMultidimensionalArray.apply(null, restClone);
				}
			}
		}
		return output;
	}}