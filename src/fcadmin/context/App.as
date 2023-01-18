/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-10
 ******************************************************************************/



import fcadmin.AdminConnection;
import fcadmin.data.AppStats;
import fcadmin.context.AbstractContext;
import fcadmin.context.ActiveInstance;
import fcadmin.context.ActiveInstancesResult;
import fcadmin.context.AppStatsResult;
import fcadmin.context.CommandResult;
import fcadmin.utils.ResultProxy;


/**
 * App wraps some of Server Management ActionScript API to provide a high 
 * level abstraction for the application management.
 */
class fcadmin.context.App extends AbstractContext
{

	private var __name:String;
	private var __adaptorName:String;
	private var __vhostName:String;

	/**
	 * Return the adaptor name of this app.
	 * @readable true
	 * @writable false
	 */
	function get adaptorName():String
	{
		return __adaptorName;
	}
	

	/**
	 * Return the name of this app.
	 * @readable true
	 * @writable false
	 */
	function get name():String
	{
		return __name;
	}
	

	/**
	 * Return the vhost name of this app.
	 * @readable true
	 * @writable false
	 */
	function get vhostName():String
	{
		return __vhostName;
	}
	



	/**
	 * Constructor, usually you can get the app context
	 * instance from Server.getApps.
	 *
	 * @param adaptorName host adaptor name of this app.
	 * @param vhostName host vhost name of this app.
	 * @param name name of this app.
	 * @param adminConnection the host AdminConnection instance for this app context.
	 * @see fcadmin.context.Server#getApps
	 */
	function App(adaptorName:String,vhostName:String,name:String,adminConnection:AdminConnection)
	{
		super(adminConnection);

		__name=name;
		__adaptorName=adaptorName;
		__vhostName=vhostName;
	}


	/**
	 * Returns an array of ActiveInstance that contains all running 
	 * application instances on the connected virtual host.
	 *
	 * @param result
	 */
	function getActiveInstances(result:ActiveInstancesResult):Void
	{
		var resultProxy:ResultProxy=new ResultProxy(result,"getActiveInstancesSuccess","getActiveInstancesFailed");
		resultProxy["owner"]=this;
		resultProxy.onResult=function(info:Object)
		{
			var len:Number=info.data.length;
			var appList:Array=new Array();
			for(var i=0;i<len;i++)
			{
				var nameBuffer:Array=info.data[i].split("/");
				if(nameBuffer[0]==this.owner.name)
				{
					appList.push(new ActiveInstance(this.owner.adaptorName,this.owner.vhostName,this.owner.name,nameBuffer[1],this.owner.hostConnection));
				}
			}
			if(appList.length>0)
			{
				this.facadeResult(appList);
			}
			else
			{
				this.facadeResult(null);
			}
		}
		callService("getActiveInstances",resultProxy);
	}

	/**
	 * You can use this command to preload an instance of an application or 
	 * reload it when application configuration changes are made or the 
	 * script that is associated with the application has been changed.
	 *
	 * @param instanceName the instance you want to preload
	 * @param result
	 */
	function loadInstance(instanceName:String, result:CommandResult):Void
	{
		var resultProxy:ResultProxy=new ResultProxy(result,"success","failed");
		callService("reloadApp",resultProxy,name+"/"+instanceName);
	}

	/**
	 * Gets aggregate performance data for all instances of the specified application.
	 *
	 * @param result
	 */
	function getStats(result:AppStatsResult):Void
	{
		var resultProxy:ResultProxy=new ResultProxy(result,"getStatsSuccess","getStatsFailed");
		resultProxy.onResult=function(info:Object)
		{
			this.facadeResult(AppStats.fromRawData(info.data));
		}
		callService("getAppStats",resultProxy,name);
	}


	/**
	 * Removes the specified application from the virtual host. First, all instances 
	 * of the specified application are unloaded. Then the application directory is 
	 * removed from the virtual host.
	 *
	 * @param result
	 */
	function remove(result:CommandResult):Void
	{
		var resultProxy:ResultProxy=new ResultProxy(result,"success","failed");
		callService("removeApp",resultProxy,name);
	}


	/**
	 * Shuts down all instances of the specified application, and all the users 
	 * who are connected to any instance of the application are immediately 
	 * disconnected.
	 *
	 * @param result
	 */
	function unload(result:CommandResult):Void
	{
		var resultProxy:ResultProxy=new ResultProxy(result,"success","failed");
		callService("unloadApp",resultProxy,name);
	}


	function getPath():String
	{
		return getHostString() + "/" + adaptorName + "/" + vhostName + "/" + name;
	}


	function toString():String
	{
		return "[App] adaptorName = " + adaptorName + ", vhostName = " + vhostName + ", name = " + name;
	}
}
