/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-13
 ******************************************************************************/

import logging.Logger;

import as2unit.framework.TestCase;
import as2unit.framework.TestSuite;
import as2unit.framework.Test;

import fcadmin.context.App;
import fcadmin.context.ActiveInstance;
import fcadmin.context.AppStatsResult;
import fcadmin.context.ActiveInstancesResult;
import fcadmin.context.CommandResult;
import fcadmin.data.AppStats;

import fcadmin.utils.ObjectUtil;

class fcadmin.test.TestApp extends TestCase
{

	private static var logger:Logger = Logger.getLogger("fcadmin.test.TestApp");

	
	public function TestApp( methodName:String )
	{
		super( methodName );
		setClassName("fcadmin.test.TestApp");
	}

//------------------------------------------------------------------------------


	public function testAppStats():Void
	{
		var result:AppStatsResult=new AppStatsResult();
		result.getStatsSuccess=function(appStats:AppStats)
		{
			try
			{
				assertNotNull(appStats);
				TestApp["logger"].info("testAppStats result OK. \r"+ObjectUtil.getProperties(appStats,true).join("\r"));
			}
			catch(e)
			{
				TestApp["logger"].info("testAppStats result Failed. \r"+e.getFormatString());
			}
		}		
		app.getStats(result);
	}



//------------------------------------------------------------------------------

	public function testActiveInstances():Void
	{
		var result:ActiveInstancesResult=new ActiveInstancesResult();
		result.getActiveInstancesSuccess=function(instances:Array)
		{
			if(instances!=undefined)
			{
				try
				{
					TestApp["logger"].info("testActiveInstances result OK. \r"+ObjectUtil.getProperties(instances,true).join("\r"));
				}
				catch(e)
				{
					TestApp["logger"].info("testActiveInstances result Failed. \r"+e.getFormatString());
				}
			}
			else
			{
				TestApp["logger"].info("testActiveInstances result OK. ");
			}
		}		
		app.getActiveInstances(result);
	}

//------------------------------------------------------------------------------

	public function testLoadInstance():Void
	{
		var result:CommandResult=new CommandResult();
		result.success=function()
		{
			TestApp["logger"].info("testLoadInstance result OK. ");
		}		
		app.loadInstance("testLoadInstance",result);
	}


//------------------------------------------------------------------------------
/*
	public function testRemove():Void
	{
		var result:CommandResult=new CommandResult();
		result.success=function()
		{
			TestApp["logger"].info("testRemove result OK.");
		}
		app.remove(result);
	}
*/
//------------------------------------------------------------------------------

/*
	public function testUnload():Void
	{
		var result:CommandResult=new CommandResult();
		result.success=function()
		{
			TestApp["logger"].info("testUnload result OK.");
		}
		app.unload(result);

	}
*/

//------------------------------------------------------------------------------



	public static function suite():Test
	{
		return new TestSuite(fcadmin.test.TestApp);
	}

	/**
	 * Runs the test case.
	 */
	public static function main(appc:App):Void
	{
		app=appc;
		as2unit.textui.TestRunner.run(suite());
	}


	private static var app:App;


	private static var AppDependency:App=fcadmin.context.App;

	private static var TestSuiteDependency:TestSuite=as2unit.framework.TestSuite;
	private static var TestDependency:Test=as2unit.framework.Test;	


}

