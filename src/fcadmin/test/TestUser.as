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

import fcadmin.context.UserStatsResult;
import fcadmin.context.User;
import fcadmin.data.UserStats;

import fcadmin.utils.ObjectUtil;


class fcadmin.test.TestUser extends TestCase
{

	private static var logger:Logger = Logger.getLogger("fcadmin.test.TestUser");

	
	public function TestUser( methodName:String )
	{
		super( methodName );
		setClassName("fcadmin.test.TestUser");
	}

//------------------------------------------------------------------------------


	public function testStats():Void
	{
		var result:UserStatsResult=new UserStatsResult();
		result.getStatsSuccess=function(userStats:UserStats)
		{
			try
			{
				assertNotNull(userStats);
				TestUser["logger"].info("testStats result OK. \r"+ObjectUtil.getProperties(userStats,true).join("\r"));
			}
			catch(e)
			{
				TestUser["logger"].info("testStats result Failed. \r"+e.getFormatString());
			}		
		}
		user.getStats(result);
	}

//------------------------------------------------------------------------------


	public static function suite():Test
	{
		return new TestSuite(fcadmin.test.TestUser);
	}

	/**
	 * Runs the test case.
	 */
	public static function main(u:User):Void
	{
		
		user=u;
		as2unit.textui.TestRunner.run(suite());
	}


	private static var user:User=null;


	private static var UserDependency:User=fcadmin.context.User;

	private static var TestSuiteDependency:TestSuite=as2unit.framework.TestSuite;
	private static var TestDependency:Test=as2unit.framework.Test;	

}

