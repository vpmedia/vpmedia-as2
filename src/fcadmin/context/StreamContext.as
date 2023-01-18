/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-10
 ******************************************************************************/

import fcadmin.AdminConnection;
import fcadmin.context.AbstractContext
import fcadmin.context.StreamStatsResult;
import fcadmin.data.StreamStats;
import fcadmin.utils.ResultProxy;

/**
 * StreamContext wraps some of Server Management ActionScript API to provide a high 
 * level abstraction for the stream management.
 */
class fcadmin.context.StreamContext extends AbstractContext
{

	private var __name:String;
	private var __adaptorName:String;
	private var __vhostName:String;
	private var __appName:String;
	private var __instanceName:String;


	/**
	 * Return the adaptor name of this stream.
	 * @readable true
	 * @writable false
	 */
	function get adaptorName():String
	{
		return __adaptorName;
	}
	

	/**
	 * Return the name of this stream.
	 * @readable true
	 * @writable false
	 */
	function get name():String
	{
		return __name;
	}
	

	/**
	 * Return the vhost name of this stream.
	 * @readable true
	 * @writable false
	 */
	function get vhostName():String
	{
		return __vhostName;
	}


	/**
	 * Return the app name of this stream.
	 * @readable true
	 * @writable false
	 */
	function get appName():String
	{
		return __appName;
	}

	/**
	 * Return the instance name of this stream.
	 * @readable true
	 * @writable false
	 */
	function get instanceName():String
	{
		return __instanceName;
	}
	


	/**
	 * Constructor, usually you can get the stream context
	 * from ActiveInstance.getStreams.
	 *
	 * @param adaptorName host adaptor name of this stream.
	 * @param vhostName host vhost name of this stream.
	 * @param appName host vhost name of this stream.
	 * @param instanceName instance name of this stream.
	 * @param name name of this stream.
	 * @param adminConnection the host AdminConnection instance for this stream context.
	 * @see fcadmin.context.ActiveInstance#getStreams
	 */
	function StreamContext(adaptorName:String,vhostName:String,appName:String,instanceName:String,name:String,adminConnection:AdminConnection)
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
	function getStats(result:StreamStatsResult):Void
	{
		var resultProxy:ResultProxy=new ResultProxy(result,"getStatsSuccess","getStatsFailed");
		resultProxy["owner"]=this;
		resultProxy.handleResult=function(info)
		{
			var rawStats:Object=info.data[0];
			if(rawStats.name!="")
			{
				var facadeProxy:Object=new Object();
				facadeProxy.rawStats=rawStats;
				facadeProxy.proxy=this;
				facadeProxy.onResult=function(info)
				{
					if(info.code=="NetConnection.Call.Success")
					{
						// fill live stream information
						this.rawStats.publisher=info.data.publisher;
						this.rawStats.subscribers=info.data.subscribers;
						this.proxy.facadeResult(StreamStats.fromRawData(this.rawStats));
					}
					else
					{
						this.onStatus(info);
					}
				}
				facadeProxy.onStatus=function(info)
				{
					this.proxy.onStatus(info);
				}
				
				this.owner.hostConnection.call("getLiveStreamStats",facadeProxy,this.owner.appName+"/"+this.owner.instanceName,rawStats.name);
			}
			else
			{
				this.facadeResult(StreamStats.fromRawData(rawStats));
			}
		}
		callService("getNetStreamStats",resultProxy,appName+"/"+instanceName,Number(name));
	}


	function getPath():String
	{
		return getHostString() + "/" + adaptorName + "/" + vhostName + "/" + appName + "/" + instanceName + "/streams/" + name;
	}


	function toString():String
	{
		return "[StreamContext] adaptorName = " + adaptorName + ", vhostName = " + vhostName + ", appName = " + appName + ", instanceName = " + instanceName + ", name = " + name;
	}
}

