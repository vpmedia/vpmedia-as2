/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        12/12/2004
 ******************************************************************************/

import logging.Logger;
import fcadmin.utils.ObjectUtil;


class fcadmin.test.TestProvider
{
	static var logger:Logger = Logger.getLogger("fcadmin.test.TestProvider");
	
	
	private static var clientCache:Array=new Array();
	private static var clientNum:Number=5;
	private static var serverPath:String="rtmp://localhost:1935/test_fcadmin";

	private static var isSetup:Boolean;
	
	static function setup():Boolean
	{
		if(!isSetup)
		{
			newClientTest();			
			isSetup=true;
		}
		return isSetup;
	}


	private static function newClientTest():Void
	{
		if(clientNum>clientCache.length)
		{
			logger.info("Start new client test "+clientCache.length+".");
			var nc:NetConnection=new NetConnection();
			nc.logger=logger;
			nc.streamToken=randomStringToken();
			nc.soToken=randomStringToken();
			nc.onStatus=function(info:Object)
			{
				TestProvider["logger"].info(this.uri+" onStatus:"+newline+ObjectUtil.getProperties(info,true).join(newline));
				if(info.code=="NetConnection.Connect.Success")
				{
					TestProvider["logger"].info("Create new NetStream: "+this.streamToken);

					var stream:NetStream=this.testStream=new NetStream(this);
					random(2)?stream.play(this.streamToken):stream.publish(this.streamToken);

					TestProvider["logger"].info("Create new SharedObject: "+this.soToken);

					var so:SharedObject=this.testSO=SharedObject.getRemote(this.soToken,this.uri,Boolean(random(2)));
					so.connect(this);

					TestProvider["newClientTest"]();
				}
			}
			nc.connect(serverPath);
			clientCache.push(nc);
		}
	}

	private static function randomStringToken():String
	{
		return new Date().getTime().toString();
	}


}