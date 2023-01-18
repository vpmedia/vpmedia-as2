/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2005-1-20
 ******************************************************************************/

import mx.events.EventDispatcher;

import logging.Logger;


import fcadmin.context.Adaptor;
import fcadmin.context.VHost;
import fcadmin.context.Server;
import fcadmin.context.Admin;
import fcadmin.utils.ObjectUtil;


/**
 * The connection attempt succeeded. You can get the admin,adaptor,vhost
 * and the server context from this connection then.
 *
 * @event-object
 */
[Event("connectSuccess")]

/**
 * The connection was successfully closed.
 *
 * @event-object
 */
[Event("connectClosed")]


/**
 * The connection attempt failed; for example, the server is not running.
 *
 * @event-object
 */
[Event("connectFailed")]

/**
 * The AdminConnection.call method was not able to invoke the server-side method or command.
 * This information object also has a description property, which is a string that provides 
 * a more specific reason for the failure.
 *
 * @event-object
 */

[Event("connectRejected")]

/**
 * The NetConnection.call method was not able to invoke the server-side method or command.
 * This information object also has a description property, which is a string that provides 
 * a more specific reason for the failure.
 *
 * @event-object
 */
[Event("callFailed")]





[Event("fcsConnectSuccess")]

[Event("fcsConnectFailed")]

[Event("fcsConnectClosed")]





/**
 * AdminConnection represent a connection between the Flash client
 * and the Flashcomm admin server.
 * After the connect sucess, you can get the admin,adaptor,vhost
 * and the server context from this connection.
 */
class fcadmin.AdminConnection extends NetConnection
{

	private static var logger:Logger = Logger.getLogger("fcadmin.AdminConnection");

	private var __admin:Admin;
	private var __adaptor:Adaptor;
	private var __vhost:VHost;
	private var __fcsConnected:Boolean;
	private var __server:Server;

	private var __uri:String;
	private var __adminName:String;
	private var __pswd:String;

	private var __testNC:NetConnection;



	/**
	 * @exclude
	 * @mix-in
	 */
	var addEventListener:Function;
	/**
	 * @exclude
	 * @mix-in
	 */
	var removeEventListener:Function
	/**
	 * @exclude
	 * @mix-in
	 */
	var dispatchEvent:Function;



	/**
	 * The admin context for the host connection.
	 */
	function get admin():Admin
	{
		return __admin;
	}
 
 
	/**
	 * Name of the adaptor for the host connection.
	 */
	function get adaptor():Adaptor
	{
		return __adaptor;
	}
 
	/**
	 * Name of the virtual host for the host connection.
	 */
	function get vhost():VHost
	{
		return __vhost;
	}
 
	/**
	 * True if the administrator is connected, through the administration
	 * server, to Flash Communication Server; false if the administrator 
	 * is connected only to the administration server and not Flash 
	 * Communication Server. It is possible for an administrator to be 
	 * logged on to the administration server on port 1111 but not have 
	 * an active connection to Flash Communication Server, which 
	 * communicates on port 1935.
	 */
	function get fcsConnected():Boolean
	{
		return __fcsConnected;
	}

	/**
	 * return the server context for this connection.
	 */
	function get server():Server
	{
		return __server;
	}


	/**
	 * The uri this connection will connect to the admin server.
	 */
	function get uri():String
	{
		return __uri;
	}

	/**
	 * The admin name this connection will connect to the admin server.
	 */
	function get connectName():String
	{
		return __adminName;
	}

	/**
	 * The connect password this connection will connect to the admin server.
	 */
	function get connectPswd():String
	{
		return __pswd;
	}



	/**
	 * Construct a new instance of AdminConnection
	 *
	 * @param uri the uri this connection will connect
	 * @param adminName the admin user name
	 * @param pswd the admin password
	 */
	function AdminConnection(uri:String,adminName:String,pswd:String)
	{
		super();
		__uri=uri;
		__adminName=adminName;
		__pswd=pswd;
	}



