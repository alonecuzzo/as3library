package com.rokkan.net {
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.utils.Dictionary;
	
	/**
	* Loader for different types of assets including image/swf/xml
	* @author Russell Savage
	*/
	public class LoadingQueue {
		
		// created vars
		private static var _queueArr:Array;
		private static var _groupStatusDict:Dictionary;
		private static var _cacheDict:Dictionary;
		private static var _hasInited:Boolean = false;
		
		// constant vars
		private static const I_LOADER:uint = 0;
		private static const I_ON_COMPLETE:uint = 1;
		private static const I_ON_COMPLETE_PARAMS:uint = 2;
		private static const I_ON_PROGRESS:uint = 3;
		private static const I_GROUP:uint = 4;
		private static const I_GROUP_PROGRESS:uint = 5;
		private static const I_ON_GROUP_COMPLETE:uint = 6;
		private static const I_GROUP_REFARRAY:uint = 7;
		private static const I_CACHE:uint = 8;
		private static const I_URL_PATH:uint = 9;
		private static const I_EVENT_ATTACH:uint = 10;
		
		public function LoadingQueue() {
			_queueArr = new Array();
			_cacheDict = new Dictionary();
			_hasInited = true;
		}
		
		/**
		 * Loads an image/swf/xml asset and returns it to the onComplete Function
		 *
		 * @param	path			[required]	the path to the asset to load
		 * @param	init			[optional]	An initialisation object for specifying default instance properties.
		 * Properties of the init object: onComplete, onCompleteParams, onProgress, group, onGroupProgress, cache
		 * 
		 * Details on optional parameters:
		 * onComplete:Function	 		Function that is called once the item is done loading in the format: onComplete(loadedObj:DisplayObject, onCompleteParam1, onCompleteParam2, onCompleteParam3... ) // ononCompleteParams are optional
		 * onCompleteParams:Array		Array of parameters to pass to the onComplete function (after the loaded object), see the example above
		 * onProgress:Function 			Function to monitor the progress of the individually loaded item, passes the progress as a ratio from 0-1, like onProgress(0.2)
		 * group:String			 		String to associate with other items to be loaded (grouping them all into one bucket)
		 * onGroupProgress:Function 	Function to monitor the progress of the items being loaded in the items group, passes the progress as a ratio from 0-1, like onProgress(0.2)
		 * cache:Boolean				Boolean that tells whether the LoadingQueue should keep a referance to the loaded item. This item will be loaded automatically, on the next call to this asset.
		 */
		public static function load(path:String, init:Object = null):Object { 
			if (_hasInited == false) {
				var temp:LoadingQueue = new LoadingQueue();
			}
			
			init = init == null ? { } : init;
			init.onCompleteParams = init.onCompleteParams == null ? new Array() : init.onCompleteParams;
			var loader = path.indexOf(".xml") >= 0 ? new URLLoader() : new Loader();
			var queueEntry:Array = new Array(11);
			queueEntry[ I_LOADER ] = loader;
			queueEntry[ I_ON_COMPLETE ] = init.onComplete;
			queueEntry[ I_ON_COMPLETE_PARAMS ] = init.onCompleteParams;
			queueEntry[ I_ON_PROGRESS ] = init.onProgress;
			queueEntry[ I_GROUP ] = init.group;
			queueEntry[ I_GROUP_PROGRESS ] = init.onGroupProgress;
			queueEntry[ I_ON_GROUP_COMPLETE ] = init.onGroupComplete;
			queueEntry[ I_GROUP_REFARRAY ] = null; // placeholder for keeping a reference to the dictionary
			queueEntry[ I_CACHE ] = init.cache == null ? false : init.cache;
			queueEntry[ I_URL_PATH ] = path;
			queueEntry[ I_EVENT_ATTACH ] = ( loader is Loader ) ? loader.contentLoaderInfo : loader;
			_queueArr.push( queueEntry );
			
			// check if it is cached
			if ( _cacheDict[ path ] ) {
				trace("loading cached version");
				assetFinishedLoading( null, _cacheDict[ path ]);
			}else {
				queueEntry[ I_EVENT_ATTACH ].addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
				if ( loader is Loader ) {
					queueEntry[ I_EVENT_ATTACH ].addEventListener(Event.INIT, assetFinishedLoading, false, 0, true);
					loader.load( new URLRequest(path), new LoaderContext(true) );
				}else {
					queueEntry[ I_EVENT_ATTACH ].addEventListener(Event.COMPLETE, assetFinishedLoading, false, 0, true);
					loader.load( new URLRequest(path) );
				}
				return loader;
			}
			return null;
		}
		
		public static function clear_cache() {
			_cacheDict = new Dictionary();
		}
		
		public static function addProgressListener( loader:Loader, func:Function ) {
			for (var i:uint = 0; i < _queueArr.length; i++) {
				if (_queueArr[i][ I_LOADER ] === loader) {
					_queueArr[i][ I_ON_PROGRESS ] = func;
				}
			}
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		}
		
		private static function progressHandler( event:ProgressEvent ):void {
			var progressRatio:Number = event.bytesLoaded / event.bytesTotal;
			
			for (var i:uint = 0; i < _queueArr.length; i++) {
				if (_queueArr[i]!=null && _queueArr[i][ I_ON_PROGRESS ]!=null && (_queueArr[i][ I_EVENT_ATTACH ]===event.target) ){
					_queueArr[i][ I_ON_PROGRESS ]( progressRatio );
				}
				
				if (_queueArr[i]!=null && (_queueArr[i][ I_EVENT_ATTACH ]===event.target) && _queueArr[i][ I_GROUP ]!=null && _queueArr[i][ I_GROUP_PROGRESS ]!=null ) {
					if (_groupStatusDict == null) { // created dictionary object to track all of the groups, (run only once a session)
						_groupStatusDict = new Dictionary();
					}
					if (_groupStatusDict[ _queueArr[i][ I_GROUP ] ] == null ) { // created dictionary object to track this groups progress, (run every time a new group is made)
						_groupStatusDict[ _queueArr[i][ I_GROUP ] ] = [new Dictionary(), null];
					}
					_queueArr[i][ I_GROUP_REFARRAY ] = _groupStatusDict[ _queueArr[i][ I_GROUP ] ];
					
					_groupStatusDict[ _queueArr[i][ I_GROUP ] ][0][ _queueArr[i][ I_LOADER ] ] = progressRatio ;
					if (_queueArr[i][ I_ON_GROUP_COMPLETE ] != null ) { // if there is an oncomplete for the group add it to the dictionary selection
						_groupStatusDict[ _queueArr[i][ I_GROUP ] ][1] = _queueArr[i][ I_ON_GROUP_COMPLETE ];
					}
					
					var groupRatio:Number = progressInDictionary( _groupStatusDict[ _queueArr[i][ I_GROUP ] ][0] );
					_queueArr[i][ I_GROUP_PROGRESS ]( groupRatio );
				}
			}
		}
		
		private static function progressInDictionary( dict:Dictionary ):Number {
			var totalProgress:Number = 0;
			var totalNumber:Number = 0;
			for each (var value:Number in dict ) {
			   totalProgress += value;
			   totalNumber++;
			}
			return ( totalProgress / totalNumber );
		}
		
		private static function assetFinishedLoading(event:Event = null, useContent:Object = null ):void {
			for (var i:uint = 0; i < _queueArr.length; i++) {
				// set the content appropriately (depending on whether it is an xml load or img/swf load)
				var content = null;
				if (useContent != null) {
					content = useContent;
				}else if(_queueArr[i]!=null && _queueArr[i][ I_LOADER ]!=null){ 
					if(_queueArr[i][ I_LOADER ] is Loader){ // image,swf file
						content = _queueArr[i][ I_LOADER ].content
					}else if(_queueArr[i][ I_LOADER ] is URLLoader){ // xml,text file
						content = new XML(event.target.data);
					}
				}
				
				if (_queueArr[i]!=null && content!=null ) {
					if( _queueArr[i][ I_ON_PROGRESS ] != null ){
						_queueArr[i][ I_ON_PROGRESS ]( 1 );
					}
					
					if (_queueArr[i][ I_ON_COMPLETE ] != null) {
						_queueArr[i][ I_ON_COMPLETE_PARAMS ].unshift( content );
						_queueArr[i][ I_ON_COMPLETE ].apply(null, _queueArr[i][ I_ON_COMPLETE_PARAMS ]);
					}
					if ( _queueArr[i][ I_GROUP ] != null ) { // check if it belongs to a group
						var itemArr:Array = _queueArr[i][ I_GROUP_REFARRAY ];
						_groupStatusDict[ _queueArr[i][ I_GROUP ] ][0][ _queueArr[i][ I_LOADER ] ] = 1;
						if (itemArr[1]!= null && progressInDictionary( itemArr[0] ) >= 1){
							itemArr[1]();
							itemArr = null;
						}
					}
					if ( _queueArr[i][ I_CACHE ] ) {
						trace("adding to cache " + I_URL_PATH);
						_cacheDict[ _queueArr[i][ I_URL_PATH ] ] = content;
					}
					if (_queueArr[i][ I_EVENT_ATTACH ] != null) {
						_queueArr[i][ I_EVENT_ATTACH ].removeEventListener(Event.INIT, assetFinishedLoading);
						if(_queueArr[i][ I_EVENT_ATTACH ].hasEventListener( ProgressEvent.PROGRESS )) {
							_queueArr[i][ I_EVENT_ATTACH ].removeEventListener(ProgressEvent.PROGRESS, progressHandler);
						}
					}
					_queueArr[i] = null;
				}
			}
		}
		
	}
	
}