package com.atmospherebbdo.tracking 
{
	import com.atmospherebbdo.util.external.IExternalCommunicationStrategy;	

	/**
	 * @author Mark Hawley
	 * 
	 * Tracker for use with Digitaria.
	 */
	public class Digitaria
	{
		private static const PAGE_VIEW:String = "trackPageView";
		private static const LINK_CLICK:String = "trackLinkClick";
		private static const VIDEO_PLAY:String = "trackVideoPlay";
		
		
		private static const ILLEGAL_CHARACTERS:Array = 
		[
			"'", '"', "&", "!", "#", "$", "%", "^", "*", ":", "|", "/", "\\", "<", 
			">", "~", ";"
		];
		private static var SEPARATOR:String = "+";
		
		private var strategy:IExternalCommunicationStrategy;
		private static var cleanDictionary:Object = null;
	
		/**
		 * Constructor.
		 * 
		 * @param	strategy	IDigitariaTrackingStrategy
		 */
		public function Digitaria( strategy:IExternalCommunicationStrategy )
		{
			this.strategy = strategy;
		}
	
		/**
		 * Tracks whatever you consider a new 'page view' in Flash.
		 * 
		 * @param	pageName	String, a given page name.
		 * @param	pageCategory	String, a value that will be used to group
		 * 							page views in Digitaria.
		 */
		public function trackPageView(pageName:String, pageCategory:String):void
		{
			pageName = stripIllegalCharacters(pageName);
			pageCategory = stripIllegalCharacters(pageCategory);
			strategy.call(PAGE_VIEW, pageName, pageCategory);
		}
		
		public function trackLinkClick( linkID:String, linkPosition:String ) :void
		{
			linkID = stripIllegalCharacters(linkID);
			linkPosition = stripIllegalCharacters(linkPosition);
			strategy.call(LINK_CLICK, linkID, linkPosition);
		} 
		
		public function trackVideoPlay( videoName:String, currentPosition:Number, endPosition:Number ) :void
		{
			videoName = stripIllegalCharacters(videoName);
			strategy.call(VIDEO_PLAY, videoName, currentPosition, endPosition);
		}
		
		//TODO: add in calls for trackVideoPause, trackVideoPlayProgress, 
		// trackVideoStop, and trackVideoEvent
	
		private static function stripIllegalCharacters( input:String ):String
		{
			// only filter each input once
			
			// TODO: try using the Memoizer?
			
			if (cleanDictionary == null)
			{
				cleanDictionary = {};
			}
			if (cleanDictionary[ input ] == undefined)
			{
				// remove illegals
				var remove:RegExp = new RegExp("[" + ILLEGAL_CHARACTERS.join("|") + "]", "g");
				input.replace(remove, "");
				// replace spaces with separator
				var spaces:RegExp = / /g;
				input.replace(spaces, SEPARATOR);
				cleanDictionary[ input ] = input;
			}
			return cleanDictionary[ input ];
		}
	}
}
