package com.atmospherebbdo.rules 
{

	/**
	 * @author Mark Hawley
	 * 
	 * Interface for rules engine pattern matching strategies.
	 */
	public interface IPatternMatchingStrategy 
	{
		function addFact( fact:* ) :void;
		function removeFact( fact:* ) :void;
		function match( rules:Array ) :void;
	}
}
