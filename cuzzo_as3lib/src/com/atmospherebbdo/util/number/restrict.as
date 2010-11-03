package com.atmospherebbdo.util.number 
{	import com.atmospherebbdo.dbc.precondition;	
	
	/**
     * Adapted from as3Lib.
     * 
     * Returns a number within an upper and lower limit.
     * 
     * @param value The number to limit
     * @param lowLimit The lowest value that will be returned.
     * @param highLimit The highest value that will be returned.
     * 
     * @return value if lowLimit &lt; value &lt; highLimit, otherwise returns the lowLimit or highLimit.
     */
    public function restrict(value:Number, lowLimit:Number, highLimit:Number):Number 
    {
    	precondition( lowLimit <= highLimit );
    	
    	return Math.max(lowLimit, Math.min(highLimit, value)); 
    }
}