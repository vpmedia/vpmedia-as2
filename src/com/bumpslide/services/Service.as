import com.bumpslide.util.*;
import com.bumpslide.services.ServiceEvent;
import com.bumpslide.events.Dispatcher;

/**
 * Service Interface defined as an abstract class 
 * 
 * <p>To be used as a base class for specific service types
 * 
 * @author David Knape 
 * 
 * Copyright © 2006 David Knape (http://bumpslide.com)
 * Released under the open-source MIT license. 
 * http://www.opensource.org/licenses/mit-license.php
 * See LICENSE.txt for full license terms.
 */
 
dynamic class com.bumpslide.services.Service extends Dispatcher {

	// config vars
	//--------------------------
	
	// false means we will overwrite existing instances of service in the queue 
	// (even if the params are different)
	static public var multipleRequestsAllowed = false; 
	
	// Events...
	//---------------------------	
	static var EVENT_COMPLETE = 'onServiceComplete';
	static var EVENT_ERROR = 'onServiceError';
	static var EVENT_CANCELLED = 'onServiceCancelled';
	static var EVENT_BUSY = 'onServiceBusy';	
	static var EVENT_CLEAR = 'onServiceClear';
	
	// Stores service parameters
	var args : Array;
	
	// service method name (optional, for services with more than one method)
	private var methodName : String = "";
	
	// stores result object
	private var result;
	
	// whether or not to use __resolve to handle
	// dynamically called method names (for use with remoting services)
	private var methodNameResolveEnabled = false;
 	
	// available methods in this service
	// only required is relying on __resolve to handle dynamic method calls
	private var availableMethods : Array
	
	// cancelled flag 
	// (true when service is cancelled before it finishes) 
	var cancelled = false;
			
	// set by ServiceRequest when called via ServiceProxy
	var requestId=null;
	
	var timeoutMs = 90000;
	var _timerInt = -1;
	
	var busyMs = 1000;
	var _busyInt = -1;
	
	
	function Service() {
		if(availableMethods == undefined) availableMethods = [];
		if(methodNameResolveEnabled) this['__resolve'] = doResolve;		
	}
	
	
	function getResult () {
		return result;
	}
	
	/**
	* validate and run (optionally pass in method name and arguments) 
	* 
	* overloaded:
	*  
	*   load( methodName:String, args:Array);
	* OR 
	*   load( args:Array );  // calls default method
	* 
	* 
	*/
	function load() {
		
		if( arguments[0] instanceof Array) {			
			// optional args
			args = ArrayUtil.dCopy( arguments[0] );	
		} else {			
			// optional method name
			methodName = arguments[0];			
			// optional args
			if( arguments[1] instanceof Array) {
				args = ArrayUtil.dCopy( arguments[1] );
			}
		}
		
		if(requestId==null) {
			requestId = getTimer();
		}		
		
		// validate 
		if(isValid()) {
			
			clearInterval( _timerInt );
			_timerInt = setInterval( this, 'onServiceTimedOut', timeoutMs );
			
			run();
			return true;
		} else {
			notifyError('Invalid Arguments in '+this );
			return false;	
		}
	}
	
	/** 
	 * Resolve method calls directly - you asked for it :)
	 */
	public function doResolve(nMethodName:String):Function {	
		// Immediately kill mixin of death
		// (respectfully borrowed from Patrick Mineault's cingetdemi.remoting.RemotingService class)
		if(nMethodName.indexOf('Handler') != -1 || nMethodName.indexOf('__q_') != -1 ) {
			return null;
		}		
		if(ArrayUtil.in_array(nMethodName, availableMethods )) {			
			this[nMethodName] = Delegate.create( this, doLoad, nMethodName );
			return this[nMethodName];
		} else {
			//Debug.warn('[Service] __resolve "'+nMethodName+'" (method not in availableMethods list)' );
			return null;
		}		
	}
	
	/**
	* Called via delegate when resolving method names
	*/
	private function doLoad() {
		
		// get args
		var nArgs = arguments.concat();
		
		// note that nARgs now has 2 extra elements
		// the last one is the delegate reference that was added by Delegate.create
		// so, we remove that here.
		nArgs.pop();
		
		// the last element is our method name, so we pop that off 
		var nMethodName = nArgs.pop(); 
		
		Debug.trace('Loading '+nMethodName+ ' with args '+nArgs);
		load( nMethodName, nArgs );
		
		busy();
	}
	
	
	/**
	* run service
	*/
	function run() {
		
		// this is where we trigger an asynchronous call to a remote service
		// when service is complete, handleresult should save the service result
		// to this.result. we then call notify complete
		notifyError('Run method must be defined in service implementation.');
		clearTimer();
		
		//handleResult(null);
		//notifyComplete();		
	}
	
	
	function busy() {
		//Debug.warn('[Service] Busy '+getTimer());
		clearInterval( _busyInt );
		_busyInt = setInterval( this, 'notifyBusy', busyMs );
	}
	
	
	function clearTimer() {
		clearInterval( _timerInt );
		clearBusy();
	}
	
	function clearBusy() {
		//Debug.warn('[Service] Clear '+getTimer());
		clearInterval( _busyInt );
		notifyClear();
	}
	
	
	
	// subclass can handle result here before service proxy is notified
	// this is a good place to update your model
	function handleResult( inResult ) { 	
		if(methodName==undefined) return false;
		var methodResultHandler = this['handleResult_'+methodName];
		if(methodResultHandler!=undefined && typeof(methodResultHandler)=='function') {
			return methodResultHandler.call( this, inResult );
		} else {
			return false;
		}		
	}
	
	/**
	 * cancel service
	 */
	function cancel() {
		clearTimer();
		cancelled = true;
		notifyCancelled();  
	}
	
	/**
	 * checks whether or not arguments are valid
	 */
	function isValid() {
		return true;
	}
	
	/**
	* Shortcut to add listener for all events
	* @param	responder
	*/
	function addListener(responder:Object) {		
		addEventListener(ServiceEvent.EVENT_COMPLETE, responder);
		addEventListener(ServiceEvent.EVENT_ERROR, responder);
		addEventListener(ServiceEvent.EVENT_CANCELLED, responder);
		addEventListener(ServiceEvent.EVENT_BUSY, responder);
		addEventListener(ServiceEvent.EVENT_CLEAR, responder);
	}
	
	/**
	* Shortcut to remove listener for all events
	* @param	responder
	*/
	function removeListener(responder:Object) {
		removeEventListener(ServiceEvent.EVENT_COMPLETE, responder);
		removeEventListener(ServiceEvent.EVENT_ERROR, responder);
		removeEventListener(ServiceEvent.EVENT_CANCELLED, responder);
		removeEventListener(ServiceEvent.EVENT_BUSY, responder);
		removeEventListener(ServiceEvent.EVENT_CLEAR, responder);
	}
	

	/**
	 *  dispatches 'onServiceComplete' event 
	 */
	private function notifyComplete() {
		clearTimer();
		if(cancelled) {
			Debug.warn(this+'service complete, but cancelled');
			//notifyCancelled();
		} else {
			dispatchEvent( new ServiceEvent( ServiceEvent.EVENT_COMPLETE, this, requestId, getResult()) );			
		}
	}	
	
	
	/**
	 *  dispatches 'onServiceBusy' event 
	 */
	function notifyBusy(msg:String) {
		clearInterval( _busyInt );
		dispatchEvent( new ServiceEvent( ServiceEvent.EVENT_BUSY, this, requestId, null, msg) );		
	}
	
	/**
	 *  dispatches 'onServiceClear' event 
	 */
	function notifyClear(msg:String) {
		//Debug.warn('Notify CLEAR');
		clearInterval( _busyInt );
		dispatchEvent( new ServiceEvent( ServiceEvent.EVENT_CLEAR, this, requestId, null, msg) );		
	}
	
	/**
	 *  dispatches 'onServiceError' event 
	 */
	private function notifyError(msg:String) {
		dispatchEvent( new ServiceEvent( ServiceEvent.EVENT_ERROR, this, requestId, null, msg) );		
	}
	
	/**
	 *  dispatches 'onServiceCancelled' event 
	 */
	private function notifyCancelled() {
		dispatchEvent(new ServiceEvent( ServiceEvent.EVENT_CANCELLED, this, requestId) );
			
	}
	
	private function onServiceTimedOut() {
		dispatchEvent( new ServiceEvent( ServiceEvent.EVENT_ERROR, this, requestId, null, "Service call timed out") );
	}
	
	private function toString() {
		return '[Service:'+methodName+']';
	}
	
	private var mDebug : Boolean = false;
	function debug ( o ) : Void {
		if ( !mDebug ) return;
		if ( typeof(o)=='string' ) {
			var msg : String = this+' ';
			( o.substr(0,1)=='!' ) ? Debug.error( msg+o.substr(1) ) : Debug.debugg( msg+o );
		} else {
			Debug.debug( o );
		}
	}
	
}