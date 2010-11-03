package asunit.framework 
	import com.atmospherebbdo.errors.AssertionFailureError;		
	 * A <code>TestFailure</code> collects a failed test together with
	 * the caught exception.
	 * @see TestResult
	 */
	public class TestFailure 
		protected var fFailedTest:Test;
		protected var fFailedTestMethod:String;
		protected var fThrownException:Error;

		 * Constructs a TestFailure with the given test and exception.
		 */
		public function TestFailure(failedTest:Test, thrownException:Error) 
			fFailedTest = failedTest;
			fFailedTestMethod = failedTest.getCurrentMethod();
			fThrownException = thrownException;
		}

			return failedTest().getName() + '.' + fFailedTestMethod;
		}

			return fFailedTestMethod;
		}

		 * Gets the failed test case.
		 */
		public function failedTest():Test 
			return fFailedTest;
		}

		 * Gets the thrown exception.
		 */
		public function thrownException():Error 
			return fThrownException;
		}

		 * Returns a short description of the failure.
		 */
		public function toString():String 
			return "";
		}

			return thrownException().message;
		}

			return thrownException() is AssertionFailureError;
		}
	}
}