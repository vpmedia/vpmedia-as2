/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2005-1-12
 ******************************************************************************/

import mx.utils.Delegate;

import fcadmin.AdminConnection;
import fcadmin.context.AbstractContext;

import fcadmin.context.App;
import fcadmin.context.Adaptor;
import fcadmin.context.AppsResult;
import fcadmin.context.AdaptorsResult;
import fcadmin.context.LicenseInfoResult;
import fcadmin.context.PermissionError;
import fcadmin.context.ServerStatsResult;
import fcadmin.context.MessageCacheResult;
import fcadmin.context.PingResult;
import fcadmin.context.CommandResult;
import fcadmin.context.IOStatsResult;
import fcadmin.context.AccessLogEntriesResult;
import fcadmin.context.AdminsResult;
import fcadmin.context.Admin;
import fcadmin.data.StatusObject;
import fcadmin.data.AccessLogEntry;
import fcadmin.data.LicenseSummary;
import fcadmin.data.ServerStats;
import fcadmin.data.MessageCache; 

import fcadmin.utils.ResultProxy;


/**
 * The server record a new access log entry.
 *
 * @event-object
 */
[Event("onAccessLog")]


/**
 * The server record a new system log entry.
 *
 * @event-object
 */
[Event("onSystemLog")]



/**
 * Server wraps some of Server Management ActionScript API to provide a high 
 * level abstraction for the server management.
 */
class fcadmin.context.Server extends AbstractContext
{
	
	private var liveNsAcc:NetStream;
	private var liveNsSys:NetStream;
	private var entriesNs:NetStream;




	/**
	 * Constructor, usually you can get the specified server context
	 * instance from AdminConnection.serverContext after it connected
	 * successfully.
	 *
	 * @param adminConnection the host AdminConnection instance for this 
	 *				server context.
	 * @see fcadmin.AdminConnection.server
	 */
	function Server(adminConnection:AdminConnection)
	{
		super(adminConnection);

		liveNsAcc=new NetStream(hostConnection);
		liveNsAcc["onLog"]=Delegate.create(this,handleAccessLog);
		liveNsAcc.play("logs/access",-1);

		liveNsSys=new NetStream(hostConnection);
		liveNsSys["onLog"]=Delegate.create(this,handleSystemLog);
		liveNsSys.play("logs/system",-1);

		entriesNs =new NetStream(hostConnection);
	}

	


	/**
	 * Returns an array of adaptors that are defined. 
	 * You must be a server administrator to perform 
	 * this command.
	 *
	 * @param result
	 * @throw fcadmin.context.PermissionError
	 */
	function getAdaptors(result:AdaptorsResult):Void
	{
		checkPermission("server");
		var resultProxy:ResultProxy=new ResultProxy(result,"getAdaptorsSuccess","getAdaptorsFailed");
		resultProxy["owner"]=this;
		resultProxy.handleResult=function(info)
		{			
			var adps:Array=new Array();
			for(var i:Number=0;i<info.data.length;i++)
			{
				adps.push(new Adaptor(info.data[i],this.owner.hostConnection));
			}
			if(adps.length>0)
			{
				this.facadeResult(adps);
			}
			else
			{
				this.facadeResult(null);
			}
		}
		callService("getAdaptors",resultProxy);
	}


	/**
	 * Retrieves complete license information. 
	 * You must be a server administrator to perform 
	 * this command.
	 *
	 * @param result
	 */
	function getLicenseInfo(result:LicenseInfoResult):Void
	{
		checkPermission("server");
		var resultProxy:ResultProxy=new ResultProxy(result,"getLicenseInfoSuccess","getLicenseInfoFailed");
		resultProxy.handleResult=function(info)
		{
			this.facadeResult(LicenseSummary.fromRawData(info.data));
		}
		callService("getLicenseInfo",resultProxy);
	}

