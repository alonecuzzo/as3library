package com.atmospherebbdo.util.number 
{
	/**
	 * Compare two numbers. returning true if they are 'close enough.'
	 * 
	 * @param	n1	Number
	 * @param	n2	Number
	 * @param	epsilon	Number
	 * 
	 * @return Boolean
	 */
	public function epsilonCompare(n1:Number, n2:Number, epsilon:Number=.02) :Boolean
	{
		return (Math.abs(n1 - n2) < Math.abs(epsilon));
	}}