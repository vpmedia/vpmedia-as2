/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-14
 ******************************************************************************/

import logging.Logger;

import as2unit.framework.TestCase;
import as2unit.framework.TestSuite;
import as2unit.framework.Test;

import fcadmin.context.Server;
import fcadmin.context.LicenseInfoResult;
import fcadmin.context.ServerStatsResult;
import fcadmin.context.MessageCacheResult;
import fcadmin.context.AdaptorsResult;
import fcadmin.context.PingResult;
import fcadmin.context.Adaptor;
import fcadmin.context.App;
import fcadmin.context.AppsResult;
import fcadmin.context.CommandResult;
import fcadmin.context.IOStatsResult;
import fcadmin.context.AdminsResult;
import fcadmin.context.AccessLogEntriesResult;
import fcadmin.data.IOStats;
import fcadmin.data.LicenseSummary;
import fcadmin.data.ServerStats;
import fcadmin.data.MessageCache;
import fcadmin.utils.ObjectUtil;


class fcadmin.test.TestServer extends TestCase
{

	private static var logger:Logger = Logger.getLogger("fcadmin.test.TestServer");

	
	public function TestServer( methodName:String )
	{
		super( methodName );
		setClassName("fcadmin.test.TestServer");
	}

//------------------------------------------------------------------------------


	public function testLicenseInfo():Void
	{
		var result:LicenseInfoResult=new LicenseInfoResult();
		result.getLicenseInfoSuccess=function(info:LicenseSummary)
		{
			try
			{
				assertNotNull(info);
				TestServer["logger"].info("testLicenseInfo result OK. \r"+ObjectUtil.getProperties(info,true).join("\r"));
			}
			catch(e)
			{
				TestServer["logger"].info("testLicenseInfo result Failed. \r"+e.getFormatString());
			}		
		}		
		server.getLicenseInfo(result);
	}



//------------------------------------------------------------------------------

	public function testServerStats():Void
	{
		var result:ServerStatsResult=new ServerStatsResult();
		result.getServerStatsSuccess=function(info:ServerStats)
		{
			try
			{
				assertNotNull(info);
				TestServer["logger"].info("testServerStats result OK. \r"+ObjectUtil.getProperties(info,true).join("\r"));
			}
			catch(e)
			{
				TestServer["logger"].info("testServerStats result Failed. \r"+e.getFormatString());
			}
		}		
		server.getServerStats(result);
	}
//------------------------------------------------------------------------------

	public function testMessageCache():Void
	{
		var result:MessageCacheResult=new MessageCacheResult();
		result.getMessageCacheSuccess=function(info:MessageCache)
		{
			try
			{
				assertNotNull(info);
				TestServer["logger"].info("testMessageCache result OK. \r"+ObjectUtil.getProperties(info,true).join("\r"));
			}
			catch(e)
			{
				TestServer["logger"].info("testMessageCache result Failed. \r"+e.getFormatString());
			}
		}		
		server.getMessageCache(result);
	}
//------------------------------------------------------------------------------

	public function testAdaptors():Void
	{
		var result:AdaptorsResult=new AdaptorsResult();
		result.getAdaptorsSuccess=function(adaptors:Array)
		{
			if(adaptors!=null)
			{
				try
				{
					TestServer["logger"].info("testAdaptors result OK. \r"+ObjectUtil.getProperties(adaptors,true).join("\r"));
				}
				catch(e)
				{
					TestServer["logger"].info("testAdaptors result Failed. \r"+e.getFormatString());
				}
			}
			else
			{
				TestServer["logger"].info("testAdaptors result OK.");
			}
		}
		server.getAdaptors(result);
	}

//------------------------------------------------------------------------------

	public function testPing():Void
	{
		var result:PingResult=new PingResult();
		result.pingSuccess=function(timeStamp:Date)
		{
			try
			{
				assertNotNull(timeStamp);
				TestServer["logger"].info("testPing result OK. \r"+timeStamp);
			}
			catch(e)
			{
				TestServer["logger"].info("testPing result Failed. \r"+e.getFormatString());
			}
		}
		server.ping(result);
	}
//------------------------------------------------------------------------------

	public function testGC():Void
	{
		var result:CommandResult=new CommandResult();
		result.success=function()
		{
			TestServer["logger"].info("testGC result OK.");
		}
		server.gc(result);
	}

//------------------------------------------------------------------------------

