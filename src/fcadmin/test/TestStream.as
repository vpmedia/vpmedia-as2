/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-9
 ******************************************************************************/

import logging.Logger;

import as2unit.framework.TestCase;
import as2unit.framework.TestSuite;
import as2unit.framework.Test;

import fcadmin.context.StreamStatsResult;
import fcadmin.context.StreamContext;
import fcadmin.data.StreamStats;

import fcadmin.utils.ObjectUtil;


class fcadmin.test.TestStream extends TestCase
{

	private static var logger:Logger = Logger.getLogger("fcadmin.test.TestStream");

	
	public function TestStream( methodName:String )
	{
		super( methodName );
		setClassName("fcadmin.test.TestStream");
	}

//------------------------------------------------------------------------------


	public function testStats():Void
	{
		var result:StreamStatsResult=new StreamStatsResult();
		result.getStatsSuccess=function(streamStats:StreamStats)
		{
			try
			{
				assertNotNull(streamStats);
				TestStream["logger"].info("testStats result OK. \r"+ObjectUtil.getProperties(streamStats,true).join("\r"));
			}
			catch(e)
			{
				TestStream["logger"].info("testStats result Failed. \r"+e.getFormatString());
			}		
		}
		stream.getStats(result);
	}

//------------------------------------------------------------------------------


	public static function suite():Test
	{
		return new TestSuite(fcadmin.test.TestStream);
	}

	/**
	 * Runs the test case.
	 */
	public static function main(s:StreamContext):Void
	{		
		stream=s;
		as2unit.textui.TestRunner.run(suite());
	}


	private static var stream:StreamContext=null;


	private static var StreamDependency:StreamContext=fcadmin.context.StreamContext;

	private static var TestSuiteDependency:TestSuite=as2unit.framework.TestSuite;
	private static var TestDependency:Test=as2unit.framework.Test;	

}

