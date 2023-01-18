
import com.bumpslide.services.Service;
import com.bumpslide.util.ClassUtil;

/**
 * Represents a pending service requests
 * 
 * <p>Instances of this class are what gets enqueued by the ServiceProxy
 * There is no need to instantiate this class directlty.  Note that
 * serviceProxy method calls should return an instance of this class.
 * 
 * @author David Knape 
 * 
 * Copyright © 2006 David Knape (http://bumpslide.com)
 * Released under the open-source MIT license. 
 * http://www.opensource.org/licenses/mit-license.php
 * See LICENSE.txt for full license terms.
*/

class com.bumpslide.services.ServiceRequest
{
	
	private var _uid:String;
	private var args:Array;
	private var _methodName:String;
	private var serviceClassRef:Function;
	
	private var service:Service;
	private var responder:Object;

	/**
	* returns service request ID
	* @return serviceRequestId string
	*/
	public function get uid () : String {
		return _uid
	}
	
	/**
	* returns service method name
	* @return methodName string
	*/
	public function get methodName () : String {
		return _methodName;
	}
	
	function get multipleRequestsAllowed() : Boolean{
		return serviceClassRef['multipleRequestsAllowed']===true;
	}

	/**
	* return 
	*/
	public function get serviceClass () : String {
		return ClassUtil.getFullyQualifiedClassName( serviceClassRef );
	}
	
	/**
	* Service Request CTOR
	* 
	* This is usually created by the ServiceProxy class.  
	* No need to instantiate directly.
	* 
	* @param	inMethodName
	* @param	inClassRef
	* @param	inArgs
	*/
	function ServiceRequest(inMethodName:String, inClassRef:Function, inArgs:Array) {
		_methodName = inMethodName;
		serviceClassRef = inClassRef
		args = inArgs;
		
		// create unique ID for this service request
		// should be the same if parameters are the same
		_uid = _methodName;
		for(var n in args) {			
			var s = String(args[n]);
			if(s!='') _uid+= "|"+s;
		}
	}

	
	/**
	* Execute the service request
	* 
	* called service.load and passes in request ID and arguments 
	* 
	* @param	eventResponder object
	*/
	function execute( eventResponder:Object ) : Void {	
		
		// save reference to responder
		responder = eventResponder;
		
		// create service
		service = ClassUtil.createInstance( serviceClassRef );
		service.requestId = uid;
		service.addListener( responder );
		service.load(_methodName, args);		
	}
		
	/**
	* destroy this service request
	* 
	* removes responder as listener to service
	*/
	function destroy() {
		service.removeListener( responder );
	}
		
	/**
	* Cancel this service request
	*/
	function cancel() : Void {
		service.cancel();
	}
	
	function toString() {
		return '[ServiceRequest:'+_uid+']';
	}
	
	
}
