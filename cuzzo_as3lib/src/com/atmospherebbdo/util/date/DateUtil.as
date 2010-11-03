/*
Copyright (c) 2008 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
 */
/*
Copyright (c) 2008, Adobe Systems Incorporated
All rights reserved.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are
met:

 * Redistributions of source code must retain the above copyright notice, 
this list of conditions and the following disclaimer.
  
 * Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the 
documentation and/or other materials provided with the distribution.
  
 * Neither the name of Adobe Systems Incorporated nor the names of its 
contributors may be used to endorse or promote products derived from 
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package com.atmospherebbdo.util.date
{		

	/**
	 * A collection of utility functions for the manipulation and inspection of date and time values.
	 * 
	 * @see Date
	 * 
	 * @author Josh Tynjala, Allen Rabinovich
	 * 
	 * (Very minor edits from mark hawley -- munging together various libs, as seen in the copyright
	 * info above)
	 */
	public class DateUtil
	{
		/**
		 * The names of months in English. The index in the array corresponds to the value of the month
		 * in a date object.
		 */
		public static const MONTHS:Array = ["January", "February", "March", "April", "May", "June", "July",
			"August", "September", "October", "November", "December"];
			
		public static const DAYS:Array = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

		public static const DAYS_IN_JANUARY:int = 31;
		public static const DAYS_IN_FEBRUARY:int = 28;
		public static const DAYS_IN_FEBRUARY_LEAP_YEAR:int = 29;
		public static const DAYS_IN_MARCH:int = 31;
		public static const DAYS_IN_APRIL:int = 30;
		public static const DAYS_IN_MAY:int = 31;
		public static const DAYS_IN_JUNE:int = 30;
		public static const DAYS_IN_JULY:int = 31;
		public static const DAYS_IN_AUGUST:int = 31;
		public static const DAYS_IN_SEPTEMBER:int = 30;
		public static const DAYS_IN_OCTOBER:int = 31;
		public static const DAYS_IN_NOVEMBER:int = 30;
		public static const DAYS_IN_DECEMBER:int = 31;
		public static const DAYS_IN_YEAR:int = 365;
		public static const DAYS_IN_LEAP_YEAR:int = 366;
		/**
		 * The number of days appearing in each month. May be used for easy index lookups.
		 * The stored value for February corresponds to a standard year--not a leap year.
		 */
		public static var daysInMonths:Array = [DAYS_IN_JANUARY, DAYS_IN_FEBRUARY, DAYS_IN_MARCH, DAYS_IN_APRIL,
			DAYS_IN_MAY, DAYS_IN_JUNE, DAYS_IN_JULY, DAYS_IN_AUGUST, DAYS_IN_SEPTEMBER,
			DAYS_IN_OCTOBER, DAYS_IN_NOVEMBER, DAYS_IN_DECEMBER];

		/**
		 * Determines the number of days between the start value and the end value. The result
		 * may contain a fractional part, so cast it to int if a whole number is desired.
		 * 
		 * @param		start	the starting date of the range
		 * @param		end		the ending date of the range
		 * @return		the number of dats between start and end
		 */
		public static function countDays(start:Date, end:Date):Number
		{
			return Math.abs(end.valueOf() - start.valueOf()) / (1000 * 60 * 60 * 24);
		}

		/**
		 * Determines if the input year is a leap year (with 366 days, rather than 365).
		 * 
		 * @param		year	the year value as stored in a Date object.
		 * @return		true if the year input is a leap year
		 */
		public static function isLeapYear(year:int):Boolean
		{
			if(year % 100 == 0) return year % 400 == 0;
			return year % 4 == 0;
		}

		/**
		 * Gets the English name of the month specified by index. This is the month value
		 * as stored in a Date object.
		 * 
		 * @param		index	the numeric value of the month
		 * @return		the string name of the month in English
		 */
		public static function getMonthName(index:int):String
		{
			return MONTHS[index];
		}

		/**
		 * Gets the abbreviated month name specified by index. This is the month value
		 * as stored in a Date object.
		 * 
		 * @param		index	the numeric value of the month
		 * @return		the short string name of the month in English
		 */
		public static function getShortMonthName(index:int):String
		{
			return getMonthName(index).substr(0, 3);
		}
		
		public static function getShortMonthIndex( name:String ) :int
		{
			var index:int = -1;
			// look through the list and return the index of the first match
			for (var i:uint=0; i < MONTHS.length; i++)
			{
				if (name == MONTHS[i].substr(0, 3))
				{
					index = i;
				}
			}
			return index;
		}

		/**
		 * Rounds a Date value up to the nearest value on the specified time unit.
		 * 
		 * @see com.yahoo.astra.utils.TimeUnit
		 */
		public static function roundUp(dateToRound:Date, timeUnit:String = "day"):Date
		{
			dateToRound = new Date(dateToRound.valueOf());
			switch(timeUnit)
			{
				case TimeUnit.YEAR:
					dateToRound.year++;
					dateToRound.month = 0;
					dateToRound.date = 1;
					dateToRound.hours = 0;
					dateToRound.minutes = 0;
					dateToRound.seconds = 0;
					dateToRound.milliseconds = 0;
					break;
				case TimeUnit.MONTH:
					dateToRound.month++;
					dateToRound.date = 1;
					dateToRound.hours = 0;
					dateToRound.minutes = 0;
					dateToRound.seconds = 0;
					dateToRound.milliseconds = 0;
					break;
				case TimeUnit.DAY:
					dateToRound.date++;
					dateToRound.hours = 0;
					dateToRound.minutes = 0;
					dateToRound.seconds = 0;
					dateToRound.milliseconds = 0;
					break;
				case TimeUnit.HOURS:
					dateToRound.hours++;
					dateToRound.minutes = 0;
					dateToRound.seconds = 0;
					dateToRound.milliseconds = 0;
					break;
				case TimeUnit.MINUTES:
					dateToRound.minutes++;
					dateToRound.seconds = 0;
					dateToRound.milliseconds = 0;
					break;
				case TimeUnit.SECONDS:
					dateToRound.seconds++;
					dateToRound.milliseconds = 0;
					break;
				case TimeUnit.MILLISECONDS:
					dateToRound.milliseconds++;
					break;
			}
			return dateToRound;
		}

		/**
		 * Rounds a Date value down to the nearest value on the specified time unit.
		 * 
		 * @see com.yahoo.astra.utils.TimeUnit
		 */
		public static function roundDown(dateToRound:Date, timeUnit:String = "day"):Date
		{
			dateToRound = new Date(dateToRound.valueOf());
			switch(timeUnit)
			{
				case TimeUnit.YEAR:
					dateToRound.month = 0;
					dateToRound.date = 1;
					dateToRound.hours = 0;
					dateToRound.minutes = 0;
					dateToRound.seconds = 0;
					dateToRound.milliseconds = 0;
					break;
				case TimeUnit.MONTH:
					dateToRound.date = 1;
					dateToRound.hours = 0;
					dateToRound.minutes = 0;
					dateToRound.seconds = 0;
					dateToRound.milliseconds = 0;
					break;
				case TimeUnit.DAY:
					dateToRound.hours = 0;
					dateToRound.minutes = 0;
					dateToRound.seconds = 0;
					dateToRound.milliseconds = 0;
					break;
				case TimeUnit.HOURS:
					dateToRound.minutes = 0;
					dateToRound.seconds = 0;
					dateToRound.milliseconds = 0;
					break;
				case TimeUnit.MINUTES:
					dateToRound.seconds = 0;
					dateToRound.milliseconds = 0;
					break;
				case TimeUnit.SECONDS:
					dateToRound.milliseconds = 0;
					break;
			}
			return dateToRound;
		}

		/**
		 * Converts a time code to UTC.
		 * 
		 * @param timecode	the input timecode
		 * @return			the UTC value
		 */
		public static function timeCodeToUTC(timecode:String):String 
		{
			switch (timecode) 
			{
				case "GMT": 
				case "UT":
				case "UTC": 
				case "WET":  
					return "UTC+0000";
				case "CET": 
					return "UTC+0100";
				case "EET": 
					return "UTC+0200";
				case "MSK": 
					return "UTC+0300";
				case "IRT": 
					return "UTC+0330";
				case "SAMT": 
					return "UTC+0400";
				case "YEKT":
				case "TMT": 
				case "TJT": 
					return "UTC+0500";
				case "OMST": 
				case "NOVT": 
				case "LKT": 
					return "UTC+0600";
				case "MMT": 
					return "UTC+0630";
				case "KRAT": 
				case "ICT": 
				case "WIT": 
				case "WAST": 
					return "UTC+0700";
				case "IRKT": 
				case "ULAT": 
				case "CST": 
				case "CIT": 
				case "BNT": 
					return "UTC+0800";
				case "YAKT": 
				case "JST": 
				case "KST": 
				case "EIT": 
					return "UTC+0900";
				case "ACST": 
					return "UTC+0930";
				case "VLAT": 
				case "SAKT": 
				case "GST": 
					return "UTC+1000";
				case "MAGT": 
					return "UTC+1100";
				case "IDLE": 
				case "PETT": 
				case "NZST": 
					return "UTC+1200";
				case "WAT": 
					return "UTC-0100";
				case "AT": 
					return "UTC-0200";
				case "EBT": 
					return "UTC-0300";
				case "NT": 
					return "UTC-0330";
				case "WBT": 
				case "AST": 
					return "UTC-0400";
				case "EST": 
					return "UTC-0500";
				case "CST": 
					return "UTC-0600";
				case "MST": 
					return "UTC-0700";
				case "PST": 
					return "UTC-0800";
				case "YST": 
					return "UTC-0900";
				case "AHST": 
				case "CAT": 
				case "HST": 
					return "UTC-1000";
				case "NT": 
					return "UTC-1100";
				case "IDLW": 
					return "UTC-1200";
			}
			return "UTC+0000";
		}

		/**
		 * Determines the hours value in the range 1 - 12 for the AM/PM time format.
		 * 
		 * @param value		the input Date value
		 * @return			the calculated hours value
		 */
		public static function getHoursIn12HourFormat(value:Date):Number
		{
			var hours:Number = value.getHours();
			if(hours == 0)
			{
				return 12;
			}
			
			if(hours > 0 && hours <= 12)
			{
				return hours;
			}
			
			return hours - 12;
		}

		/**
		 * Parses dates that conform to the W3C Date-time Format into Date objects.
		 *
		 * This function is useful for parsing RSS 1.0 and Atom 1.0 dates.
		 *
		 * @param str
		 *
		 * @returns
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 *
		 * @see http://www.w3.org/TR/NOTE-datetime
		 */                   
		public static function parseW3CDTF(str:String):Date
		{
			var finalDate:Date;
			try
			{
				var dateStr:String = str.substring(0, str.indexOf("T"));
				var timeStr:String = str.substring(str.indexOf("T") + 1, str.length);
				var dateArr:Array = dateStr.split("-");
				var year:Number = Number(dateArr.shift());
				var month:Number = Number(dateArr.shift());
				var date:Number = Number(dateArr.shift());
                        
				var multiplier:Number;
				var offsetHours:Number;
				var offsetMinutes:Number;
				var offsetStr:String;
                        
				if (timeStr.indexOf("Z") != -1)
				{
					multiplier = 1;
					offsetHours = 0;
					offsetMinutes = 0;
					timeStr = timeStr.replace("Z", "");
				}
                        else if (timeStr.indexOf("+") != -1)
				{
					multiplier = 1;
					offsetStr = timeStr.substring(timeStr.indexOf("+") + 1, timeStr.length);
					offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
					offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":") + 1, offsetStr.length));
					timeStr = timeStr.substring(0, timeStr.indexOf("+"));
				}
				else // offset is -
				{
					multiplier = -1;
					offsetStr = timeStr.substring(timeStr.indexOf("-") + 1, timeStr.length);
					offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
					offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":") + 1, offsetStr.length));
					timeStr = timeStr.substring(0, timeStr.indexOf("-"));
				}
				var timeArr:Array = timeStr.split(":");
				var hour:Number = Number(timeArr.shift());
				var minutes:Number = Number(timeArr.shift());
				var secondsArr:Array = (timeArr.length > 0) ? String(timeArr.shift()).split(".") : null;
				var seconds:Number = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
				var milliseconds:Number = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
				var utc:Number = Date.UTC(year, month - 1, date, hour, minutes, seconds, milliseconds);
				var offset:Number = (((offsetHours * 3600000) + (offsetMinutes * 60000)) * multiplier);
				finalDate = new Date(utc - offset);

				if (finalDate.toString() == "Invalid Date")
				{
					throw new Error("This date does not conform to W3CDTF.");
				}
			}
                catch (e:Error)
			{
				var eStr:String = "Unable to parse the string [" + str + "] into a date. ";
				eStr += "The internal error was: " + e.toString();
				throw new Error(eStr);
			}
			return finalDate;
		}

		/**
		 * Parses dates that conform to RFC822 into Date objects. This method also
		 * supports four-digit years (not supported in RFC822), but two-digit years
		 * (referring to the 20th century) are fine, too.
		 *
		 * This function is useful for parsing RSS .91, .92, and 2.0 dates.
		 *
		 * @param str
		 *
		 * @returns
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 *
		 * @see http://asg.web.cmu.edu/rfc/rfc822.html
		 */              
		public static function parseRFC822(str:String):Date
		{
			var finalDate:Date;
			try
			{
				var dateParts:Array = str.split(" ");
				var day:String = null;
                               
				if (dateParts[0].search(/\d/) == -1)
				{
					day = dateParts.shift().replace(/\W/, "");
				}
                               
				var date:Number = Number(dateParts.shift());
				var month:Number = Number(DateUtil.getShortMonthIndex(dateParts.shift()));
				var year:Number = Number(dateParts.shift());
				var timeParts:Array = dateParts.shift().split(":");
				var hour:Number = int(timeParts.shift());
				var minute:Number = int(timeParts.shift());
				var second:Number = (timeParts.length > 0) ? int(timeParts.shift()) : 0;
       
				var milliseconds:Number = Date.UTC(year, month, date, hour, minute, second, 0);
       
				var timezone:String = dateParts.shift();
				var offset:Number = 0;

				if (timezone.search(/\d/) == -1)
				{
					switch(timezone)
					{
						case "UT":
							offset = 0;
							break;
						case "UTC":
							offset = 0;
							break;
						case "GMT":
							offset = 0;
							break;
						case "EST":
							offset = (-5 * 3600000);
							break;
						case "EDT":
							offset = (-4 * 3600000);
							break;
						case "CST":
							offset = (-6 * 3600000);
							break;
						case "CDT":
							offset = (-5 * 3600000);
							break;
						case "MST":
							offset = (-7 * 3600000);
							break;
						case "MDT":
							offset = (-6 * 3600000);
							break;
						case "PST":
							offset = (-8 * 3600000);
							break;
						case "PDT":
							offset = (-7 * 3600000);
							break;
						case "Z":
							offset = 0;
							break;
						case "A":
							offset = (-1 * 3600000);
							break;
						case "M":
							offset = (-12 * 3600000);
							break;
						case "N":
							offset = (1 * 3600000);
							break;
						case "Y":
							offset = (12 * 3600000);
							break;
						default:
							offset = 0;
					}
				}
				else
				{
					var multiplier:Number = 1;
					var oHours:Number = 0;
					var oMinutes:Number = 0;
					if (timezone.length != 4)
					{
						if (timezone.charAt(0) == "-")
						{
							multiplier = -1;
						}
						timezone = timezone.substr(1, 4);
					}
					oHours = Number(timezone.substr(0, 2));
					oMinutes = Number(timezone.substr(2, 2));
					offset = (((oHours * 3600000) + (oMinutes * 60000)) * multiplier);
				}


				finalDate = new Date(milliseconds - offset);

				if (finalDate.toString() == "Invalid Date")
				{
					throw new Error("This date does not conform to RFC822.");
				}
			}
                        catch (e:Error)
			{
				var eStr:String = "Unable to parse the string [" + str + "] into a date. ";
				eStr += "The internal error was: " + e.toString();
				throw new Error(eStr);
			}
			return finalDate;
		}

		/**
		 * Returns a date string formatted according to RFC822.
		 *
		 * @param d
		 *
		 * @returns
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 *
		 * @see http://asg.web.cmu.edu/rfc/rfc822.html
		 */      
		public static function toRFC822(d:Date):String
		{
			var date:Number = d.getUTCDate();
			var hours:Number = d.getUTCHours();
			var minutes:Number = d.getUTCMinutes();
			var seconds:Number = d.getUTCSeconds();
			var sb:String = new String();
			sb += DAYS[d.getUTCDay()];
			sb += ", ";
                        
			if (date < 10)
			{
				sb += "0";
			}
			sb += date;
			sb += " ";
			sb += getShortMonthName(d.getUTCMonth());
			sb += " ";
			sb += d.getUTCFullYear();
			sb += " ";
			if (hours < 10)
			{                       
				sb += "0";
			}
			sb += hours;
			sb += ":";
			if (minutes < 10)
			{                       
				sb += "0";
			}
			sb += minutes;
			sb += ":";
			if (seconds < 10)
			{                       
				sb += "0";
			}
			sb += seconds;
			sb += " GMT";
			return sb;
		}

		/**
		 * Returns a date string formatted according to W3CDTF.
		 *
		 * @param d
		 * @param includeMilliseconds Determines whether to include the
		 * milliseconds value (if any) in the formatted string.
		 *
		 * @returns
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 *
		 * @see http://www.w3.org/TR/NOTE-datetime
		 */                  
		public static function toW3CDTF(d:Date,includeMilliseconds:Boolean = false):String
		{
			var date:Number = d.getUTCDate();
			var month:Number = d.getUTCMonth();
			var hours:Number = d.getUTCHours();
			var minutes:Number = d.getUTCMinutes();
			var seconds:Number = d.getUTCSeconds();
			var milliseconds:Number = d.getUTCMilliseconds();
			var sb:String = new String();
                       
			sb += d.getUTCFullYear();
			sb += "-";
                       
			//thanks to "dom" who sent in a fix for the line below
			if (month + 1 < 10)
			{
				sb += "0";
			}
			sb += month + 1;
			sb += "-";
			if (date < 10)
			{
				sb += "0";
			}
			sb += date;
			sb += "T";
			if (hours < 10)
			{
				sb += "0";
			}
			sb += hours;
			sb += ":";
			if (minutes < 10)
			{
				sb += "0";
			}
			sb += minutes;
			sb += ":";
			if (seconds < 10)
			{
				sb += "0";
			}
			sb += seconds;
			if (includeMilliseconds && milliseconds > 0)
			{
				sb += ".";
				sb += milliseconds;
			}
			sb += "-00:00";
			return sb;
		}

		/**
		 * Converts a date into just after midnight.
		 */
		public static function makeMorning(di:Date):Date
		{
			var d:Date = new Date(di.time);
			d.hours = 0;
			d.minutes = 0;
			d.seconds = 0;
			d.milliseconds = 0;
			return d;
		}

		/**
		 * Converts a date into just befor midnight.
		 */
		public static function makeNight(di:Date):Date
		{
			var d:Date = new Date(di.time);
			d.hours = 23;
			d.minutes = 59;
			d.seconds = 59;
			d.milliseconds = 999;                              
			return d;
		}

		/**
		 * Sort of converts a date into UTC.
		 */
		public static function getUTCDate(d:Date):Date
		{
			var nd:Date = new Date();
			var offset:Number = d.getTimezoneOffset() * 60 * 1000;
			nd.setTime(d.getTime() + offset);
			return nd;
		}
	}
}
