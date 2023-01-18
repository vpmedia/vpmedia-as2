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

import fcadmin.context.Adaptor;
import fcadmin.context.IOStatsResult;
import fcadmin.context.VHostsResult;
import fcadmin.context.VHost;
import fcadmin.data.IOStats;

import fcadmin.utils.ObjectUtil;


class fcadmin.test.TestAdaptor extends TestCase
{

	private static var logger:Logger = Logger.getLogger("fcadmin.test.TestAdaptor");

	
	public function TestAdaptor( methodName:String )
	{
		super( methodName );
		setClassName("fcadmin.test.TestAdaptor");
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
				TestAdaptor["logger"].info("testIOStats result OK. \r"+ObjectUtil.getProperties(ioStats,true).join("\r"));
			}
			catch(e)
			{
				TestAdaptor["logger"].info("testIOStats result Failed. \r"+e.getFormatString());
			}		
		}		
		adaptor.getIOStats(result);
	}



//------------------------------------------------------------------------------

	public function testVHosts():Void
	{
		var result:VHostsResult=new VHostsResult();
		result.getVHostsSuccess=function(instances:Array)
		{
			if(instances!=undefined)
			{
				try
				{
					assertNotNull(instances[0]);
					assertTrue(instances[0] instanceof VHost);
					TestAdaptor["logger"].info("testVHosts result OK. \r"+ObjectUtil.getProperties(instances[0],true).join("\r"));
				}
				catch(e)
				{
					TestAdaptor["logger"].info("testVHosts result Failed. \r"+e.getFormatString());
				}
			}
			else
			{
				TestAdaptor["logger"].info("testVHosts result OK. ");
			}
		}		
		adaptor.getVHosts(result);
	}

//------------------------------------------------------------------------------


	public static function suite():Test
	{
		return new TestSuite(fcadmin.test.TestAdaptor);
	}

	/**
	 * Runs the test case.
	 */
	public static function main(adp:Adaptor):Void
	{
		adaptor=adp;
		as2unit.textui.TestRunner.run(suite());
	}


	private static var adaptor:Adaptor=null;


	private static var AdaptorDependency:Adaptor=fcadmin.context.Adaptor;

	private static var TestSuiteDependency:TestSuite=as2unit.framework.TestSuite;
	private static var TestDependency:Test=as2unit.framework.Test;	


}

