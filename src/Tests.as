import mx.utils.Delegate;

import test_framework.logging.LogManager;
import test_framework.test.unit.LoggerTestListener;
import test_framework.test.unit.TestSuite;
import test_framework.test.unit.TestSuiteFactory;

class Tests
{
	public static function main() : Void
	{
		var tests : Tests = new Tests();
		tests.startSuite();
	}
	
	private function Tests()
	{
	}
	
	public function startSuite ()
	{
		LogManager.getInstance().loadCofig("logging.xml");
		LogManager.getInstance().addEventListener("configApplied", Delegate.create(this, onLoggerConfigured));
	}

	private function onLoggerConfigured ()
	{
		startTests ();
	}
	
	private function startTests ()
	{
		var factory:TestSuiteFactory = new TestSuiteFactory();
		var suite:TestSuite = factory.collectAllTestCases();
    	suite.addListener(LoggerTestListener.getInstance());
    	suite.start();
	}
}