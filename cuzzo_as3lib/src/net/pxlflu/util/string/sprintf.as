package com.atmospherebbdo.util.string
{	import br.com.stimuli.string.printf;
		
	/**
	 * Wraps printf.
	 * 
	 * @param	input	String, formatted for printf
	 * @param	...	Varies.
	 * 
	 * @return	String
	 * 
	 * @see	br.com.stimuli.string.printf
	 */
	public function sprintf( input:String, ... rest ) :String
	{
		rest.unshift(input);
		for (var key:String in rest)
		{
			if (rest[key] === undefined)
			{
				rest[key] = "undefined";
			}
			if (rest[key] === null)
			{
				rest[key] = "null";
			}
		}
		return printf.apply( null, rest );
	}}