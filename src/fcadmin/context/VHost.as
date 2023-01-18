/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2005-1-6
 ******************************************************************************/

import fcadmin.AdminConnection;
import fcadmin.context.AbstractContext
import fcadmin.context.VHostsResult;
import fcadmin.context.VHostStatsResult;
import fcadmin.context.PermissionError;
import fcadmin.context.CommandResult;
import fcadmin.context.AppsResult;
import fcadmin.context.App;
import fcadmin.context.UnsupportedOperationError;
import fcadmin.context.AdminsResult;
import fcadmin.context.Admin;
import fcadmin.data.VHostStats;
import fcadmin.utils.ResultProxy;

/**
 * VHost wraps some of Server Management ActionScript API to provide a high 
 * level abstraction for the vhost management.
 */
class fcadmin.context.VHost extends AbstractContext
{

	private var __name:String;
	private var __adaptorName:String;
	
	

	/**
	 * Return the adaptor name of this vhost.
	 * @readable true
	 * @writable false
	 */
	function get adaptorName():String
	{
		return __adaptorName;
	}
	

	/**
	 * Return the name of this vhost.
	 * @readable true
	 * @writable false
	 */
	function get name():String
	{
		return __name;
	}
	


	/**
	 * Constructor, usually you can get the specified adaptor context
	 * instance from AdminConnection.vhost after it connected
	 * successfully.
	 *
	 * @param adaptorName host adaptor name of this vhost.
	 * @param name name of this vhost.
	 * @param adminConnection the host AdminConnection instance for this vhost context.
	 * @see fcadmin.AdminConnection.vhost
	 */
	function VHost(adaptorName:String,name:String,adminConnection:AdminConnection)
	{
		super(adminConnection);

		__adaptorName=adaptorName;
		__name=name;

	}


	

	/**
	 * Returns aggregate performance data for all instances for all 
	 * applications for the specified vhost. 
	 * You must be a server administrator to perform this command.
	 *
	 * @param result
	 * @throw fcadmin.context.PermissionError
	 */	
	function getStats(result:VHostStatsResult):Void
	{
		checkPermission("server");
		var resultProxy:ResultProxy=new ResultProxy(result,"getStatsSuccess","getStatsFailed");
		resultProxy.handleResult=function(info)
		{
			this.facadeResult(VHostStats.fromRawData(info.data));
		}
		callService("getVHostStats",resultProxy,adaptorName,name);
	}

	/**
	 * Adds a new application to the virtual host by creating the required directory 
	 * for the new application in the directory tree. Once the directory for the new 
	 * application is created, you (or another administrator with file system access) 
	 * can put any required server-side scripts in the directory. 
	 * The client-side code uses the new application directory in the URI parameter 
	 * of the NetConnection.Connect call.
	 * This method is only valid for the vhost which the host connection
	 * is connected, failure to do so will cause a UnsupportedOperationError
	 * to be thrown.
	 *
	 * @param appName String that contains the name of the application to be added.
	 * @param result
	 * @throw fcadmin.context.UnsupportedOperationError
	 */
	function addApp(appName:String,result:CommandResult):Void
	{
		checkOwnerVHost();
		var resultProxy:ResultProxy=new ResultProxy(result,"success","failed");
		callService("addApp",resultProxy,appName);
	}

	/**
	 * Returns an array of App that that are installed on this vhost. 
	 * This method is only valid for the vhost which the host connection
	 * is connected, failure to do so will cause a UnsupportedOperationError
	 * to be thrown.
	 *
	 * @param result
	 * @throw fcadmin.context.UnsupportedOperationError
	 */
	function getApps(result:AppsResult):Void
	{
		checkOwnerVHost();
		var resultProxy:ResultProxy=new ResultProxy(result,"getAppsSuccess","getAppsFailed");
		resultProxy["owner"]=this;
		resultProxy.handleResult=function(info)
		{
			var apps:Array=new Array();

			var repeatCache:Object=new Object();//workaround a bug in FlashComm admin server 

			for(var i:Number=0;i<info.data.length;i++)
			{
				if(repeatCache[info.data[i]]==undefined)
				{
					apps.push(new App(this.owner.adaptorName,this.owner.name,info.data[i],this.owner.hostConnection));
					repeatCache[info.data[i]]=true;
				}
			}
			if(apps.length>0)
			{
				this.facadeResult(apps);
			}
			else
			{
				this.facadeResult(null);
			}
		}
		callService("getApps",resultProxy);
	}

