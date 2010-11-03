package asunit.framework 
	import asunit.framework.TestCase;

	// doesn't because we don't want TestSuites in this directory.
	public class TestCaseExample extends TestCase 
		private var date:Date;
		private var sprite:Sprite;

		// so that we can execute a single method on them from
		// the TestRunner
		public function TestCaseExample(testMethod:String = null) 
			super(testMethod);
		}

		override protected function setUp():void 
			date = new Date();
//			sprite = new Sprite();
//			addChild(sprite);
		}

		// but only if we're executing the entire TestCase,
		// the tearDown method won't be called if we're
		// calling start(MyTestCase, "someMethod");
		override protected function tearDown():void 
			//			removeChild(sprite);
			//			sprite = null;
			date = null;
		}

		// our objects are actually created as we expect.
		public function testInstantiated():void 
			assertTrue("Date instantiated", date is Date);
//			assertTrue("Sprite instantiated", sprite is Sprite);
		}

		public function testMonthGetterSetter():void 
			date.month = 1;
			assertEquals(1, date.month);
		}

		public function testAsyncFeature():void 
			// create a new object that dispatches events...
			var dispatcher:IEventDispatcher = new EventDispatcher();
			// get a TestCase async event handler reference
			// the 2nd arg is an optional timeout in ms. (default=1000ms )
			var handler:Function = addAsync(changeHandler, 2000);
			// subscribe to your event dispatcher using the returned handler
			dispatcher.addEventListener(Event.CHANGE, handler);
			// cause the event to be dispatched.
			// either immediately:
			//dispatcher.dispatchEvent(new Event(Event.CHANGE));
			// or in the future < your assigned timeout
			setTimeout(dispatcher.dispatchEvent, 200, new Event(Event.CHANGE));
		}

			// perform assertions in your handler
			assertEquals(Event.CHANGE, event.type);
		}
	}
}