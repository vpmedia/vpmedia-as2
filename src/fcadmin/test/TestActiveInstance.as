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

import fcadmin.context.ActiveInstance;
import fcadmin.context.ActiveInstanceStatsResult;
import fcadmin.context.ScriptStatsResult;
import fcadmin.context.User;
import fcadmin.context.UsersResult;
import fcadmin.context.SharedObjectContext;
import fcadmin.context.SharedObjectsResult;
import fcadmin.context.StreamContext;
import fcadmin.context.StreamsResult;
import fcadmin.context.CommandResult;
import fcadmin.context.InstanceLogEntriesResult;
import fcadmin.data.ScriptStats;
import fcadmin.data.ActiveInstanceStats;

import fcadmin.utils.ObjectUtil;


class fcadmin.test.TestActiveInstance extends TestCase
{

	private static var logger:Logger = Logger.getLogger("fcadmin.test.TestActiveInstance");

	
	public function TestActiveInstance( methodName:String )
	{
		super( methodName );
		setClassName("fcadmin.test.TestActiveInstance");
	}

//------------------------------------------------------------------------------


	public function testActiveInstanceStats():Void
	{
		var result:ActiveInstanceStatsResult=new ActiveInstanceStatsResult();
		result.getStatsSuccess=function(ais:ActiveInstanceStats)
		{
			try
			{
				assertNotNull(ais);
				TestActiveInstance["logger"].info("testActiveInstanceStats result OK. \r"+ObjectUtil.getProperties(ais,true).join("\r"));
			}
			catch(e)
			{
				TestActiveInstance["logger"].info("testActiveInstanceStats result Failed. \r"+e.getFormatString());
			}		
		}		
		instance.getStats(result);
	}

//------------------------------------------------------------------------------


	public function testScriptStats():Void
	{
		var result:ScriptStatsResult=new ScriptStatsResult();
		result.getScriptStatsSuccess=function(info:ScriptStats)
		{
			try
			{
				assertNotNull(info);
				TestActiveInstance["logger"].info("testScriptStats result OK. \r"+ObjectUtil.getProperties(info,true).join("\r"));
			}
			catch(e)
			{
				TestActiveInstance["logger"].info("testScriptStats result Failed. \r"+e.getFormatString());
			}
		}		
		instance.getScriptStats(result);
	}

//------------------------------------------------------------------------------

	public function testUsers():Void
	{
		var result:UsersResult=new UsersResult();
		result.getUsersSuccess=function(users:Array)
		{
			if(users!=null)
			{
				try
				{
					TestActiveInstance["logger"].info("testUsers result OK. \r"+ObjectUtil.getProperties(users,true).join("\r"));
				}
				catch(e)
				{
					TestActiveInstance["logger"].info("testUsers result Failed. \r"+e.getFormatString());
				}
			}
			else
			{
				TestActiveInstance["logger"].info("testUsers result OK.");
			}
		}
		instance.getUsers(result);
	}

//------------------------------------------------------------------------------

	public function testSharedObjects():Void
	{
		var result:SharedObjectsResult=new SharedObjectsResult();
		result.getSharedObjectsSuccess=function(socs:Array)
		{
			if(socs!=null)
			{
				try
				{
					TestActiveInstance["logger"].info("testSharedObjects result OK. \r"+ObjectUtil.getProperties(socs,true).join("\r"));
				}
				catch(e)
				{
					TestActiveInstance["logger"].info("testSharedObjects result Failed. \r"+e.getFormatString());
				}
			}
			else
			{
				TestActiveInstance["logger"].info("testSharedObjects result OK.");
			}
		}
		instance.getSharedObjects(result);
	}

//------------------------------------------------------------------------------

	public function testStreams():Void
	{
		var result:StreamsResult=new StreamsResult();
		result.getStreamsSuccess=function(streams:Array)
		{
			if(streams!=null)
			{
				try
				{
					TestActiveInstance["logger"].info("testStreams result OK. \r"+ObjectUtil.getProperties(streams,true).join("\r"));
				}
				catch(e)
				{
					TestActiveInstance["logger"].info("testStreams result Failed. \r"+e.getFormatString());
				}
			}
			else
			{
				TestActiveInstance["logger"].info("testStreams result OK.");
			}
		}
		instance.getStreams(result);
	}
//------------------------------------------------------------------------------

	public function testLogEntries():Void
	{
		var result:InstanceLogEntriesResult=new InstanceLogEntriesResult();
		result.getLogEntriesSuccess=function(entries:Array)
		{
			if(entries!=null)
			{
				try
				{
					TestActiveInstance["logger"].info("testLogEntries result OK. \r"+ObjectUtil.getProperties(entries,true).join("\r"));
				}
				catch(e)
				{
					TestActiveInstance["logger"].info("testLogEntries result Failed. \r"+e.getFormatString());
				}
			}
			else
			{
				TestActiveInstance["logger"].info("testLogEntries result OK.");
			}
		}
		instance.getLogEntries(result);
	}
//------------------------------------------------------------------------------
/*
	public function testReload():Void
	{
		var result:CommandResult=new CommandResult();
		result.success=function()
		{
			TestActiveInstance["logger"].info("testReload result OK.");
		}
		instance.reload(result);
	}
*/
//------------------------------------------------------------------------------
/*
	public function testRemove():Void
	{
		var result:CommandResult=new CommandResult();
		result.success=function()
		{
			TestActiveInstance["logger"].info("testRemove result OK.");
		}
		instance.remove(result);		
	}
*/
//------------------------------------------------------------------------------
/*
	public function testUnload():Void
	{
		var result:CommandResult=new CommandResult();
		result.success=function()
		{
			TestActiveInstance["logger"].info("testUnload result OK.");
		}
		instance.unload(result);		
	}
*/
//------------------------------------------------------------------------------

	public static function suite():Test
	{
		return new TestSuite(fcadmin.test.TestActiveInstance);
	}

	/**
	 * Runs the test case.
	 */
	public static function main(ai:ActiveInstance):Void
	{
		instance=ai;
		as2unit.textui.TestRunner.run(suite());
	}


	private static var instance:ActiveInstance;


	private static var ActiveInstanceDependency:ActiveInstance=fcadmin.context.ActiveInstance;

	private static var TestSuiteDependency:TestSuite=as2unit.framework.TestSuite;
	private static var TestDependency:Test=as2unit.framework.Test;	


}

