/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-11-22
 ******************************************************************************/

import logging.Logger;

import as2unit.framework.TestCase;
import as2unit.framework.TestSuite;
import as2unit.framework.Test;

import fcadmin.context.SharedObjectStatsResult;
import fcadmin.context.SharedObjectContext;
import fcadmin.data.SharedObjectStats;

import fcadmin.utils.ObjectUtil;


class fcadmin.test.TestSharedObject extends TestCase
{

	private static var logger:Logger = Logger.getLogger("fcadmin.test.TestSharedObject");

	
	public function TestSharedObject( methodName:String )
	{
		super( methodName );
		setClassName("fcadmin.test.TestSharedObject");
	}

//------------------------------------------------------------------------------


	public function testStats():Void
	{
		var result:SharedObjectStatsResult=new SharedObjectStatsResult();
		result.getStatsSuccess=function(shs:SharedObjectStats)
		{
			try
			{
				assertNotNull(shs);
				TestSharedObject["logger"].info("testStats result OK. \r"+ObjectUtil.getProperties(shs,true).join("\r"));
			}
			catch(e)
			{
				TestSharedObject["logger"].info("testStats result Failed. \r"+e.getFormatString());
			}		
		}
		soc.getStats(result);
	}

//------------------------------------------------------------------------------


	public static function suite():Test
	{
		return new TestSuite(fcadmin.test.TestSharedObject);
	}

	/**
	 * Runs the test case.
	 */
	public static function main(s:SharedObjectContext):Void
	{
		
		soc=s;
		as2unit.textui.TestRunner.run(suite());
	}


	private static var soc:SharedObjectContext=null;


	private static var SharedObjectContextDependency:SharedObjectContext=fcadmin.context.SharedObjectContext;

	private static var TestSuiteDependency:TestSuite=as2unit.framework.TestSuite;
	private static var TestDependency:Test=as2unit.framework.Test;	

}

