package asunit.framework {
	import com.atmospherebbdo.errors.AssertionFailureError;		
	public interface TestListener 	{
		/**
		 * Run the provided Test.
		 */
		function run(test:Test):void;
		/**
		 * A test started.
		 */
		function startTest(test:Test):void;
		/**
		 * A failure occurred.
		 */
		function addFailure(test:Test, t:AssertionFailureError):void;  
		/**
		 * An error occurred.
		 */
		function addError(test:Test, t:Error):void;
		/**
		 * A test method has begun execution.
		 */
		function startTestMethod(test:Test, methodName:String):void;
		/**
		 * A test method has completed.
		 */
		function endTestMethod(test:Test, methodName:String):void;
		/**
		 * A test ended.
		 */
		function endTest(test:Test):void; 
	}
}