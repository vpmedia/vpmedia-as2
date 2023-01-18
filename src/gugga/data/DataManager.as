/**
 * @author Todor Kolev
 */

import mx.data.components.WebServiceConnector;
import mx.events.EventDispatcher;
import mx.utils.Delegate;

import gugga.collections.HashTable;
import gugga.common.EventDescriptor;
import gugga.common.IEventDispatcher;
import gugga.data.SOAPCallData;
import gugga.logging.Logger;
import gugga.logging.publishers.SOSPublisher;
import gugga.utils.DelayedCallTimeout;
import gugga.utils.Listener;
import gugga.utils.ObjectCloner;
import gugga.utils.DebugUtils;
 
class gugga.data.DataManager extends EventDispatcher implements IEventDispatcher
{
	private var mMethodConnectors : HashTable;
	private var mMethodCallQueues : HashTable;
	private var mMethodsExecuting : HashTable;
	
	private var mWSDLURL : String;
	public function get WSDLURL() : String { return mWSDLURL; }
	public function set WSDLURL(aValue:String) : Void 
	{ 
		mWSDLURL = aValue;
		
		for(var key:String in mMethodConnectors)
		{
			var connector:WebServiceConnector = WebServiceConnector(mMethodConnectors[key]);
			connector.WSDLURL = mWSDLURL;
		} 
	}
	
	public function DataManager()
	{
		mMethodConnectors = new HashTable();
		mMethodCallQueues = new HashTable();
		mMethodsExecuting = new HashTable();
	}
		
	public function callMethod(aMethodName:String, aArguments:Object, aResultDelegate:Function, aAdditionalDelegateData:Object)
	{
		if(!mMethodConnectors[aMethodName])
		{
			registerMethod(aMethodName);
		}
			
		var callData : SOAPCallData = new SOAPCallData();
		
		callData.MethodName = aMethodName;
		callData.Arguments = aArguments;
		callData.ResultDelegate = aResultDelegate;
		callData.AdditionalDelegateData = aAdditionalDelegateData;
		
		var callQueue : Array = mMethodCallQueues[aMethodName];
		callQueue.push(callData);
		
		if(!mMethodsExecuting[aMethodName])
		{
			triggerNextPendingCall(aMethodName);
		}
	}
	
	private function registerMethod(aMethodName:String, aOnResultDelegate:Function) : WebServiceConnector
	{
		var connector : WebServiceConnector = new WebServiceConnector();
		connector.WSDLURL = mWSDLURL;
		connector.operation = aMethodName;
		
		Listener.createMergingListener(new EventDescriptor(IEventDispatcher(connector), "result"), 
			Delegate.create(this, onConnectorResult), {methodName: aMethodName});
			
		Listener.createMergingListener(new EventDescriptor(IEventDispatcher(connector), "status"), 
			Delegate.create(this, onConnectorStatus), {methodName: aMethodName});
		
		mMethodConnectors[aMethodName] = connector;
		mMethodCallQueues[aMethodName] = new Array();
		
		return connector;
	}	
	
	private function triggerNextPendingCall(aMethodName:String)
	{
		var callQueue : Array = mMethodCallQueues[aMethodName];
		
		if(callQueue[0])
		{
			var currentCall : SOAPCallData = SOAPCallData(callQueue[0]); //get next call, but do not remove from queue
			var methodName : String = currentCall.MethodName;
			var connector : WebServiceConnector = WebServiceConnector(mMethodConnectors[methodName]);
			
			mMethodsExecuting[methodName] = true;
		
			connector.params = currentCall.Arguments;
			connector.trigger();
		}
	}
	
	private function onConnectorStatus(ev)
	{
		
		if(ev.code != "StatusChange")
		{
			
			var methodName : String = ev.methodName;
			
			var logMessage : String = SOSPublisher.getFoldedMessagePackage(
				"WebServiceConnector for '" + methodName + "' failed: " + ev.code, 
				"fault code: " + ev.data.faultcode + "\n" + 
				"fault string: " + ev.data.faultstring
			);
			
			Logger.logWarning(logMessage, this);
		}	
	}
	
	private function onConnectorResult(ev)
	{
		
		var callQueue : Array = mMethodCallQueues[ev.methodName];
		var currentCall : SOAPCallData = SOAPCallData(callQueue.shift()); //get current call and it remove from the queue
		
		var methodName : String = currentCall.MethodName;
		var resultDelegate : Function = currentCall.ResultDelegate;
		var connector : WebServiceConnector = WebServiceConnector(mMethodConnectors[methodName]);
		
		resultDelegate(connector.results, currentCall.AdditionalDelegateData);
		
		/**
		 * Delayed call in order to let web service connector
		 * to "bump current call" (see: mx.data.components.WebServiceConnector)
		 */
		var delayedCallTimeout : DelayedCallTimeout = 
			new DelayedCallTimeout(10, this, this.triggerNextPendingCallDelayed, methodName);
	}

	private function triggerNextPendingCallDelayed(aMethodName : String) : Void
	{
		mMethodsExecuting[aMethodName] = false;
		triggerNextPendingCall(aMethodName);
	}
	
	public static function getSealedObjectArrayFromResult(aResultObject:Object, aType:Function):Array
	{
		var objectArray : Array = new Array();
		
		for (var i : Number = 0; i < aResultObject.length; i++)
		{
			var obj : Object = getSealedObjectFromResult(aResultObject[i], aType);
			objectArray.push(obj);
		}
		
		return objectArray;		
	}
	
	public static function getSealedObjectFromResult(aResultObject:Object, aType : Function):Object
	{
		var obj : Object = new aType();
		
		ObjectCloner.copyProperties(obj, aResultObject);
		
		return obj;
	}
}