package asunit.textui 
	import asunit.framework.TestResult;

		protected var runner:TestRunner;

			super.createChildren();
			runner = new FlexTestRunner();
			rawChildren.addChild(runner);
		}

			return runner.start(testCase, testMethod, showTrace);
		}
	}
}