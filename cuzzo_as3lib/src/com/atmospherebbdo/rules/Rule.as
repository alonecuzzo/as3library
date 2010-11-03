package com.atmospherebbdo.rules 
{

	/**
	 * @author Mark Hawley
	 * 
	 * A rule for a simple rules engine. Consists of a left-hand side (the 
	 * conditions in which the rule applies) and a right-hand side (the
	 * function that executes when the rule applies.)
	 */
	public class Rule 
	{
		private var lhs:Array;
		private var rhs:Function;

		/**
		 * Constructor.
		 * 
		 * @param	conditions	Array of Conditions, the left-hand side
		 * @param	result	Function, called when all conditions are found
		 * 					to be true. The result function must take an Object
		 * 					as the first and only argument. Objects referred to
		 * 					within the Conditions may be accessed within this
		 * 					argument by the ID supplied in the Condition. For
		 * 					example, if a Condition in a given rule was
		 * 					constructed via 
		 * 					<code>
		 * 					new Condition("I", InsurancePolicy);
		 * 					</code>
		 * 					the result function could refer to the InsurancePolicy
		 * 					object via obj.I.
		 * 					
		 * 	@see com.atmospherebbdo.rules.RulesEngineTest
		 */
		public function Rule( conditions:Array, result:Function )
		{
			this.lhs = conditions;
			this.rhs = result;
		}
		
		/**
		 * Applies a list of facts to this Rule, executing the right-hand-side
		 * if the facts satisfy the Rule's conditions.
		 * 
		 * @param	facts	Array of objects of any type.
		 */
		public function evaluate( facts:Array ) :void
		{
			var hash:Object = {};
			
			var allConditionsPass:Boolean = true;
			lhs.forEach( function (condition:Condition, index:int, array:Array) :void
			{
				var conditionPassed:Boolean = false;
				facts.forEach( function (fact:*, index:int, array:Array) :void
				{
					if (condition.evaluate(fact))
					{
						hash[ condition.ID ] = fact;
						conditionPassed = true;
					}
				}, null);
				allConditionsPass &&= conditionPassed;
			}, null);
			
			if (allConditionsPass)
			{
				rhs(hash);
			}
			else
			{
				trace("Rule failed.");
			}
		}
	}
}
