/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-10
 ******************************************************************************/


import fcadmin.AdminConnection;
import fcadmin.context.AbstractContext;
import fcadmin.context.VHostsResult;
import fcadmin.context.VHost;
import fcadmin.context.IOStatsResult;
import fcadmin.context.PermissionError;
import fcadmin.context.UnsupportedOperationError;
import fcadmin.data.IOStats;
import fcadmin.utils.ResultProxy;

/**
 * Server wraps some of Server Management ActionScript API to provide a high 
 * level abstraction for the adaptor management.
 */
class fcadmin.context.Adaptor extends AbstractContext
{
	
	
	private var __name:String;
	
	
	/**
	 * Return the name of this adaptor.
	 * @readable true
	 * @writable false
	 */
	function get name():String
	{
		return __name;
	}


	/**
	 * Constructor, usually you can get the specified adaptor context
	 * instance from AdminConnection.adaptor after it connected
	 * successfully.
	 *
	 * @param name name of this adaptor.
	 * @param adminConnection the host AdminConnection instance for this 
	 *				adaptor context.
	 * @see fcadmin.AdminConnection.adaptor
	 */
	function Adaptor(name:String,adminConnection:AdminConnection)
	{
		super(adminConnection);

		__name=name;

	}

	



	/**
	 * Returns an array of vhosts defined for the specified adaptor. 
	 * You must be a server administrator to perform this command. 
	 *
	 * @param result
	 * @throw fcadmin.context.PermissionError
	 */
	function getVHosts(result:VHostsResult):Void
	{
		checkPermission("server");
		var resultProxy:ResultProxy=new ResultProxy(result,"getVHostsSuccess","getVHostsFailed");
		resultProxy.owner=this;
		resultProxy.handleResult=function(info)
		{			
			var vhs:Array=new Array();
			for(var i:Number=0;i<info.data.length;i++)
			{
				vhs.push(new VHost(this.owner.name,info.data[i],this.owner.hostConnection));
			}
			if(vhs.length>0)
			{
				this.facadeResult(vhs);
			}
			else
			{
				this.facadeResult(null);
			}	
		}
		callService("getVHosts",resultProxy,name);
	}

	

	/**
	 * Returns detailed information about the network I/O characteristics 
	 * of the connected adaptor. 
	 * You must be a server administrator to perform this operation.
	 * This method is only valid for the adaptor which the host connection
	 * is connected, failure to do so will cause a UnsupportedOperationError
	 * to be thrown.
	 *
	 * @param result
	 * @throw fcadmin.context.PermissionError
	 * @throw fcadmin.context.UnsupportedOperationError;
	 */	
	function getIOStats(result:IOStatsResult):Void
	{
		checkOwnerAdaptor();
		checkPermission("server");		
		var resultProxy:ResultProxy=new ResultProxy(result,"getIOStatsSuccess","getIOStatsFailed");
		resultProxy.handleResult=function(info)
		{
			this.facadeResult(IOStats.fromRawData(info.data));
		}
		callService("getIOStats",resultProxy);
	}


	function getPath():String
	{
		return getHostString() + "/" + name;
	}
	


	private function checkOwnerAdaptor():Void
	{
		var adaptorName:String=hostConnection.adaptor.name;
		if(adaptorName!=name)
		{
			throw new UnsupportedOperationError(adaptorName);
		}
	}


	function toString():String
	{
		return "[Adaptor] name = " + name;
	}

}