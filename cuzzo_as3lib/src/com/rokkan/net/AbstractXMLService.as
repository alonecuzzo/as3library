package com.rokkan.net 
{
	
	import flash.events.Event;
	import com.rokkan.events.XMLEvent;
	
	/**
     * Dispatched when the XML data has been parsed and.
     * @eventType flash.events.Event.OPEN
     */
	[Event(name="xmlParsed", type="com.rokkan.events.XMLEvent")]

	public class AbstractXMLService extends XMLLoader
	{
		
		/**
		 * The AbstractXMLService class is an abstracted class that is meant to be extended. Common XML
		 * loading and parsing functionality has been extended and is meant to serve as a simple
		 * way of loading and parsing XML data from a specified source. Simply override the 
		 * <code>parseXML()</code> method with your custom XML parsing routine.
		 */
		public function AbstractXMLService() 
		{
			
		}
		
		/**
		 * Utility method which dispatches an <code>XMLEvent.XML_PARSED</code> event.
		 */
		protected function notifyXMLParsed():void
		{
			dispatchEvent( new XMLEvent( XMLEvent.XML_PARSED ) );
		}
		
		/**
         * URLLoader <code>Event.COMPLETE</code> event handler.
         * @param	event	Event object
         */
		override protected function onLoadComplete( event:Event ):void
		{
			super.onLoadComplete( event );
			parseXML();
			notifyXMLParsed();
		}
		
		/**
		 * Place holder method for XML parsing routine. Override with custom behavior.
		 */
		protected function parseXML():void
		{
			
		}
	}
	
}
