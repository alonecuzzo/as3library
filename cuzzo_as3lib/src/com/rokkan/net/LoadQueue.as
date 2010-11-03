package com.rokkan.net 
{
	
	import com.rokkan.events.LoadQueueEvent;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	/**
     * Dispatched when an item in the queue has finished loading.
     * @eventType com.rokkan.events.LoadQueueEvent.ITEM_COMPLETE
     */
	[Event(name="itemComplete", type="com.rokkan.events.LoadQueueEvent")]
	
	/**
     * Dispatched as the queue progresses.
     * @eventType com.rokkan.events.LoadQueueEvent.QUEUE_PROGRESS
     */
	[Event(name="queueProgress", type="com.rokkan.events.LoadQueueEvent")]
	
	/**
     * Dispatched when the queue has finished loading the last item.
     * @eventType flash.events.Event.COMPLETE
     */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
     * Dispatched when one of the following happens: 1) an item fails to load. 2) An added
	 * item does not contain an method named <code>load</code>. 3) An item is added while the queue
	 * is in progress.
     * @eventType flash.events.ErrorEvent.ERROR
     */
	[Event(name="error", type="flash.events.ErrorEvent")]
	
	/**
	 * The <code>LoadQueue</code> class gives the developer the ability to queue the 
	 * loading of various assets, most commmonly images and data files such as XML.
	 */
	public class LoadQueue extends EventDispatcher
	{
		private static const ACCEPTED_FILE_TYPES:Array = [".jpg", ".jpeg", ".gif", ".png", ".xml", ".php", ".asp", ".jsp", ".txt", ".text"];
		
		private var _continueOnError:Boolean;
		private var _isLoading:Boolean;
		private var _isPaused:Boolean;
		private var _currentItem:LoadQueueItem;
		private var _currentLoader:*;
		private var _currentRequest:URLRequest;
		private var _itemsToLoad:Array;
		private var _itemBytesLoaded:uint;
		private var _itemBytesTotal:uint;
		private var _dispatchRate:int;
		private var _dispatchTimer:Timer;
		private var _totalItems:int;
		private var _queueProgress:Number;
		
		/**
		 * Creates an instance of the LoadQueue class.
		 * @param	dispatchRate	The rate, in milliseconds, at which to dispatch progress events
		 * @param	continueOnError	Specifies wether or not to continue if an asset in the queue is unable to be loaded
		 */
		public function LoadQueue( dispatchRate:int, continueOnError:Boolean = true ) 
		{
			_dispatchRate = dispatchRate;
			_continueOnError = continueOnError;
			_itemsToLoad = new Array();
			_isLoading = false;
			_isPaused = false;
		}
		
		
		/* Event Handlers */
		private function onLoadComplete( event:Event ):void
		{
			if ( event != null )
			{
				dispatchEvent( new LoadQueueEvent( LoadQueueEvent.ITEM_COMPLETE, false, false, 
				                                   _itemBytesLoaded, _itemBytesTotal, _queueProgress, _currentItem ) );
			}
			
			_itemsToLoad.shift();
			
			if( _itemsToLoad.length > 0 )
			{
				loadNext();
			}
			else
			{
				_queueProgress = 1;
				_isLoading = false;
				dispatchEvent( new Event( Event.COMPLETE ) );
			}
		}
		
		private function onLoadProgress( event:ProgressEvent ):void
		{
			_itemBytesLoaded = event.bytesLoaded;
			_itemBytesTotal = event.bytesTotal;
			
			var itemsComplete:Number = _totalItems - _itemsToLoad.length;
			var incrementPerItem:Number = 1 / _totalItems;
			var itemPercent:Number = _itemBytesLoaded / _itemBytesTotal
			var incrementToAdd:Number = itemPercent * incrementPerItem;
			var alreadyComplete:Number = itemsComplete * incrementPerItem
			
			_queueProgress = alreadyComplete + incrementToAdd;
			
			dispatchEvent( new LoadQueueEvent( LoadQueueEvent.QUEUE_PROGRESS, false, false, 
											   event.bytesLoaded, event.bytesTotal, _queueProgress ) );
		}
		
		private function onLoadError( event:* ):void
		{
			if( _continueOnError )
				onLoadComplete( null );
			else
				dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, 
											   "Unable to load item at " + _currentRequest.url ) );
		}
		
		/* Private Methods */
		private function loadNext():void
		{
			_currentItem = _itemsToLoad[0];
			_currentLoader = _currentItem.loader;
			_currentRequest = _currentItem.request;

			var obj:* = ( _currentLoader is Loader )? _currentLoader.contentLoaderInfo 
													: _currentLoader;
				
			obj.addEventListener( Event.COMPLETE, onLoadComplete );
			obj.addEventListener( ProgressEvent.PROGRESS, onLoadProgress );
			obj.addEventListener( IOErrorEvent.IO_ERROR, onLoadError );
			obj.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onLoadError );
			
			_currentLoader.load( _currentRequest );
		}
		
		
		/* Public Methods */
		
		/**
		 * Adds an item to the load queue. All items must include a method named <code>load()</code> 
		 * that accepts a <code>URLRequest</code> object as its first and only required parameter.
		 * @param	loader	Reference to an instance that is loadable
		 * @param	request	URLRequest object specifying the location of the asset to load
		 */
		public function addItem( loader:*, request:URLRequest ):void
		{
			if( !_isLoading )
			{
				if ( loader.load is Function )
				{
					var item:LoadQueueItem = new LoadQueueItem( loader, request );
					_itemsToLoad.push( item );
				}
				else 
				{
					dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, 
												   "Invalid loader object. Must contain 'load' method." ) );
				}
			}
			else
			{
				dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, 
											   "Cannot add item. Queue in progress." ) );
			}
		}
		
		/* TODO: removeItem method
		public function removeItem( item:* ):void
		{
			
		}
		*/
		
		
		public function bringToFront():void
		{
			
		}
		
		
		/**
		 * Starts the load queue.
		 */
		public function start():void
		{
			_isLoading = true;
			_queueProgress = 0;
			_totalItems = _itemsToLoad.length;
			
			loadNext();
		}
		
	}
	
}
