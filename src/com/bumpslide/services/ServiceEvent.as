import com.bumpslide.services.Service;
/**
 * Service event class
 * 
 * <p>onServiceComplete, onServiceError, onServiceCancelled
 * 
 * @author David Knape 
 * 
 * Copyright © 2006 David Knape (http://bumpslide.com)
 * Released under the open-source MIT license. 
 * http://www.opensource.org/licenses/mit-license.php
 * See LICENSE.txt for full license terms.
 */
 
class com.bumpslide.services.ServiceEvent
{
	// copies of static vars frmo service class
	static var EVENT_COMPLETE = 'onServiceComplete';
	static var EVENT_ERROR = 'onServiceError';
	static var EVENT_CANCELLED = 'onServiceCancelled';
	static var EVENT_BUSY = 'onServiceBusy';
	static var EVENT_CLEAR = 'onServiceClear';
	
	var type:String;
	var target:Service;
	var requestId:String;
	var result;
	var message:String;
	
	function ServiceEvent(t:String, trgt:Service, rid:String, rslt, msg:String )
	{			
		type = t;
		target = trgt;
		requestId = rid;
		if(rslt!=null) result = rslt;
		if(msg!=null) message = msg;
	}
}
