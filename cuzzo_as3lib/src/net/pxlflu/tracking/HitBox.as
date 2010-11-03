package com.atmospherebbdo.tracking 
{
	import com.atmospherebbdo.util.external.IExternalCommunicationStrategy;	

	/**
	 * @author Mark Hawley
	 * 
	 * Tracker for use with HitBox.
	 */
	public class HitBox 
	{
		private static const PAGE_VIEW:String = "_hbPageView";
		private static const EXIT_LINK:String = "_hbExitLink";
		private static const DOWNLOAD:String = "_hbDownload";
		private static const FUNNEL:String = "_hbFunnel";
		private static const CAMPAIGN:String = "_hbCampaign";
		private static const GOAL_PAGE:String = "_hbGoalPage";
		private static const VISITOR_SEGMENT:String = "_hbVisitorSeg";
		private static const SET_VARIABLE:String = "_hbSet";
		private static const SEND:String = "_hbSend";
		private static const ILLEGAL_CHARACTERS:Array = 
		[
			"'", '"', "&", "!", "#", "$", "%", "^", "*", ":", "|", "/", "\\", "<", 
			">", "~", ";"
		];
		private static var SEPARATOR:String = "+";
		
		private var strategy:IExternalCommunicationStrategy;
		private static var cleanDictionary:Object = {};
	
		/**
		 * Constructor.
		 * 
		 * @param	strategy	IHitBoxTrackingStrategy
		 */
		public function HitBox( strategy:IExternalCommunicationStrategy )
		{
			this.strategy = strategy;
		}
	
		/**
		 * Tracks the language of a user.
		 * 
		 * @param	language	String
		 */
		public function trackLanguage( language:String ):void
		{
			language = stripIllegalCharacters(language);
			strategy.call(SET_VARIABLE, "language", language);
			strategy.call(SEND);
		}
	
		/**
		 * Tracks whatever you consider a new 'page view' in Flash.
		 * 
		 * @param	pageName	String, a given page name.
		 * @param	pageCategory	String, a value that will be used to group
		 * 							page views in HitBox.
		 */
		public function trackPageView(pageName:String, pageCategory:String):void
		{
			pageName = stripIllegalCharacters(pageName);
			pageCategory = stripIllegalCharacters(pageCategory);
			strategy.call(PAGE_VIEW, pageName, pageCategory);
		}
	
		/**
		 * Tracks a link leaving the Flash site.
		 * 
		 * @param	linkName	String, the name of a 
		 */
		public function trackExitLink(linkName:String):void
		{
			linkName = stripIllegalCharacters(linkName);
			strategy.call(EXIT_LINK, linkName);
		}
	
		/**
		 * Tracks a file download.
		 * 
		 * @param	downloadName	String
		 */
		public function trackDownload(downloadName:String):void
		{
			downloadName = stripIllegalCharacters(downloadName);
			strategy.call(DOWNLOAD, downloadName);
		}
	
		/**
		 * Tracks funneling.
		 * 
		 * @param	funnelID	String
		 * @param	pageName	String
		 * @param	pageCategory	String
		 */
		public function trackFunnel(funnelID:String, pageName:String, 
			pageCategory:String):void
		{
			funnelID = stripIllegalCharacters(funnelID);
			pageName = stripIllegalCharacters(pageName);
			pageCategory = stripIllegalCharacters(pageCategory);
			strategy.call(FUNNEL, funnelID, pageName, pageCategory);
		}
	
		/**
		 * Tracks a campaign.
		 * 
		 * @param	campaignID	String
		 * @param	pageName	String
		 * @param	pageCategory	String
		 */
		public function trackCampaign(campaignID:String, pageName:String, 
			pageCategory:String):void
		{
			campaignID = stripIllegalCharacters(campaignID);
			pageName = stripIllegalCharacters(pageName);
			pageCategory = stripIllegalCharacters(pageCategory);
			strategy.call(CAMPAIGN, campaignID, pageName, pageCategory);
		}
	
		/**
		 * Tracks a goal page hit.
		 * 
		 * @param	goalPageCampaignID	String
		 * @param	pageName	String
		 * @param	pageCategory	String
		 */
		public function trackGoalPage(goalPageCampaignID:String, pageName:String, 
			pageCategory:String):void
		{
			goalPageCampaignID = stripIllegalCharacters(goalPageCampaignID);
			pageName = stripIllegalCharacters(pageName);
			pageCategory = stripIllegalCharacters(pageCategory);
			strategy.call(GOAL_PAGE, goalPageCampaignID, pageName, pageCategory);
		}
	
		/**
		 * Tracks a visitor segmentation.	
		 * 
		 * @param	visitorSegmentID	String
		 * @param	pageName	String
		 * @param	pageCategory	String
		 */
		public function trackVisitorSegment(visitorSegmentID:String, 
			pageName:String, pageCategory:String):void
		{
			visitorSegmentID = stripIllegalCharacters(visitorSegmentID);
			pageName = stripIllegalCharacters(pageName);
			pageCategory = stripIllegalCharacters(pageCategory);
			strategy.call(VISITOR_SEGMENT, visitorSegmentID, pageName, pageCategory);
		}
	
		/**
		 * Sets a given HitBox variable.
		 * 
		 * @param	name	String
		 * @param	value	String
		 */
		public function setVariable(name:String, value:String):void
		{
			name = stripIllegalCharacters(name);
			value = stripIllegalCharacters(value);
			strategy.call(SET_VARIABLE, name, value);
		}
	
		/**
		 * Submits variables to HitBox.
		 */
		public function send():void
		{
			strategy.call(SEND);
		}
	
		private static function stripIllegalCharacters( input:String ):String
		{
			if (cleanDictionary[ input ] == undefined)
			{
				// remove illegals
				var remove:RegExp = new RegExp("[" + ILLEGAL_CHARACTERS.join("|") + "]", "g");
				input.replace(remove, "");
				
				// TODO: escape natural instances of the separator
				
				// replace spaces with separator
				var spaces:RegExp = / /g;
				input.replace(spaces, SEPARATOR);
				cleanDictionary[ input ] = input;
			}
			return cleanDictionary[ input ];
		}
	}
}
