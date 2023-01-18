/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2005-1-12
 ******************************************************************************/

import fcadmin.AdminConnection
import fcadmin.context.AbstractContext;
import fcadmin.context.ActiveInstanceStatsResult;
import fcadmin.context.ScriptStatsResult;
import fcadmin.context.UsersResult;
import fcadmin.context.User;
import fcadmin.context.SharedObjectsResult;
import fcadmin.context.SharedObjectContext;
import fcadmin.context.StreamContext;
import fcadmin.context.StreamsResult;
import fcadmin.context.CommandResult;
import fcadmin.context.InstanceLogEntriesResult;
import fcadmin.data.InstanceLogEntry;
import fcadmin.data.ActiveInstanceStats;
import fcadmin.data.ScriptStats;
import fcadmin.data.UserStats;
import fcadmin.data.StatusObject;
import fcadmin.utils.ResultProxy;

import mx.utils.Delegate;




/**
 * The server record a new log entry.
 *
 * @event-object
 */
[Event("onLog")]


/**
 * The server record a new catchall log entry.
 *
 * @event-object
 */
[Event("onCatchallLog")]



/**
 * ActiveInstance wraps some of Server Management ActionScript API to provide a high 
 * level abstraction for the application active instance management.
 */
class fcadmin.context.ActiveInstance extends AbstractContext
{
	
	private var __name:String;
	private var __adaptorName:String;
	private var __vhostName:String;
	private var __appName:String;

	private var liveNs:NetStream;
	private var liveNsCA:NetStream;
	private var entriesNs:NetStream;
	
	
	
	/**
	 * Return the adaptor name of this app instance.
	 * @readable true
	 * @writable false
	 */
	function get adaptorName():String
	{
		return __adaptorName;
	}
	

	/**
	 * Return the name of this app instance.
	 * @readable true
	 * @writable false
	 */
	function get name():String
	{
		return __name;
	}
	

	/**
	 * Return the vhost name of this app instance.
	 * @readable true
	 * @writable false
	 */
	function get vhostName():String
	{
		return __vhostName;
	}


	/**
	 * Return the app name of this app instance.
	 * @readable true
	 * @writable false
	 */
	function get appName():String
	{
		return __appName;
	}



	/**
	 * Constructor, usually you can get the active instance context
	 * from App.getActiveInstances.
	 *
	 * @param adaptorName host adaptor name of this app instance.
	 * @param vhostName host vhost name of this app instance.
	 * @param appName host vhost name of this app instance.
	 * @param name name of this app instance.
	 * @param adminConnection the host AdminConnection instance for this app instance context.
	 * @see fcadmin.context.App#getActiveInstance
	 */
	function ActiveInstance(adaptorName:String,vhostName:String,appName:String,name:String,adminConnection:AdminConnection)
	{
		super(adminConnection);

		__name=name;
		__adaptorName=adaptorName;
		__vhostName=vhostName;
		__appName=appName;



		liveNs=new NetStream(hostConnection);
		liveNs["onLog"]=Delegate.create(this,handleLiveLog);
		liveNs.play("logs/application/"+appName+"/"+name,-1);

		liveNsCA=new NetStream(hostConnection);
		liveNsCA["onLog"]=Delegate.create(this,handleCatchallLiveLog);
		liveNsCA.play("logs/application/?",-1);

		entriesNs =new NetStream(hostConnection);

	}

	/**
	 * Gets the performance data for a specified instance of an application.
	 * If you only need information about the performance of a specific script,
	 * use the getScriptStats method.
	 *
	 * @param result
	 * @see #getScriptStats
	 */
	function getStats(result:ActiveInstanceStatsResult):Void
	{
		var resultProxy:ResultProxy=new ResultProxy(result,"getStatsSuccess","getStatsFailed");
		resultProxy.handleResult=function(info:Object)
		{
			this.facadeResult(ActiveInstanceStats.fromRawData(info.data));
		}
		callService("getInstanceStats",resultProxy,appName+"/"+name);
	}

	/**
	 * Gets the performance data for a script running on the specified 
	 * instance of an application.
	 *
	 * @param result
	 */
	function getScriptStats(result:ScriptStatsResult):Void
	{
		var resultProxy:ResultProxy=new ResultProxy(result,"getScriptStatsSuccess","getScriptStatsFailed");
		resultProxy.handleResult=function(info:Object)
		{
			this.facadeResult(ScriptStats.fromRawData(info.data));
		}
		callService("getScriptStats",resultProxy,appName+"/"+name);
	}

	/**
	 * Gets an array of all users who are connected to the specified 
	 * instance of an application.
	 *
	 * @param result
	 */
	function getUsers(result:UsersResult)
	{
		var resultProxy:ResultProxy=new ResultProxy(result,"getUsersSuccess","getUsersFailed");
		resultProxy["owner"]=this;
		resultProxy.handleResult=function(info:Object)
		{
			var users:Array=new Array();

			for(var i:Number=0;i<info.data.length;i++)
			{
				users.push(new User(this.owner.adaptorName,this.owner.vhostName,this.owner.appName,this.owner.name,info.data[i],this.owner.hostConnection));
			}
			if(users.length>0)
			{
				this.facadeResult(users);
			}
			else
			{
				this.facadeResult(null);
			}
		}
		callService("getUsers",resultProxy,appName+"/"+name);
	}