	/**
	 * Updates the license information. You can use this memthod 
	 * create, update or delete license.
	 *
	 * @param keySet the licenses will fill to the Server.xml. 
	 *			All old licenses will be overwriten.
	 * @param result
	 * @see #getLicenseInfo
	 * @see fcadmin.data.LicenseSummary
	 */
	function updateLicenseInfo(keySet:Array,result:CommandResult):Void
	{
		checkPermission("server");
		var licenseString:String=keySet.join(";");
		if(licenseString==undefined)
		{
			licenseString="";
		}
		var resultProxy:ResultProxy=new ResultProxy(result,"success","failed");
		callService("setConfig",resultProxy,"Server/LicenseInfo",licenseString,"/");
	}


	/**
	 * Retrieves the server status and statistics about the operation of 
	 * the server, including the length of time the server has been running
	 * and I/O and message cache statistics.
	 *
	 * You must be a server administrator to perform this operation.
	 *
	 * If you only need information about the I/O characteristics of the 
	 * server, use the getIOStats method instead.
	 *
	 * @param result
	 * @see #getIOStats
	 * @throw fcadmin.context.PermissionError
	 */
	function getServerStats(result:ServerStatsResult):Void
	{
		checkPermission("server");
		var resultProxy:ResultProxy=new ResultProxy(result,"getServerStatsSuccess","getServerStatsFailed");
		resultProxy.handleResult=function(info)
		{			
			this.facadeResult(ServerStats.fromRawData(info.data));
		}
		callService("getServerStats",resultProxy);
	}

	/**
	 * Returns server TCMessage cache statistics. You must have server 
	 * administrative privileges to perform this operation.
	 *
	 * @param result
	 * @throw fcadmin.context.PermissionError
	 */
	function getMessageCache(result:MessageCacheResult):Void
	{
		checkPermission("server");
		var resultProxy:ResultProxy=new ResultProxy(result,"getMessageCacheSuccess","getMessageCacheFailed");
		resultProxy.handleResult=function(info)
		{			
			this.facadeResult(MessageCache.fromRawData(info.data));
		}
		callService("getMsgCacheStats",resultProxy);
	}

	/**
	 * Verifies that the server is running; the server responds with a status message.
	 * You can use this command to check the status of the server.
	 *
	 * @param result
	 */
	function ping(result:PingResult):Void
	{
		var resultProxy:ResultProxy=new ResultProxy(result,"pingSuccess","pingFailed");
		resultProxy.handleResult=function(info)
		{			
			this.facadeResult(info.timestamp);
		}
		callService("ping",resultProxy);
	}


	/**
	 * Forces collection and elimination of all server resources that are no longer used,
	 * such as closed streams, instances of applications, and nonpersistent shared objects.
	 * This operation is performed within about one second of the call.
	 *
	 * You must be a server administrator to perform this operation.
	 *
	 * @param result
	 * @throw fcadmin.context.PermissionError
	 */
	function gc(result:CommandResult):Void
	{
		checkPermission("server");
		var resultProxy:ResultProxy=new ResultProxy(result,"success","failed");
		callService("gc",resultProxy);
	}


	/**
	 * Starts the Flash Communication Server service.
	 * You must be a server administrator to perform this operation.
	 *
	 * @param result
	 * @throw fcadmin.context.PermissionError
	 */
	function start(result:CommandResult):Void
	{
		checkPermission("server");
		var resultProxy:ResultProxy=new ResultProxy(result,"success","failed");
		callService("startServer",resultProxy);
	}

	/**
	 * Stops it and restarts the Flash Communication Server service.
	 * You must be a server administrator to perform this operation.
	 *
	 * @param result
	 * @throw fcadmin.context.PermissionError
	 */
	function restart(result:CommandResult):Void
	{
		checkPermission("server");
		var resultProxy:ResultProxy=new ResultProxy(result,"success","failed");
		callService("startServer",resultProxy,"restart");
	}


