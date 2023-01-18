/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-10
 ******************************************************************************/

import fcadmin.AdminConnection;
import fcadmin.context.AbstractContext
import fcadmin.context.SharedObjectStatsResult;
import fcadmin.data.SharedObjectStats;
import fcadmin.utils.ResultProxy;

/**
 * SharedObjectContext wraps some of Server Management ActionScript API to provide a high 
 * level abstraction for the application shared object management.
 */
class fcadmin.context.SharedObjectContext extends AbstractContext
{

	private var __persistent:Boolean;
	private var __name:String;
	private var __adaptorName:String;
	private var __vhostName:String;
	private var __appName:String;
	private var __instanceName:String;

	/**
	 * Return the adaptor name of this sharedObject.
	 * @readable true
	 * @writable false
	 */
	function get adaptorName():String
	{
		return __adaptorName;
	}
	

	/**
	 * Return the name of this sharedObject.
	 * @readable true
	 * @writable false
	 */
	function get name():String
	{
		return __name;
	}
	

	/**
	 * Return the vhost name of this sharedObject.
	 * @readable true
	 * @writable false
	 */
	function get vhostName():String
	{
		return __vhostName;
	}


	/**
	 * Return the app name of this sharedObject.
	 * @readable true
	 * @writable false
	 */
	function get appName():String
	{
		return __appName;
	}

	/**
	 * Return the instance name of this sharedObject.
	 * @readable true
	 * @writable false
	 */
	function get instanceName():String
	{
		return __instanceName;
	}
	

	/**
	 * Return the persistent of this sharedObject.
	 * @readable true
	 * @writable false
	 */
	function get persistent():Boolean
	{
		return __persistent;
	}


	/**
	 * Constructor, usually you can get the sharedObject context
	 * from ActiveInstance.getSharedObjects.
	 *
	 * @param adaptorName host adaptor name of this sharedObject.
	 * @param vhostName host vhost name of this sharedObject.
	 * @param appName host vhost name of this sharedObject.
	 * @param instanceName instance name of this sharedObject.
	 * @param name name of this sharedObject.
	 * @param persistent persistent of this sharedObject.
	 * @param adminConnection the host AdminConnection instance for this sharedObject context.
	 * @see fcadmin.context.ActiveInstance#getSharedObjects
	 */
	function SharedObjectContext(adaptorName:String,vhostName:String,appName:String,instanceName:String,name:String,persistent:Boolean,adminConnection:AdminConnection)
	{
		super(adminConnection);
		__name=name;
		__adaptorName=adaptorName;
		__vhostName=vhostName;
		__appName=appName;
		__instanceName=instanceName;
		__persistent=persistent;

	}

	

	/**
	 * Gets detailed information about a shared object.
	 *
	 * @param result
	 */	
	function getStats(result:SharedObjectStatsResult):Void
	{
		var resultProxy:ResultProxy=new ResultProxy(result,"getStatsSuccess","getStatsFailed");
		resultProxy.handleResult=function(info)
		{
			this.facadeResult(SharedObjectStats.fromRawData(info.data));
		}
		callService("getSharedObjectStats",resultProxy,appName+"/"+instanceName,name,persistent);
	}

	function getPath():String
	{
		return getHostString() + "/" + adaptorName + "/" + vhostName + "/" + appName + "/" + instanceName + "/sharedobjects" + name;
	}

	function toString():String
	{
		return "[SharedObjectContext] adaptorName = " + adaptorName + ", vhostName = " + vhostName + ", appName = " + appName + ", instanceName = " + instanceName + ", persistent = " + persistent + ", name = " + name;
	}
}

