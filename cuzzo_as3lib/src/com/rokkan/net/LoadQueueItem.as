package com.rokkan.net 
{

	import flash.net.URLRequest;
	
	/**
	 * @private
	 */
	public class LoadQueueItem 
	{
		
		public var loader:*;
		public var request:URLRequest;
		
		public function LoadQueueItem( loader:*, request:URLRequest ) 
		{
			this.loader = loader;
			this.request = request;
		}
		
	}
	
}