	/**
	 * Restarts a virtual host that is currently running. 
	 * Restarting a virtual host disconnects all connected users, unloads
	 * all currently loaded applications, and reloads the configuration 
	 * files for that virtual host.
	 * If you make changes to the configuration files for a virtual host,
	 * you can use this command to restart the virtual host without 
	 * restarting the server.
	 * Users must reconnect each time you restart a virtual host. Before 
	 * using this command, you might want to take steps to notify 
	 * connected users.
	 * Virtual host administrators can only restart the virtual hosts to 
	 * which they are connected. 
	 * You must be a server administrator to start a virtual host other 
	 * than the one to which you're connected.
	 *
	 * @param result
	 * @throw fcadmin.context.PermissionError
	 */
	function restart(result:CommandResult):Void
	{
		checkPermission(adaptorName+"/"+name);

		var resultProxy:ResultProxy=new ResultProxy(result,"success","failed");
		callService("restartVHost",resultProxy,adaptorName+"/"+name);
	}



	/**
	 * Stops a running virtual host. After the virtual host stops, 
	 * all applications are unloaded and all users are disconnected.
	 * The virtual host does not accept any requests until it has 
	 * been restarted by means of the start command or until the 
	 * server is restarted.
	 * Unfortunately, this method never invoke successful, if you call this method
	 * a info object with code value of NetConnection.Call.Failed will return.
	 *
	 * @param result
	 *
	 * TODO find out why. 
	 * 
	 */
	function stop(result:CommandResult):Void
	{
		checkPermission(adaptorName+"/"+name);

		var resultProxy:ResultProxy=new ResultProxy(result,"success","failed");
		callService("stopVHost",resultProxy,adaptorName+"/"+name);
	}


	/**
	 * Starts a stopped virtual host or enables a new virtual host.
	 * This command lets you enable a new virtual host at runtime
	 * without restarting the server. The new virtual host 
	 * directory and configuration files must already be present 
	 * in the server's conf directory; the start command 
	 * does not create or copy any directories or configuration 
	 * files.
	 * You must be a server administrator to use the startVHost 
	 * command.
	 *
	 * @param result
	 * @throw fcadmin.context.PermissionError
	 */
	function start(result:CommandResult):Void
	{
		checkPermission(adaptorName+"/"+name);
		var resultProxy:ResultProxy=new ResultProxy(result,"success","failed");
		callService("startVHost",resultProxy,adaptorName+"/"+name);
	}


	/**
	 * Adds an vhost administrator to the system. 
	 * You must be a server administrator to perform this operation.
	 *
	 * @param username String that contains the user name of the administrator being added.
	 * @param password Password of that administrator. The password is encoded before it 
	 *			is written to the Server.xml configuration file.
	 * @param result
	 * @throw fcadmin.context.PermissionError
	 */
	function addAdmin(username:String,password:String,result:CommandResult):Void
	{
		checkPermission("server");
		var resultProxy:ResultProxy=new ResultProxy(result,"success","failed");
		callService("addAdmin",resultProxy,username,password,adaptorName+"/"+name);
	}

	/**
	 * Get all admin context of this vhost.
	 * You must be a server administrator or administrator for this vhost to perform this
	 * operation.
	 *
	 * @param result
	 * @throw fcadmin.context.PermissionError
	 */
	function getAdmins(result:AdminsResult):Void
	{
		checkPermission(adaptorName+"/"+name);
		var resultProxy:ResultProxy=new ResultProxy(result,"getAdminsSuccess","getAdminsFailed");
		resultProxy["owner"]=this;
		resultProxy["scope"]=adaptorName+"/"+name;
		resultProxy.handleResult=function(info)
		{			
			var admins:Array=new Array();

			var raw:XML=new XML(info.data);
			var rootNode:XMLNode=raw.firstChild;
			var length:Number=rootNode.childNodes.length;
			for(var i:Number=0;i<length;i++)
			{
				var adminName:String=rootNode.childNodes[i].attributes.name;
				if(adminName!=undefined&&adminName!="")
				{
					admins.push(new Admin(adminName,this.scope,this.owner.hostConnection));
				}
			}
			if(admins.length>0)
			{
				this.facadeResult(admins);
			}
			else
			{
				this.facadeResult(null);
			}
		}
		callService("getConfig",resultProxy,"Admin/Adaptor:"+adaptorName+"/VirtualHost:"+name+"/UserList","/");
	}


	private function checkOwnerVHost():Void
	{
		var vhostName:String=hostConnection.vhost.name;
		if(vhostName!=name)
		{
			throw new UnsupportedOperationError(vhostName);
		}
	}


	function getPath():String
	{
		return getHostString() + "/" + adaptorName + "/" + name;
	}


	function toString():String
	{
		return "[VHost] adaptorName = " + adaptorName + ", name = " + name;
	}


}

