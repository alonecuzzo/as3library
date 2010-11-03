package com.rokkan.net 
{
    
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    /**
     * Dispatched when a load operation commences.
     * @eventType flash.events.Event.OPEN
     */
    [Event(name="open", type="flash.events.Event")]
    
	/**
     * Dispatched after data has loaded successfully.
     * @eventType flash.events.Event.COMPLETE
     */
	[Event(name="complete", type="flash.events.Event")]
    
	/**
     * Dispatched when data is received as the download operation progresses.
     * @eventType flash.events.ProgressEvent.PROGRESS
     */
	[Event(name="progress", type="flash.events.ProgressEvent")]
    
	/**
     * Dispatched if a call to the <code>load()</code> method attempts to access data over HTTP and the 
	 * application is able to detect and return the status code for the request.
     * @eventType flash.events.HTTPStatusEvent.HTTP_STATUS
     */
	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
    
	/**
     * The load operation could not be completed.
     * @eventType flash.events.IOErrorEvent.IO_ERROR
     */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
    
	/**
     * A load operation attempted to retrieve data from a server outside the caller's security sandbox. 
	 * This may be worked around using a policy file on the server.
     * @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
     */
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
    
    /**
     * The XMLLoader class encapsulates simple/common XML loading operations. 
	 * @see com.rokkan.net.XMLService
     */
    public class XMLLoader extends EventDispatcher
    {
        
		/**
		 * The XML object.
		 */
        protected var _xml:XML;
		
		/**
		 * The URLLoader object used to retrieve the XML data.
		 */
        protected var _loader:URLLoader;
		
		/**
		 * The URLRequest object used to retrieve the XML data.
		 */
        protected var _request:URLRequest;
		
		/**
		 * The HTTP status code of the loading operation.
		 */
        protected var _httpStatus:int;
        
        
        /**
         * Creates a new XMLLoader class instance.
         */
        public function XMLLoader()
        {
            _loader = new URLLoader();
        }
        
        /**
         * URLLoader <code>Event.COMPLETE</code> event handler.
         * @param	event	Event object
         */
        protected function onLoadComplete( event:Event ):void
        {
            _xml = new XML( _loader.data );
            
            dispatchEvent( event.clone() );
        }
        
		/**
		 * URLLoader <code>Event.OPEN</code> event handler.
		 * @param	event	Event object
		 */
        protected function onLoadOpen( event:Event ):void
        {
            dispatchEvent( event.clone() );
        }
        
		/**
		 * URLLoader <code>ProgressEvent.PROGRESS</code> event handler.
		 * @param	event	ProgressEvent object
		 */
        protected function onLoadProgress( event:ProgressEvent ):void
        {
            dispatchEvent( event.clone() );
        }
        
		/**
		 * URLLoader <code>HTTPStatusEvent.HTTP_STATUS</code> event handler.
		 * @param	event	HTTPStatusEvent object
		 */
        protected function onHTTPStatus( event:HTTPStatusEvent ):void
        {
            _httpStatus = event.status;
            
            dispatchEvent( event.clone() );
        }
        
		/**
		 * URLLoader <code>SecurityErrorEvent.SECURITY_ERROR</code> event handler.
		 * @param	event	SecurityErrorEvent object
		 */
        protected function onSecurityError( event:SecurityErrorEvent ):void
        {
            dispatchEvent( event.clone() );
        }
        
		/**
		 * URLLoader <code>IOErrorEvent.IO_ERROR</code> event handler.
		 * @param	event	IOErrorEvent object
		 */
        protected function onIoError( event:IOErrorEvent ):void
        {
            dispatchEvent( event.clone() );
        }
        
        
        /**
         * Sends a request to load data from the specified URL.
         * @param	request	A URLRequest object specifying the URL to download.
         */
        public function load( request:URLRequest ):void
        {
            _request = request;
            
			_loader.addEventListener( Event.COMPLETE, onLoadComplete );            
            _loader.addEventListener( Event.OPEN, onLoadOpen );
            _loader.addEventListener( ProgressEvent.PROGRESS, onLoadProgress );
            _loader.addEventListener( HTTPStatusEvent.HTTP_STATUS, onHTTPStatus );
            _loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
            _loader.addEventListener( IOErrorEvent.IO_ERROR, onIoError );
            
            _loader.load( _request );
        }
        
        
        /**
         * The URLLoader object being used to load the XML data.
         */
        public function get loader():URLLoader
        {
            return _loader;
        }
        
		/**
         * The URLRequest object being used to load the XML data.
         */
        public function get request():URLRequest
        {
            return _request;
        }
        
		/**
		 * The loaded XML data.
		 */
        public function get xml():XML
        {
            return _xml;
        }
        
    }
    
}