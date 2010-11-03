/***********************************
eventsCentral Class - Custom event-listening and dispatching system for  instantiated 
                      classes to communicate amongst themselves and/or procedural timeline events. 
					  
Developed and Documented by: Faisal Ramadan
    Version 1.03
	July.14th.2008
	
	Do not make modifications to EXISTING CLASS FILES as working systems depend on them.
	Please extend(inherit) from this class if you would like to make changes or updates or use 
	certain aspects of it.
************************************/

package com.rokkan.events {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	/**
	*custom event-listening/dispatching system for communication between instantiated classes.
	*
	*@usage <code> 
	*              var event_depot:eventsCentral = new eventsCentral();   								<br />
	*              var class_A_needing_event_depot:ClassA = new ClassA(event_depot);					<br />
	*    		   var class_B_needing_event_depot:ClassB = new ClassB(event_depot);					<br />
	*																									<br />
	*              public class classA{																	<br />
	*				   private function shared_events:eventsCentral;									<br />
	*		     	   public function ClassA(event_system:eventsCentral):void{							<br />
	*				   		shared_events = event_system;												<br />
	*				   };            																	<br />                                         
	*																									<br />
	*				   public function doSomething():void{												<br />
	*				   		shared_events.doAction("class_b_say_hello");								<br />
	*				   };																				<br />
	*			   };																					<br />
	*																									<br />
	*              public class classB{																	<br />
	*				   private function shared_events:eventsCentral;									<br />
	*		     	   public function ClassB(event_system:eventsCentral):void{							<br />
	*				   		shared_events = event_system;												<br />
	*				   		attachListener();															<br />
	*				   };																				<br />
	*																									<br />
	*			       public function attachListener():void{											<br />
	*                  		var listener:Object = new Object;											<br />
	*						listener.say_hello = function(){											<br />
	*							trace("hello from class b");											<br />
	*						};																			<br />
	*																									<br />
	*						shared_events.addEventListener("say_hello", listener.say_hello);			<br />
	*				   };																				<br />
	*			   };																					<br />
	*      </code> 		
	*
    *@class eventsCentral
	*@author Faisal Ramadan
	*@version 1.03/July 14th, 2008
    */

	public class EventsCentral extends EventDispatcher{
  		/*
   		*@property public, an action to signify the event being dispatched.
   		*/
		public var ACTION:String = "unidentified_action";
		
		/*
   		*@property public, an array of objects containing variables passed when the event is 
		* dispatched.
   		*/
		public var passed_variables:Array;
		
		public function EventsCentral(){
			
		};
		/*
   		*public function, dispatches the event.
   		*@param passed_event_action assigns string event name.
   		*@param ...rest n amount of variables being passed with the event.
   		*/
		public function doAction(passed_event_action:String, ... rest):void {
			passed_variables = rest;
			ACTION = passed_event_action;
			
        	dispatchEvent(new Event(ACTION));
    	};
	};
};