package com.atmospherebbdo.rules 
{

	/**
	 * @author Mark Hawley
	 * 
	 * A simple rules engine.
	 */
	public class RulesEngine 
	{
		// condition/fact matching
		private var matcher:IPatternMatchingStrategy;
		
		// list of Rules
		private var rules:Array;

		/**
		 * Constructor.
		 * 
		 * @param	pms	IPatterMatchingStrategy
		 */
		public function RulesEngine( pms:IPatternMatchingStrategy )
		{
			matcher = pms;
			rules = [];
		}
		
		/**
		 * Adds a fact to the rules engine.
		 * 
		 * @param	fact	*, any object.
		 */
		public function assert( fact:* ) :void
		{
			matcher.addFact(fact);
		}
		
		/**
		 * Runs the rules engine on the current set of facts and rules. Rules
		 * which apply to the current state of facts will have their result
		 * functions execute.
		 */
		public function match() :void
		{
			matcher.match( rules );
		}
		
		/**
		 * Removes a fact from the rules engine. Does nothing if the fact is not
		 * present in the rules engine.
		 * 
		 * @param	fact	*, any object.
		 */
		public function remove( fact:* ) :void
		{
			matcher.removeFact(fact);
		}

		/**
		 * Adds a rule to the rules engine.
		 * 
		 * @param	rule	Rule
		 */		
		public function addRule( rule:Rule ) :void
		{
			rules.push( rule );
		}
		
		/**
		 * Removes a rule from the rules engine. Does nothing if the rule is not
		 * present in the rules engine.
		 * 
		 * @param	rule	Rule.
		 */
		public function removeRule( rule:Rule ) :void
		{
			rules = rules.filter( function (item:Rule) :Boolean
			{
				return item != rule;
			}, this);
		}
	}
}