	/**
	 * Establish the connection. 
	 *
	 * @param targetURI This parameter is ignored.
	 */
	function connect(targetURI:String):Boolean
	{
		//if(!isConnected)
		{
			logger.fine("start connect to "+uri);
			return super.connect(uri,__adminName,__pswd);
		}
		//return false;
	}


	/**
	 * @exclude
	 */
	function onStatus(info:Object):Void
	{		
		var dispatchType:String=handleStatus(info);
		if(dispatchType!=null)
		{
			dispatchEvent({type:dispatchType,info:info});
		}
	}


	function testFCSConnected(result:Object):Void
	{
		__testNC=new NetConnection();
		__testNC["result"]=result;
		__testNC["logger"]=logger;
		__testNC.onStatus=function(info:Object)
		{
			if(info.code=="NetConnection.Connect.Success")
			{
				this.result.onResult(info.level=="status");
			}
			else
			{
				this.result.onResult(false);
			}
			this.result=null;
			this.close();
		}
		__testNC.connect(uri,__adminName,__pswd);
	}


	private function handleStatus(info:Object):String
	{
		logger.fine("onStatus:"+newline+ObjectUtil.getProperties(info,true).join(newline));

		var returnType:String;

		switch(info.code)
		{
			case "NetConnection.Connect.Success":
			{
				var result:Object=new Object();
				result.owner=this;
				result.logger=logger;
				result.onResult=function(info)
				{
					this.logger.fine("getAdminContext success");
					this.owner.handleAdminInfo(info.data);
				}
				result.onStatus=function(err)
				{
					this.logger.warning("getAdminContext failed." + newline + ObjectUtil.getProperties(err,true).join(newline));
				}
				this.call("getAdminContext",result);

				returnType=null;
				break;
			}
			case "NetConnection.Connect.Closed":
			{
				__admin=null;
				__adaptor=null;
				__vhost=null;
				__fcsConnected=false;
				__server=null;

				__available=false;

				returnType="connectClosed";
				break;
			}
			case "NetConnection.Call.Failed":
			{
				returnType="callFailed";
				break;
			}
			case "NetConnection.Connect.Failed":
			{
				returnType="connectFailed";
				break;
			}
			case "NetConnection.Connect.Rejected":
			{
				returnType="connectRejected";
				break;
			}
			case "Admin.Server.Disconnect":
			{
				__fcsConnected=false;
				returnType="fcsConnectClosed";
				break;
			}
			case "Admin.Server.Reconnect.Success":
			{
				//TODO::check this!
				__fcsConnected=true;
				returnType="fcsConnectSuccess";
				break;
			}
			default:
			{
				returnType=info.code;
			}
		}

		return returnType;
	}

	private function handleAdminInfo(rawData:Object):Void
	{
		logger.info(ObjectUtil.getProperties(rawData,true).join(newline));
		
		var scope:String=rawData.admin_type;
		if(scope!="server")
		{
			scope=rawData.adaptor+"/"+rawData.vhost;
		}
		
		__admin=new Admin(__adminName,scope,this);
		__adaptor=new Adaptor(rawData.adaptor,this);
		__vhost=new VHost(rawData.adaptor,rawData.vhost,this);
		__server=new Server(this);
		__fcsConnected=rawData.connected.toLowerCase()=="true";


		// In the future, we would add a additional connection 
		// to the fcs proxy server to fix fcsConnected bug in
		// 1.5 updater 2, and communicate with the it to 
		// provide more feature. 
		// But currently the connection is establish!
		
		dispatchEvent({type:"connectSuccess"});


		if(__fcsConnected)
		{
			dispatchEvent({type:"fcsConnectSuccess"});
		}
		else
		{
			dispatchEvent({type:"fcsConnectFailed"});
		}
	}










	private static function classConstruct():Boolean
	{
		if(!bConstructed)
		{
			bConstructed=true;
			EventDispatcher.initialize(AdminConnection.prototype);
		}
		return bConstructed;
	}


	private static var EventDispatcherDependency:EventDispatcher=mx.events.EventDispatcher;
	private static var bConstructed:Boolean=classConstruct();

}
