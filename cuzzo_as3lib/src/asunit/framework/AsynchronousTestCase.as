package asunit.framework {
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;	

	/**
	 * Extend this class if you have a TestCase that requires the
	 * asynchronous load of external data.
	 */
	public class AsynchronousTestCase extends TestCase 
	{
		public function AsynchronousTestCase(testMethod:String = null) 
		{
			super(testMethod);
		}

		protected function configureListeners(loader:URLLoader):void 
		{
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.addEventListener(Event.OPEN, openHandler);
			loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}

		// override this method and implement your own completeHandler
		// you should be sure to call super.run() from the body of
		// this override.
		protected function completeHandler(event:Event):void 
		{
		}

		// TODO: add support for failing status events...
		protected function httpStatusHandler(event:HTTPStatusEvent):void 
		{
		}

		protected function ioErrorHandler(event:IOErrorEvent):void 
		{
			result.addError(this, new IllegalOperationError(event.toString()));
			isComplete = true;
		}

		protected function openHandler(event:Event):void 
		{
		}

		protected function progressHandler(event:ProgressEvent):void 
		{
		}

		protected function securityErrorHandler(event:SecurityErrorEvent):void 
		{
			result.addError(this, new IllegalOperationError(event.toString()));
			isComplete = true;
		}
	}
}