	/**
	 * Gets the shared objects that are currently active.
	 *
	 * @param result
	 */
	function getSharedObjects(result:SharedObjectsResult)
	{
		var resultProxy:ResultProxy=new ResultProxy(result,"getSharedObjectsSuccess","getSharedObjectsFailed");
		resultProxy["owner"]=this;
		resultProxy.handleResult=function(info:Object)
		{
			var socs:Array=new Array();
			var persistent:Array=info.data.persistent;
			var volatile:Array=info.data.volatile;

			for(var i:Number=0;i<persistent.length;i++)
			{
				socs.push(new SharedObjectContext(this.owner.adaptorName,this.owner.vhostName,this.owner.appName,this.owner.name,persistent[i],true,this.owner.hostConnection));
			}
			for(var j:Number=0;j<volatile.length;j++)
			{
				socs.push(new SharedObjectContext(this.owner.adaptorName,this.owner.vhostName,this.owner.appName,this.owner.name,volatile[j],false,this.owner.hostConnection));
			}
			if(socs.length>0)
			{
				this.facadeResult(socs);
			}
			else
			{
				this.facadeResult(null);
			}
		}
		callService("getSharedObjects",resultProxy,appName+"/"+name);
	}

	/**
	 * Gets the streams objects that are currently active/idle.
	 *
	 * @param result
	 */
	function getStreams(result:StreamsResult):Void
	{
		var resultProxy:ResultProxy=new ResultProxy(result,"getStreamsSuccess","getStreamsFailed");
		resultProxy["owner"]=this;
		resultProxy.handleResult=function(info:Object)
		{
			var streams:Array=new Array();

			for(var i:Number=0;i<info.data.length;i++)
			{
				if(info.data[i]>0)
				{
					streams.push(new StreamContext(this.owner.adaptorName,this.owner.vhostName,this.owner.appName,this.owner.name,String(info.data[i]),this.owner.hostConnection));
				}
			}
			if(streams.length>0)
			{
				this.facadeResult(streams);
			}
			else
			{
				this.facadeResult(null);
			}
		}
		callService("getNetStreams",resultProxy,appName+"/"+name);
	}


	/**
	 * Gets all the log entries from the application flv stream file.
	 *
	 * @param result
	 */
	function getLogEntries(result:InstanceLogEntriesResult):Void
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
			var ile:InstanceLogEntry=InstanceLogEntry.fromRawData(info);
			this.infoCache.push(ile);
			this.result.getLogEntriesProgress(ile);
		}

		entriesNs.play("logs/application/"+appName+"/"+name, 0, -1, 3);
	}


	/**
	 * Shuts down the specified application or instance of the application,
	 * if running, and reloads it. All users are disconnected.
	 * After this command runs, users must reconnect to the application or 
	 * instance of the application.
	 * You can use this command to preload an instance of an application or 
	 * reload it when application configuration changes are made or the 
	 * script that is associated with the application has been changed.
	 *
	 * @param result
	 */
	function reload(result:CommandResult):Void
	{
		var resultProxy:ResultProxy=new ResultProxy(result,"success","failed");
		callService("reloadApp",resultProxy,appName+"/"+name);
	}


	/**
	 * Removes instance of an application from the virtual host. 
	 * The specified instance is unloaded and removed, and all streams
	 * and shared objects for that instance are deleted.
	 *
	 * @param result
	 */
	function remove(result:CommandResult):Void
	{
		var resultProxy:ResultProxy=new ResultProxy(result,"success","failed");
		callService("removeApp",resultProxy,appName+"/"+name);
	}

	/**
	 * Shuts down the instance of an application, and all the users who are 
	 * connected to that instance are immediately disconnected.
	 *
	 * @param result
	 */
	function unload(result:CommandResult):Void
	{
		var resultProxy:ResultProxy=new ResultProxy(result,"success","failed");
		callService("unloadApp",resultProxy,appName+"/"+name);
	}



	private function handleLiveLog(info:Object):Void
	{
		dispatchEvent({type:"onLog",info:InstanceLogEntry.fromRawData(info)});
	}


	private function handleCatchallLiveLog(info:Object):Void
	{
		trace("handleCatchallLiveLog:\r"+fcadmin.utils.ObjectUtil.getProperties(info,true).join("\r"));
		dispatchEvent({type:"onCatchallLog",info:InstanceLogEntry.fromRawData(info)});
	}


	function getPath():String
	{
		return getHostString() + "/" + adaptorName + "/" + vhostName + "/" + appName + "/" + name;
	}

	function toString():String
	{
		return "[ActiveInstance] adaptorName = " + adaptorName + ", vhostName = " + vhostName + ", appName = " + appName + ", name = " + name;
	}

}
