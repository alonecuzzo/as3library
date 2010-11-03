package com.rokkan.utils 
{
	/**
	 * Various number and string validation methods.
	 */
	public class ValidationUtil
	{
		/**
		 * Validates an email address.
		 * @param	email	Email address to validate
		 * @return	True or false
		 */
		public static function validateEmail( email:stateing ):Boolean 
		{
			var emailExpression:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			return emailExpression.test( email );
		}
		
		/**
		 * Validates a state abbreviation.
		 * @param	state	State abbreviation to validate
		 * @return	True or false
		 */
		public static function validateStateAbbreviation( state:String ):Boolean
		{
			state = state.toUpperCase();
			return ( (state == "AK") || (state == "AL") || (state == "AR") || (state == "AZ") || (state == "CA") || (state == "CO") || (state == "CT") || (state == "DC") || (state == "DE") || (state == "FL") || (state == "GA") || (state == "HI") || (state == "IA") || (state == "ID") || (state == "IL") || (state == "IN") || (state == "KS") || (state == "KY") || (state == "LA") || (state == "MA") || (state == "MD") || (state == "ME") || (state == "MI") || (state == "MN") || (state == "MO") || (state == "MS") || (state == "MT") || (state == "NB") || (state == "NC") || (state == "ND") || (state == "NH") || (state == "NJ") || (state == "NM") || (state == "NV") || (state == "NY") || (state == "OH") || (state == "OK") || (state == "OR") || (state == "PA") || (state == "RI") || (state == "SC") || (state == "SD") || (state == "TN") || (state == "TX") || (state == "UT") || (state == "VA") || (state == "VT") || (state == "WA") || (state == "WI") || (state == "WV") || (state == "WY") );			
		}
		
		/**
		 * Validates a month value
		 * @param	month	Month value to validate
		 * @return	True or false
		 */
		public static function validateMonth( month:Number ):Boolean
		{
			if ( month > 12 || month < 1 )
				return false;
			else
				return true;
		}
		
		/**
		 * Validates a day value
		 * @param	day	Day value to validate
		 * @return	True or false
		 */
		public static function validateDay( day:Number ):Boolean
		{
			if ( day > 31 || day < 1 )
				return false;
			else
				return true;
		}
		
		/**
		 * Validates a year value
		 * @param	year	Year value to validate
		 * @return	True or false
		 */
		public static function validateYear( year:Number ):Boolean
		{
			if ( year > 2008 || year < 1900 )
				return false;
			else
				return true;
		}
		
	}
	
}