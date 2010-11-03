package com.rokkan.events{
	
	public class EventObject{
	
		public static function createPassingEventObject(my_variable:String, my_value:*, event_object:Object=null):Object{
			if(event_object == null){
				var event_obj:Object = new Object();
				event_obj[my_variable] = my_value;
				return event_obj;
			}
			else {
				event_object[my_variable] = my_value;
				return event_object;
			}
		};
	};
};