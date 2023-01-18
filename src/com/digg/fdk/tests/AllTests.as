/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: AllTests.as 586 2007-01-11 21:35:21Z allens $
 */

import asunit.framework.TestSuite;
import com.digg.fdk.tests.*;

class com.digg.fdk.tests.AllTests extends TestSuite
{
    private var className:String = 'com.digg.fdk.tests.AllTests';
    public static var allTests:AllTests = null;

    public function AllTests()
    {
        super();
        addTest(new ColorTest());
    }
}
