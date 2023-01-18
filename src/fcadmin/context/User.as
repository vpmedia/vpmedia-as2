/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-10
 ******************************************************************************/

import fcadmin.AdminConnection;
import fcadmin.context.AbstractContext
import fcadmin.context.UserStatsResult;
import fcadmin.data.UserStats;
import fcadmin.utils.ResultProxy;

/**
 * User wraps some of Server Management ActionScript API to provide a high 
 * level abstraction for the user management.
 */
class fcadmin.context.User extends AbstractContext
{

	private var __name:String;
	private var __adaptorName:String;
	private var __vhostName:String;
	private var __appName:String;
	private var __instanceName:String;


	/**
	 * Return the adaptor name of this user.
	 * @readable true
	 * @writable false
	 */
	function get adaptorName():String
	{
		return __adaptorName;
	}
	

	/**
	 * Return the name of this user.
	 * @readable true
	 * @writable false
	 */
	function get name():String
	{
		return __name;
	}
	

	/**
	 * Return the vhost name of this user.
	 * @readable true
	 * @writable false
	 */
	function get vhostName():String
	{
		return __vhostName;
	}


	/**
	 * Return the app name of this user.
	 * @readable true
	 * @writable false
	 */
	function get appName():String
	{
		return __appName;
	}

	/**
	 * Return the instance name of this user.
	 * @readable true
	 * @writable false
	 */
	function get instanceName():String
	{
		return __instanceName;
	}
	


	/**
	 * Constructor, usually you can get the user context
	 * from ActiveInstance.getUsers.
	 *
	 * @param adaptorName host adaptor name of this user.
	 * @param vhostName host vhost name of this user.
	 * @param appName host vhost name of this user.
	 * @param instanceName instance name of this user.
	 * @param name name of this user.
	 * @param adminConnection the host AdminConnection instance for this user context.
	 * @see fcadmin.context.ActiveInstance#getUsers
	 */
	function User(adaptorName:String,vhostName:String,appName:String,instanceName:String,name:String,adminConnection:AdminConnection)
	{
		super(adminConnection);
		__name=name;
		__adaptorName=adaptorName;
		__vhostName=vhostName;
		__appName=appName;
		__instanceName=instanceName;

	}


	

	/**
	 * Gets detailed information for one or more network streams that 
	 * are connecting to the specified instance of an application.
	 *
	 * @param result
	 */	
	function getStats(result:UserStatsResult):Void
	{
		var resultProxy:ResultProxy=new ResultProxy(result,"getStatsSuccess","getStatsFailed");
		resultProxy.handleResult=function(info)
		{
			this.facadeResult(UserStats.fromRawData(info.data));
		}
		callService("getUserStats",resultProxy,appName+"/"+instanceName,name);
	}


	function getPath():String
	{
		return getHostString() + "/" + adaptorName + "/" + vhostName + "/" + appName + "/" + instanceName + "/users/" + name;
	}


	function toString():String
	{
		return "[User] adaptorName = " + adaptorName + ", vhostName = " + vhostName + ", appName = " + appName + ", instanceName = " + instanceName + ", name = " + name;
	}
}