	/**
	 * Shuts down the Flash Communication Server. If you use this command while 
	 * users are connected, you should take steps to notify users of an imminent
	 * server shutdown so that they do not lose their work.
	 * You must be a server administrator to perform this operation.
	 *
	 * @param type String; possible values are normal or abort.
	 *			If you use the value normal, the server shuts down, 
	 *			allowing running applications to end normally.
	 *			If you use the value abort, the server immediately 
	 *			shuts down and running applications will not be 
	 *			allowed to stop normally.
	 *			Use the value abort only in an emergency or if 
	 *			specifying normal does not work.
	 * @param result
	 * @throw fcadmin.context.PermissionError
	 */
	function stop(type:String,result:CommandResult):Void
	{		
		checkPermission("server");
		
		if(type!="abort")
		{
			type="normal";
		}
		
		var resultProxy:ResultProxy=new ResultProxy(result,"success","failed");
		
		callService("stopServer",resultProxy,type);
	}



	/**
	 * Adds an server administrator to the system. 
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
		callService("addAdmin",resultProxy,username,password,"server");
	}

	/**
	 * Get all the server admin context.
	 * You must be a server administrator to perform this operation.
	 *
	 * @param result
	 * @throw fcadmin.context.PermissionError
	 */
	function getAdmins(result:AdminsResult):Void
	{
		checkPermission("server");
		var resultProxy:ResultProxy=new ResultProxy(result,"getAdminsSuccess","getAdminsFailed");
		resultProxy["owner"]=this;
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
					admins.push(new Admin(adminName,"server",this.owner.hostConnection));
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
		callService("getConfig",resultProxy,"Admin/Server/UserList","/");
	}






	/**
	 * Adds a new application to the virtual host by creating the required directory 
	 * for the new application in the directory tree. Once the directory for the new 
	 * application is created, you (or another administrator with file system access) 
	 * can put any required server-side scripts in the directory. 
	 * The client-side code uses the new application directory in the URI parameter 
	 * of the NetConnection.connect call.
	 *
	 * @param appName String that contains the name of the application to be added.
	 * @param result
	 */
	function addApp(appName:String,result:CommandResult):Void
	{
		hostConnection.vhost.addApp(appName,result);
	}




	/**
	 * Returns an array of App instance of all the applications 
	 * that are installed from the connected vhost. 
	 *
	 * @param result
	 */
	function getApps(result:AppsResult):Void
	{
		hostConnection.vhost.getApps(result);
	}



	/**
	 * Returns detailed information about the network I/O characteristics of the 
	 * connected adaptor. 
	 * You must be a server administrator to perform this operation.
	 *
	 * @param result
	 * @throw fcadmin.context.PermissionError
	 */	
	function getIOStats(result:IOStatsResult):Void
	{
		hostConnection.adaptor.getIOStats(result);
	}



	/**
	 * Gets all the log entries from the server access.flv stream file.
	 *
	 * @param result
	 */
	function getLogEntries(result:AccessLogEntriesResult):Void
	{
		entriesNs["result"]=result;
		entriesNs["infoCache"]=new Array();

		entriesNs.onStatus=function(info:Object)
		{
			if(info.level=="error")
			{
				this.result.getLogEntriesFailed(StatusObject.fromRawData(info));
				this.infoCache=new Array();
				this.result=null;
			}
			else
			{
				if(info.code=="NetStream.Play.Stop")
				{
					if(this.infoCache.length==0)
					{
						this.infoCache=null;
					}					
					this.result.getLogEntriesSuccess(this.infoCache);
					this.infoCache=new Array();
					this.result=null;
				}
			}
		}

		entriesNs["onLog"]=function(info:Object)
		{
			var ile:AccessLogEntry=AccessLogEntry.fromRawData(info);
			this.infoCache.push(ile);
			this.result.getLogEntriesProgress(ile);
		}

		entriesNs.play("logs/access", 0, -1, 3);
	}

	function getPath():String
	{
		return getHostString();
	}



	
	private function handleAccessLog(info:Object):Void
	{
		dispatchEvent({type:"onAccessLog",info:AccessLogEntry.fromRawData(info)});
	}


	private function handleSystemLog(info:Object):Void
	{
		trace("handleSystemLog:\r"+fcadmin.utils.ObjectUtil.getProperties(info,true).join("\r"));
		dispatchEvent({type:"onSystemLog",info:AccessLogEntry.fromRawData(info)});
	}


	function toString():String
	{
		return "[Server] " + getPath();
	}

}
