package com.atmospherebbdo.rules 
{
	import com.atmospherebbdo.rules.IPatternMatchingStrategy;		

	/**
	 * @author Mark Hawley
	 * 
	 * Naive rules engine pattern matching strategy.
	 */
	public class BasicMatchingStrategy implements IPatternMatchingStrategy 
	{
		private var facts:Array;
		
		/**
		 * Constructor.
		 */
		public function BasicMatchingStrategy() 
		{
			facts = [];
		}
		
		/**
		 * Adds a 'fact'. A fact can be any kind of object.
		 * 
		 * @param	fact	*
		 */
		public function addFact( fact:* ) :void
		{
			facts.push( fact );
		}
		
		/**
		 * Removes a 'fact'. A fact can be any kind of object. If the fact
		 * is not present in the rules engine, nothing happens.
		 * 
		 * @param	fact	*
		 */
		public function removeFact( fact:* ) :void
		{
			facts = facts.filter( function (item:*, index:int, array:Array) :Boolean
			{
				return item != fact;
			}, this);
		}
		
		/**
		 * Takes a list of Rules and performs the result function for each passing
		 * rule condition.
		 * 
		 * @param	rules	Array of Rules
		 */
		public function match( rules:Array ) :void
		{
			// evaluate all rules in turn
			rules.forEach( function (rule:Rule, index:int, array:Array ) :void
			{
				rule.evaluate( facts );	
			}, null);
		}
	}
}
