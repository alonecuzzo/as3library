package 
{
	import asunit.textui.TestRunner;

	import flash.display.Stage;	

	public class AsUnitTestRunner extends TestRunner 
	{
		public static var STAGE:Stage;
		
		public function AsUnitTestRunner() 
		{
			start(AllTests, null, TestRunner.SHOW_TRACE);
			
			STAGE = stage;
		}
	}
}
