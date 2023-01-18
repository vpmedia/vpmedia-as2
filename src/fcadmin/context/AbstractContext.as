/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2004-12-30
 ******************************************************************************/

import mx.events.EventDispatcher;

import logging.Logger;

import fcadmin.AdminConnection;
import fcadmin.context.IAdminContext;
import fcadmin.context.PermissionError;
import fcadmin.context.UnsupportedOperationError




/**
 * AbstractContext provide the ability to query or execute command
 * via the Server Management ActionScript API.
 */
class fcadmin.context.AbstractContext implements IAdminContext
{

	private static var logger:Logger = Logger.getLogger("fcadmin.context.AbstractContext");




	private var __hostConnection:AdminConnection;



	
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
	 * Return the host connection for this service.
	 */
	function get hostConnection():AdminConnection
	{
		return getHostConnection();
	}

	/**
	 * Return the host connection for this service.
	 */
	function getHostConnection():AdminConnection
	{
		return __hostConnection;
	}



	
	private function AbstractContext(adminConnection:AdminConnection)
	{
		__hostConnection=adminConnection;
	}

	

	/**
	 * Invoke a service mathod on the server side.
	 *
	 * @useage <code>Service</code>.callService(<code><em>serviceMethodName</em>,<em>resultObject</em> | null[<em>, p1,...,pN</em>]</code>);
	 *
	 * @param serviceMethodName The method to execute.
	 * @param resultObject A parameter defined according to the status message. 
	 *			See the individual method for more information.
	 * @param p1,...pN Optional parameters to be passed to the specified method. 
	 *			See the individual method for more information.
	 */
	function callService():Void
	{
		logger.fine(this+" CallService: "+arguments);
		hostConnection.call.apply(hostConnection,arguments);
	}



	function getPath():String
	{
		return null;
	}


	/**
	 * Utility function for permission checking.
	 *
	 * @param scope server or vhost scpoe
	 */
	private function checkPermission(scope:String):Void
	{
		var cscope:String=hostConnection.admin.scope;
		if(cscope!="server")
		{
			if(cscope!=scope)
			{
				throw new PermissionError(cscope);
			}
		}
	}


	private function checkFCSConnected():Void
	{
		if(!hostConnection.fcsConnected)
		{
			throw new UnsupportedOperationError("FCS Not Connected.");
		}
	}


	private function getHostString():String
	{
		//TODO check uri vaildation.

		var path:String=hostConnection.uri;

		var sp:Number=path.indexOf("//");
		var ep:Number=path.indexOf(":",sp);

		return path.substring(sp+2,ep);
	}


	


	private static function classConstruct():Boolean
	{
		if(!bConstructed)
		{
			bConstructed=true;			
			EventDispatcher.initialize(AbstractContext.prototype);
		}
		return bConstructed;
	}


	private static var EventDispatcherDependency:EventDispatcher=mx.events.EventDispatcher;
	private static var bConstructed:Boolean=classConstruct();

}
 