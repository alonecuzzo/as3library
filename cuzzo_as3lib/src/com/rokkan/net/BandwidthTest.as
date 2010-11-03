package com.rokkan.net 
{
	
	import flash.display.Loader;
	import flash.events.EventDispatcher;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.events.Event;
    import flash.utils.getTimer;
	
	/**
	 * The BandwidthTest class crudely tests a users's bandwith capabilities by loading a
	 * specified asset three times.
	 */
	public class BandwidthTest extends EventDispatcher
	{
		
		private var _downloadCount:uint;
        private var _bandwidthTests:Array;
        private var _detectedBandwidth:Number;
        private var _startTime:uint;
        
		/**
		 * Creates a BandwidthTest instance.
		 */
        public function BandwidthTest()
		{
            _downloadCount = 0;
            _bandwidthTests = new Array();
        }
        
		private function onStart( event:Event ):void
		{
            _startTime = getTimer();
        }
        
        private function onLoad( event:Event ):void
		{
            var loader:Loader = event.target as Loader;
            //The download time is the timer value when the file has downloaded
            //minus the timer value when the value started downloading.  Then 
            //divide by 1000 to convert from milliseconds to seconds.
            var downloadTime:Number = ( getTimer() - _startTime ) / 1000;
            _downloadCount++;
            
            //Convert from bytes to kilobits.
            var kilobits:Number = event.target.bytesTotal / 1000 * 8;
            
            //Divide the kilobits by the download Time.
            var kbps:Number = kilobits / downloadTime;
            
            //Add the test value to the array.
            _bandwidthTests.push( kbps );
            
            if ( _downloadCount == 1 )
			{
                //if it's only run once then run the second
                test( loader.contentLoaderInfo.url );
            }
			else if ( _downloadCount == 2 )
			{
                //If it's run two tests then determine the margin between the 
                //first two tests.
                //If the margin is small (in this example, less than 50 kbps)
                //then dispatch a complete event.  If not run a test.
                if ( Math.abs( _bandwidthTests[0] - _bandwidthTests[1] ) < 50 )
				{
                    dispatchCompleteEvent();
                }
				else
				{
                    test( loader.contentLoaderInfo.url );
                }
            }
			else
			{
                //Following the third test dispatch a complete event.
                dispatchCompleteEvent();
            }
            
        }
		
		private function dispatchCompleteEvent():void
		{
            //Determine the average bandwidth detection value.
            _detectedBandwidth = 0;
            var i:uint;
            for ( i = 0; i < _bandwidthTests.length; i++ )
			{
                _detectedBandwidth += _bandwidthTests[i];
            }
            _detectedBandwidth /= _downloadCount;
            
            //Dispatch a complete event.
            dispatchEvent( new Event( Event.COMPLETE ) );
        }
		
		/**
		 * Begins the bandwith testing. It is recommended that the asset be at least 500K.
		 * @param	assetToLoad	The specified asset to use while testing the bandwith
		 */
        public function test( assetToLoad:String ):void
		{
            var loader:URLLoader = new URLLoader();
            
            var request:URLRequest = new URLRequest( assetToLoad + "?unique=" + ( new Date() ).getTime() );
            loader.load( request );
            loader.addEventListener( Event.OPEN, onStart );
            loader.addEventListener( Event.COMPLETE, onLoad );
        }
        
    	/**
    	 * The detected bandwith in kilobytes per second.
    	 */
		public function get detectedBandwidth():Number
		{
            return _detectedBandwidth;
        }
		
	}
	
}