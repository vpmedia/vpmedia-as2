import com.bumpslide.util.Debug;
import com.bumpslide.services.*;
import com.bumpslide.util.*;
import com.bumpslide.events.*;

/**
 * Single point of access for all services in an application
 * 
 * <p>This class is meant to be extended once for each application.
 * Services can be added automagically using the addServiceMethod function, 
 * but it is better to create actual stub methods in you service proxy implementation
 * so that you can make use of proper code-hinting while developing the 
 * client code in view classes.
 * 
 * <p>The service proxy enqueues all service requests and performs some 
 * smart checking to determine whether or not a service really needs to be called.
 * Stale service calls (calls to services already in the queue, but with different params)
 * can be automatically removed to avoid unnecessary server calls.
 * 
 * <p>Example Usage:
 * {@code
 *  	var service = ServiceProxy.getInstance();
 *   
 * 		// services normally added in subclass iniServices method...
 * 		service.addServiceMethod( 'loadMyData', MyDataService );
 * 
 *   	// in client we then listen nad load
 *   	service.addEventListener('onServiceResult_loadMyData', this);
 *   	dataLoader.loadMyData(2027477); 
 * 
 *   	function onServiceResult_loadMyData( myData ) {
 *			traceObj( myData );
 *		}
 *	}
 * 
 * @author David Knape 
 * 
 * Copyright © 2006 David Knape (http://bumpslide.com)
 * Released under the open-source MIT license. 
 * http://www.opensource.org/licenses/mit-license.php
 * See LICENSE.txt for full license terms.
 */

