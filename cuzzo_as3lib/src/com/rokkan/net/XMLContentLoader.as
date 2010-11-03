package com.rokkan.net {
	
	import com.rokkan.events.ContentLoadedEvent;

	import flash.events.EventDispatcher;
	import flash.events.Event;
		
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * XMLContentLoader Class / Tarantino Framework
	 * @author Faisal Ramadan
	 * @version 0.5
	 */
	
	public class XMLContentLoader extends EventDispatcher {
		
		public function XMLContentLoader() {
			//initialize
		};

		public function readXML(xml_file:String):void{
			var xml_url:String = xml_file;
			var my_xml_url:URLRequest = new URLRequest(xml_url);
			var my_loader:URLLoader = new URLLoader();

			my_loader.load(my_xml_url);
			my_loader.addEventListener("complete", xmlLoaded);
		};
		
		private function xmlLoaded(evt:Event):void {
			var loaded_xml:XML = new XML(evt.currentTarget.data);
			dispatchEvent(new ContentLoadedEvent(ContentLoadedEvent.CONTENT_READ_COMPLETED, loaded_xml));
		};
		
		public function loadScript(script_path:String, variables:Array = null):void {
			var request:URLRequest = new URLRequest(script_path);			
			
			if (variables != null && variables.length > 0) {
				var vars:URLVariables = new URLVariables();
				vars.rand = Math.random() * 99999;
		
				for (var i:Number = 0; i < variables.length; i++) {
					vars[variables[i].name] = variables[i].value;
				}
				
				request.method = URLRequestMethod.GET;
				request.data = vars;
				trace(request.data);
			}
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, scriptLoadHandler);			
			loader.load(request);
		};
		
		private function scriptLoadHandler(evt:Event):void {
			var loaded_xml:XML = new XML(evt.currentTarget.data);
			dispatchEvent(new ContentLoadedEvent(ContentLoadedEvent.CONTENT_READ_COMPLETED, loaded_xml));
		};	
	};
};