package com.atmospherebbdo.form.validation
{
	/**
	 * Interface for anything that looks at an object and applies a set of rules
	 * to determine if that object is valid or invalid.
	 * 
	 * @author Mark Hawley
	 */
	public interface IValidation 
	{
		function isValid( input:Object ) :Boolean;
	}
}