	public function testAddApp():Void
	{
		var result:CommandResult=new CommandResult();
		result.success=function()
		{
			TestServer["logger"].info("testAddApp result OK.");
		}
		server.addApp("test_add_app",result);
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
					TestServer["logger"].info("testApps result OK. \r"+ObjectUtil.getProperties(apps,true).join("\r"));
				}
				catch(e)
				{
					TestServer["logger"].info("testApps result Failed. \r"+e.getFormatString());
				}
			}
			else
			{
				TestServer["logger"].info("testApps result OK.");
			}
		}
		server.getApps(result);
	}
//------------------------------------------------------------------------------

	public function testIOStats():Void
	{
		var result:IOStatsResult=new IOStatsResult();
		result.getIOStatsSuccess=function(ioStats:IOStats)
		{
			try
			{
				assertNotNull(ioStats);
				TestServer["logger"].info("testIOStats result OK. \r"+ObjectUtil.getProperties(ioStats,true).join("\r"));
			}
			catch(e)
			{
				TestServer["logger"].info("testIOStats result Failed. \r"+e.getFormatString());
			}		
		}		
		server.getIOStats(result);
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
					TestServer["logger"].info("testAdmins result OK. \r"+ObjectUtil.getProperties(admins,true).join("\r"));
				}
				catch(e)
				{
					TestServer["logger"].info("testAdmins result Failed. \r"+e.getFormatString());
				}
			}
			else
			{
				TestServer["logger"].info("testAdmins result OK.");
			}	
		}		
		server.getAdmins(result);
	}


//------------------------------------------------------------------------------

	public function testLogEntries():Void
	{
		var result:AccessLogEntriesResult=new AccessLogEntriesResult();
		result.getLogEntriesSuccess=function(entries:Array)
		{
			if(entries!=null)
			{
				try
				{
					TestServer["logger"].info("testLogEntries result OK. \r"+ObjectUtil.getProperties(entries,true).join("\r"));
				}
				catch(e)
				{
					TestServer["logger"].info("testLogEntries result Failed. \r"+e.getFormatString());
				}
			}
			else
			{
				TestServer["logger"].info("testLogEntries result OK.");
			}	
		}		
		server.getLogEntries(result);
	}

//------------------------------------------------------------------------------
/*
	public function testAddAdmin():Void
	{
		var result:CommandResult=new CommandResult();
		result.success=function()
		{
			TestServer["logger"].info("testAddAdmin result OK.");
		}
		server.addAdmin("testAdmin","888888",result);
	}
*/
//------------------------------------------------------------------------------
/*

	public function testRestart():Void
	{
		var result:CommandResult=new CommandResult();
		result.success=function()
		{
			TestServer["logger"].info("testRestart result OK.");
		}
		server.restart(result);
	}
*/
//------------------------------------------------------------------------------
/*
	public function testStop():Void
	{
		var result:CommandResult=new CommandResult();
		result.success=function()
		{
			TestServer["logger"].info("testStop result OK.");
		}
		server.stop("normal",result);
	}
*/
//------------------------------------------------------------------------------
/*
	public function testStart():Void
	{
		var result:CommandResult=new CommandResult();
		result.success=function()
		{
			TestServer["logger"].info("testStart result OK.");
		}
		server.start(result);
	}
*/
//------------------------------------------------------------------------------
/*
	public function testUpdateLicenseInfo():Void
	{
		var result:CommandResult=new CommandResult();
		result.success=function()
		{
			TestServer["logger"].info("testUpdateLicense result OK.");
		}
		server.updateLicenseInfo(null,result);
	}
*/
//------------------------------------------------------------------------------







	public static function suite():Test
	{
		return new TestSuite(fcadmin.test.TestServer);
	}

	/**
	 * Runs the test case.
	 */
	public static function main(sv:Server):Void
	{
		server=sv;
		as2unit.textui.TestRunner.run(suite());
	}


	private static var server:Server=null;


	private static var ServerDependency:Server=fcadmin.context.Server;

	private static var TestSuiteDependency:TestSuite=as2unit.framework.TestSuite;
	private static var TestDependency:Test=as2unit.framework.Test;	


}

