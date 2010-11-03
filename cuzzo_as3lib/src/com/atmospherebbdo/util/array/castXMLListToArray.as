package com.atmospherebbdo.util.array 
{
	/**
	 * Hack to cast XMLLists to Arrays.
	 * 
	 * @param	list	XMLList
	 * 
	 * @return Array
	 */	public function castXMLListToArray( list:XMLList ) :Array
	{
		return list.toXMLString().split("\n");
	}}