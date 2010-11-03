package com.blitzagency.xray.inspector.util
{
	import flash.events.EventDispatcher;
	import com.blitzagency.xray.logger.XrayLog;

	public class TypeResolver extends EventDispatcher
	{		
		private var log:XrayLog = new XrayLog();
		
		public function TypeResolver()
		{
			// calm down FDT warning
			log;
		}
		
		public function resolveType(obj:*):*
		{
			return null;
		}
	}
}