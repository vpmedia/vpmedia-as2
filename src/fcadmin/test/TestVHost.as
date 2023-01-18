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

import fcadmin.context.VHostStatsResult;
import fcadmin.context.VHost;
import fcadmin.context.CommandResult;
import fcadmin.context.AppsResult;
import fcadmin.context.App;
import fcadmin.context.AdminsResult;
import fcadmin.data.VHostStats;
import fcadmin.data.StatusObject;
import fcadmin.utils.ObjectUtil;


class fcadmin.test.TestVHost extends TestCase
{

	private static var logger:Logger = Logger.getLogger("fcadmin.test.TestVHost");

	
	public function TestVHost( methodName:String )
	{
		super( methodName );
		setClassName("fcadmin.test.TestVHost");
	}

//------------------------------------------------------------------------------


	public function testStats():Void
	{
		var result:VHostStatsResult=new VHostStatsResult();
		result.getStatsSuccess=function(vhStats:VHostStats)
		{
			try
			{
				assertNotNull(vhStats);
				TestVHost["logger"].info("testStats result OK. \r"+ObjectUtil.getProperties(vhStats,true).join("\r"));
			}
			catch(e)
			{
				TestVHost["logger"].info("testStats result Failed. \r"+e.getFormatString());
			}		
		}
		vhost.getStats(result);
	}

//------------------------------------------------------------------------------

	public function testAddApp():Void
	{
		var result:CommandResult=new CommandResult();
		result.success=function()
		{
			TestVHost["logger"].info("testAddApp result OK.");
		}
		vhost.addApp("test_add_app",result);
	}

//------------------------------------------------------------------------------

	public function testApps():Void
	{
		var result:AppsResult=new AppsResult();
		result.getAppsSuccess=function(apps:Array)
		{
			if(apps!=null)
			{
				try
				{
					TestVHost["logger"].info("testApps result OK. \r"+ObjectUtil.getProperties(apps,true).join("\r"));
				}
				catch(e)
				{
					TestVHost["logger"].info("testApps result Failed. \r"+e.getFormatString());
				}
			}
			else
			{
				TestVHost["logger"].info("testApps result OK.");
			}
		}
		vhost.getApps(result);
	}
//------------------------------------------------------------------------------
	public function testAdmins():Void
	{
		var result:AdminsResult=new AdminsResult();
		result.getAdminsSuccess=function(admins:Array)
		{
			if(admins!=null)
			{
				try
				{
					TestVHost["logger"].info("testAdmins result OK. \r"+ObjectUtil.getProperties(admins,true).join("\r"));
				}
				catch(e)
				{
					TestVHost["logger"].info("testAdmins result Failed. \r"+e.getFormatString());
				}
			}
			else
			{
				TestVHost["logger"].info("testAdmins result OK.");
			}	
		}		
		vhost.getAdmins(result);
	}
//------------------------------------------------------------------------------
/*
	public function testAddAdmin():Void
	{
		var result:CommandResult=new CommandResult();
		result.success=function()
		{
			TestVHost["logger"].info("testAddAdmin result OK.");
		}
		vhost.addAdmin("testAdminVHost","888888",result);
	}
*/

//------------------------------------------------------------------------------
/*
	//Admin.Server.Reconnect.Success

	public function testRestart():Void
	{
		var result:CommandResult=new CommandResult();
		result.success=function()
		{
			TestVHost["logger"].info("testRestart result OK.");
		}
		vhost.restart(result);
	}
*/
//------------------------------------------------------------------------------
/*
	public function testStop():Void
	{
		var result:CommandResult=new CommandResult();
		result.success=function()
		{
			TestVHost["logger"].info("testStop result OK.");
		}
		vhost.stop(result);
	}
*/
//------------------------------------------------------------------------------
/*
	public function testStart():Void
	{
		var result:CommandResult=new CommandResult();
		result.success=function()
		{
			TestVHost["logger"].info("testStart result OK.");
		}
		vhost.start(result);
	}
*/
//------------------------------------------------------------------------------

	public static function suite():Test
	{
		return new TestSuite(fcadmin.test.TestVHost);
	}

	/**
	 * Runs the test case.
	 */
	public static function main(vh:VHost):Void
	{
		
		vhost=vh;
		as2unit.textui.TestRunner.run(suite());
	}


	private static var vhost:VHost=null;


	private static var VHostDependency:VHost=fcadmin.context.VHost;

	private static var TestSuiteDependency:TestSuite=as2unit.framework.TestSuite;
	private static var TestDependency:Test=as2unit.framework.Test;	


}

