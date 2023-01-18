/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

// TODO add logs and errors.

import asgard.events.RemotingEvent;
import asgard.net.remoting.RemotingAuthentification;
import asgard.net.remoting.RemotingConnection;
import asgard.net.remoting.RemotingConnectionCollector;
import asgard.net.remoting.RemotingFormat;
import asgard.net.remoting.RemotingServiceResponder;
import asgard.net.TimeoutPolicy;

import pegas.process.AbstractAction;

import vegas.events.Delegate;
import vegas.events.EventListener;
import vegas.events.TimerEvent;
import vegas.util.Timer;

/**
 * This class provides a service object to communicate with a remoting gateway server.
 * @author eKameleon
 */
dynamic class asgard.net.remoting.RemotingService extends AbstractAction 
{
	
	/**
	 * Creates a new RemotingService instance.
	 * @param gatewayUrl The url of the gateway of the remoting service.
	 * @param serviceName The name of the service in the server.
	 * @param responder (optional) The RemotingServiceResponder use to receive data from the server.
	 * @param bGlobal (optional) The flag to use a global event flow or a local event flow.
	 * @param sChannel (optional) The name of the global event flow if the {@code bGlobal} argument is {@code true}.
	 */
	function RemotingService( gatewayUrl:String , serviceName:String , responder:RemotingServiceResponder , bGlobal:Boolean, sChannel:String ) 
	{
		
		super(bGlobal, sChannel);
		
		setGatewayUrl( gatewayUrl );
		setServiceName( serviceName ) ;
		setResponder( responder ) ;
		
		_eFinish   = new RemotingEvent(RemotingEvent.FINISH, this) ;
		_eProgress = new RemotingEvent(RemotingEvent.PROGRESS, this) ;
		_eStart    = new RemotingEvent(RemotingEvent.START, this) ;
		_eError    = new RemotingEvent(RemotingEvent.ERROR, this)  ;
		
		_global.System.onStatus = Delegate.create (this, _onStatus) ;
		
		_timerListener = new Delegate(this, _onTimeOut) ;
		_timer = new Timer(DEFAULT_DELAY, 1) ;
		setTimeoutPolicy(TimeoutPolicy.LIMIT) ;
		
	}
	
	/**
	 * The default delay value before notify the timeout event.
	 */
	static public var DEFAULT_DELAY:Number = 8000 ; // 8 secondes
	
	/**
	 * The string representation value of the level error of the service.
	 */
	static public var LEVEL_ERROR:String = "error" ;
	
	/**
	 * Returns a string containing a dot delimited path from the root of the Flash Remoting Server to the service name. 
	 * @return a string containing a dot delimited path from the root of the Flash Remoting Server to the service name.
	 */
	public function get gatewayUrl():String 
	{ 
		return getGatewayUrl() ;
	}
	
	/**
	 * Sets a string containing a dot delimited path from the root of the Flash Remoting Server to the service name. 
	 */
	public function set gatewayUrl(sUrl:String):Void 
	{ 
		setGatewayUrl(sUrl) ;
	}

	/**
	 * Returns the proxy policy boolean value of this RemotingService.
	 * @return the proxy policy boolean value of this RemotingService.
	 */
	public function get isProxy():Boolean 
	{ 
		return getIsProxy() ;
	}
	
	/**
	 * Sets the proxy policy boolean value of this RemotingService.
	 */
	public function set isProxy(b:Boolean):Void 
	{ 
		setIsProxy(b) ;
	}
	
	/**
	 * Returns the Array representation of all arguments to pass in the service method.
	 * @return the Array representation of all arguments to pass in the service method.
	 */
	public function get params():Array 
	{ 
		return getParams() ;
	}

	/**
	 * Sets the Array representation of all arguments to pass in the service method.
	 */
	public function set params(ar:Array):Void 
	{ 
		setParams(ar) ;
	}

	/**
	 * Returns the name of the server-side service's method.
	 * @return the name of the server-side service's method.
	 */
	public function get methodName():String 
	{ 
		return getMethodName() ;
	}

	/**
	 * Sets the name of the server-side service's method.
	 */
	public function set methodName(sName:String):Void 
	{ 
		setMethodName(sName) ;
	}
	
	/**
	 * Defines if the service can lauch multiple simultaneous connections.
	 */
	public var multipleSimultaneousAllowed:Boolean ;

	/**
	 * Returns the name of the server-side service.
	 * @return the name of the server-side service.
	 */
	public function get serviceName():String 
	{ 
		return getServiceName() ;
	}
	
	/**
	 * Sets the name of the server-side service.
	 */
	public function set serviceName(sName:String):Void 
	{ 
		setServiceName(sName) ;
	}
	
	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	public function clone() 
	{
		return new RemotingService( getGatewayUrl() , getServiceName() ) ; // TODO voir pour le responder !
	}

	/**
	 * Returns the internal connection reference of the instance.
	 * @return the internal connection reference of the instance.
	 */
	public function getConnection() 
	{
		return _rc ;	
	}

	/**
	 * Returns the timeout interval duration.
	 * @return the timeout interval duration.
	 */
	public function getDelay():Number
	{
		return _timer.delay ;
	}

	/**
	 * Returns a string containing a dot delimited path from the root of the Flash Remoting Server to the service name. 
	 * @return a string containing a dot delimited path from the root of the Flash Remoting Server to the service name.
	 */
	public function getGatewayUrl():String 
	{
		return _gatewayUrl ;	
	}

	/**
	 * Returns the proxy policy boolean value of this RemotingService.
	 * @return the proxy policy boolean value of this RemotingService.
	 */
	public function getIsProxy():Boolean 
	{
		return _isProxy ;	
	}

	/**
	 * Returns the name of the server-side service's method.
	 * @return the name of the server-side service's method.
	 */
	public function getMethodName():String 
	{
		return _methodName ;
	}

	/**
	 * Returns the Array representation of all arguments to pass in the service method.
	 * @return the Array representation of all arguments to pass in the service method.
	 */
	public function getParams():Array 
	{
		return _args  ;	
	}
	
	/**
	 * Returns the RemotingServiceResponder reference of the instance.
	 * @return the RemotingServiceResponder reference of the instance.
	 */
	public function getResponder():RemotingServiceResponder 
	{
		return _responder ;
	}
	
	/**
	 * Returns the result value returns by the server after a trigger process.
	 * @return the result value returns by the server.
	 */
	public function getResult() 
	{
		return _result ;	
	}

	/**
	 * Returns the name of the server-side service.
	 * @return the name of the server-side service.
	 */
	public function getServiceName():String 
	{
		return _serviceName ;
	}
	
	/**
	 * Notify a RemotingEvent 'error event'.
	 */
	public function notifyError( code:String ):Void 
	{
		_timer.stop() ;
		_setRunning(false) ;
		_eError.code = code || RemotingEvent.ERROR ;
		dispatchEvent( _eError ) ;
		notifyFinished() ;
	}	

	/**
	 * Notify a RemotingEvent 'fault event'.
	 */
	public function onFault( e:RemotingEvent ) : Void 
	{
		_timer.stop() ;
		_setRunning(false) ;
		e.setTarget(this) ;
		dispatchEvent( e ) ;
		notifyFinished() ;
	}
	
	/**
	 * Notify a RemotingEvent 'result event'.
	 */
	public function onResult( e:RemotingEvent ):Void 
	{
		_timer.stop() ;
		_setRunning(false) ;
		e.setTarget(this) ;
		_result = e.getResult() ;
		dispatchEvent( e ) ;
		notifyFinished() ;
	}

	/**
	 * Run the process of the remoting service.
	 */
	public function run():Void 
	{
		
		_rc = RemotingConnection.getConnection( _gatewayUrl ) ;
		
		if (_rc == null ) 
		{
			// ici notifier qu'il est impossible de lancer la connection.	
		}
		
		if (_authentification != null)
		{
			_rc.setCredentials(_authentification) ;
		}
		
		if ( getRunning() && multipleSimultaneousAllowed == false)  
		{
			notifyProgress() ;
		}
		else 
		{
			notifyStarted() ;
			_result = null ;
			_setRunning(true) ;
			_timer.start() ;
			var arg:Array = [_serviceName + "." + _methodName , getResponder()].concat(_args) ;
			_rc.call.apply( _rc, arg );
			
		} 
	}

	/**
	 * Defines a set of credentials to be presented to the server on all subsequent requests.
	 * @param authentification The RemotingAuthentification instance to presented to the server.
	 * @see RemotingAuthentification
	 */
	public function setCredentials( authentification:RemotingAuthentification ):Void  
	{
		_authentification = authentification ;
	}

	/**
	 * Set timeout interval duration.
	 * @param time the delay value of the timeout event notification.
	 * @param useSeconds Indicates if the time value is in seconds {@code true} or milliseconds {@code false}.
	 */
	public function setDelay( time:Number , useSeconds:Boolean ):Void 
	{
		if (useSeconds) 
		{
			time = Math.round(time * 1000) ;
		}
		_timer.delay = time ;
	}

	/**
	 * Sets a string containing a dot delimited path from the root of the Flash Remoting Server to the service name. 
	 */
	public function setGatewayUrl( url:String ):Void 
	{
		if (_gatewayUrl) RemotingConnectionCollector.remove(_gatewayUrl) ;
		if (url) {
			_gatewayUrl = url ;
			_rc = RemotingConnection.getConnection( _gatewayUrl ) ;
		} else {
			_rc = null ;	
		}
	}
	
	/**
	 * Sets the proxy policy of this RemotingService. 
	 * If the passed-in argument is {@code true} the RemotingService instances uses proxy to resolve all methods.
	 */
	public function setIsProxy(b:Boolean):Void 
	{
		_isProxy = b ;
		__resolve = b ? __resolve__ : null ;	
	}

	/**
	 * Sets the Array representation of all arguments to pass in the service method.
	 */
	public function setParams(args:Array):Void 
	{
		_args = args ;	
	}

	/**
	 * Sets the name of the server-side service's method.
	 */
	public function setMethodName( sName:String ):Void 
	{
		_methodName = sName ;	
	}

	/**
	 * Sets the RemotingServiceResponder reference of the instance.
	 */
	public function setResponder( responder:RemotingServiceResponder ):Void 
	{
		if (_responder) 
		{
			_responder.setService(null) ;
		}
		_responder = responder || new RemotingServiceResponder(this, onResult, onFault) ;
		_responder.setService(this) ;
	}
	
	/**
	 * Sets the name of the server-side service.
	 */
	public function setServiceName( sName:String ):Void 
	{
		_serviceName = sName ;	
	}

	/**
	 * Use limit timeout interval.
	 * @see TimeoutPolicy
	 */
	public function setTimeoutPolicy( policy:TimeoutPolicy ):Void 
	{
		_policy = policy ;
		
		if (_policy == TimeoutPolicy.LIMIT) 
		{
			_timer.addEventListener( TimerEvent.TIMER, _timerListener) ;
		}
		else 
		{
			_timer.removeEventListener(TimerEvent.TIMER, _timerListener) ;
		}
	}

	/**
	 * Triggers the process to launch the method of the current service server side.
	 */
	public function trigger():Void 
	{
		run() ;	
	}
	
	/**
	 * Returns the {@code String} representation of this object.
	 * @return the {@code String} representation of this object.
	 */
	public function toString():String 
	{
		return (new RemotingFormat()).formatToString(this) ;	
	}

	private var _args:Array ;
	
	private var _authentification:RemotingAuthentification ;
	
	private var _eError:RemotingEvent ;
	
	private var _eFinish:RemotingEvent ;
	
	private var _eProgress:RemotingEvent ;
	
	private var _eStart:RemotingEvent ;
	
	private var _gatewayUrl:String = null  ;
	
	private var _isProxy:Boolean = false ;
	
	private var _methodName:String ; 

	private var _policy:TimeoutPolicy ;

	private var _rc:RemotingConnection = null ;
	
	private var __resolve = null ;
	
	private var _result = null ;
	
	private var _serviceName:String = null ;
	
	private var _responder:RemotingServiceResponder = null ;

	private var _timer:Timer ;
	
	private var _timerListener:EventListener ;

	/**
	 * Resolve an unknow method over the RemotingService instance.
	 */
	private function __resolve__( methodName:String ):Function 
	{
		
		if (_rc == null ) 
		{
			getLogger().warn( this + " resolve failed with no connection." ) ;	
			return null ;
		}
		
		if(methodName == "__path__") 
		{
			return null ; // hack pour le toString avec ConstructorUtil.getName !!
		}
		
		var responder:RemotingServiceResponder = getResponder() ;
		responder.setMethodName(methodName) ;

		var rc:RemotingConnection = _rc ;
		var serviceName:String = _serviceName ;

		return function () 
		{
			var args:Array = [ serviceName + "." + methodName , responder ].concat(arguments) ;
			return rc.call.apply( rc, args ); 
		} ;
		
		
	}
	
	private function _onStatus ( ev:Object ):Void 
	{
		_timer.stop() ; // stop timeout interval
		if (ev.level == RemotingService.LEVEL_ERROR) 
		{
			notifyError(ev.code) ;
		}
	}

	private function _onTimeOut(e:TimerEvent):Void 
	{
		_timer.stop() ;
		_rc.close() ;
		_setRunning(false) ;
		notifyTimeOut() ;
		notifyFinished() ;
	}

}