dynamic class com.bumpslide.services.ServiceProxy extends  Dispatcher {

	// current service request
	private var currentRequest : ServiceRequest;
	
	// array of enqueued service requests
	private var requestQueue : Array;

	// singleton instance
	private static var instance;	
	
	public var debug:Boolean = false;
	/**
	* static method, used to make 1 instance (singleton)
	* 
	* this must be replicated in the subclass implementation
	*/
	public static function getInstance() {
		if (instance == null) instance = new ServiceProxy();
		return instance;
	}
	
	/**
	* ServiceProxy Constructor - private 
	* 
	* @see ServiceProxy#getInstance 
	*/
	private function ServiceProxy() {
		super();
		requestQueue = new Array();		
		initServices();		
	}
	
	/**
	* Returns service request currently being processed
	* @return
	*/
	public function getCurrentRequest() : ServiceRequest {
		return currentRequest;
	}
	
	public function reset() {
		Debug.info( '[ServiceLoader] RESET');
		requestQueue = new Array();
		currentRequest.cancel();
		currentRequest = null;
	}
	
	/**
	 * Subclasses should init services here
	 * 
	 * This is where ServiceProxy subclass implementations should
	 * call addServiceMethod for each service class 
	 * 
	 * @deprecated Not necessary if creating service methods by hand
	 */
	public function initServices() {
		
	}
		
	/**
	* Dynamically creates a method in the proxy instance using method name
	* 
	* The dynamically created method will run/request the service defined in the serviceClass
	* 
	* @deprecated Create these functions by hand for more control and proper code hints
	* 
	* @param	serviceClass
	* @param	methodName
	*/
	public function addServiceMethod( serviceClass:Function, methodName:String ) {	
		dTrace( 'addServiceMethod ' +methodName);
		this[methodName] = function () {
			return this.requestService( methodName, serviceClass, arguments.concat() );
		} 	
	}

	
	private function requestService( methodName:String, serviceClass:Function, args:Array) : ServiceRequest {

		dTrace( 'NEW Service Request '+ClassUtil.getClassName( serviceClass )+'.'+methodName+'('+args+')');		
				
		if(serviceClass==undefined) {
			Debug.error( '[ServiceProxy] requestService() - Undefined service requested');
			return null;
		}
		
		// create new service request
		var newRequest:ServiceRequest = new ServiceRequest( methodName, serviceClass, args );

		if(currentRequest!=null) {	
			
			// If the new request is from the same service class as the current request
			// do some checks to avoid unnecessary server calls
			if(newRequest.serviceClass == currentRequest.serviceClass) {
				
				// if requested service args match current request, don't bother loading it again
				// and return null.  That is, just drop the request.  The client code should be
				// notified when the current request is finished.
				if(currentRequest.uid == newRequest.uid) {					
					
					dTrace('New service request matches current request "'+newRequest.uid+'"');
					return null;
					
				// if the new request is calling the same method as the requested service
				// and multiple requests are not allowed, then cancel the current request
				// but allow code flow to continue, so we can enqueue this new reuest (no break here)
				} else if(currentRequest.methodName == newRequest.methodName && !newRequest.multipleRequestsAllowed) {

					dTrace('Current service request ('+currentRequest+') is being replaced by new request ('+newRequest+')');				
					currentRequest.cancel();
					
				} else {
					
					//dTrace('New Request is of the same service class as the current request. ('+newRequest.serviceClass+')');
					// nothing to do here
				}
			}
						
		}
		
		// Now, see if this same service is in the service queue
		var n = requestQueue.length;
		while(n--) {
			
			// if service call of the same type is already in queue, replace it
			if(newRequest.uid==requestQueue[n].uid && !newRequest.multipleRequestsAllowed) {							
				// service replaces previous request in queue
				dTrace('Pending service request is being replaced in the queue by new request "'+newRequest.uid+'"');
				requestQueue[n] = newRequest;
				return null;
				
			} 
		}	
	
		// Enqueue the service request
		dTrace('Enqueing Service '+newRequest.uid);
		requestQueue.push( newRequest );				
		
		if(requestQueue.length==1 && currentRequest==null) {
			loadNext();			
		}
		
		return newRequest;
		
	}
	
	private function loadNext() {		
		// destroy current request
		currentRequest.destroy();
		
		// If we're at the end of the line, set currentService to null.
		if(!requestQueue.length) {
			currentRequest = null;
			return;
		}		
		
		currentRequest = ServiceRequest(requestQueue.shift());
		
		dTrace("Loading next service "+currentRequest.uid);
		
		// execute request and listen for results
		currentRequest.execute(this);
	}
		
	
	
	// Service event handlers	
	//----------------------------------
	
	private function onServiceComplete( event:ServiceEvent ) {
		
		if(currentRequest.uid != event.requestId) {
			Debug.error('[ServiceProxy]  onServiceComplete() - event.requestId does not match current request id: '+currentRequest.uid);
			return false;
		}
		
		// now we dispatch the event to our own listeners
		// we just change the name (type) and remove the target which is the service instance
		// (No need for that service to hang around, as we are about to destroy it)
		event.type = 'onServiceComplete_'+currentRequest.methodName;
		event.target = null;		
			
		// call local result handler if found
		var localResultHandler = this['handleResult_'+currentRequest.methodName];
		
		if(localResultHandler!=undefined && typeof(localResultHandler)=='function') {
			dTrace('calling local result handler handleResult_'+currentRequest.methodName);
			this['handleResult_'+currentRequest.methodName].call( this, event.result );
		}	
		
		dTrace('onServiceComplete "'+currentRequest.methodName+'"');
		//Debug.info( event );
				
		dispatchEvent( event  );
		
		// continue...
		loadNext();				
	}
	
	private function onServiceCancelled(event:ServiceEvent) {
		
		if(currentRequest.uid != event.requestId) {
			Debug.error('[ServiceProxy]  onServiceCancelled() - event.requestId does not match current request id: '+currentRequest.uid);
			return false;
		}
		
		dTrace('onServiceCancelled '+event.requestId);
		dispatchEvent(event);
		
		// continue...
		loadNext();		
	}
	
	private function onServiceError(event:ServiceEvent) {
		Debug.error( '[ServiceProxy]  onServiceError() - '+event.message);
		
		// just forward the event
		dispatchEvent(event);
		
		// continue...
		loadNext();		
	}	
	
	private function onServiceClear( event:ServiceEvent ) {
		//Debug.warn('[ServiceProxy] onServiceClear');
		dispatchEvent(event);
	}
	private function onServiceBusy( event:ServiceEvent ) {
		//Debug.warn('[ServiceProxy] onServiceBusy');
		dispatchEvent(event);
	}
	
	private function handleEvent( event:ServiceEvent ) {
		if((typeof this[event.type] ) != 'function' ) {
			Debug.error('[ServiceProxy] unhandledEvent "'+event.type+'"');
		}
	}
	

	// internal debugging
	private function dTrace(s) {
		if(debug) Debug.debug( '[ServiceProxy]  '+s);
	}
	
}
