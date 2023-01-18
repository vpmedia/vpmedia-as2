
/**
 *  Service Proxy Example
 * 
 *  Open this file in FlashDevelop and hit the "Quick MTASC Build" button.
 *   
 *  Copyright (c) 2006, David Knape
 *  Released under the open-source MIT license. 
 *  See LICENSE.txt for full license terms.
 * 
 *  Compiles in FlashDevelop. No FLA necessary.  
 *  @mtasc -swf com/bumpslide/example/services/Applet_3_ServiceProxy.swf -header 500:400:31:eeeedd -main 
 *  @author David Knape
 */


import com.bumpslide.example.services.*;
import com.bumpslide.services.ServiceEvent;
import com.bumpslide.util.*;

class com.bumpslide.example.services.Applet_3_ServiceProxy extends com.bumpslide.core.MtascApplet
{	
	var service : MyServiceProxy;
	
	private function init() {		
				
		sourceUrl = "Applet_3_ServiceProxy.as";
		
		message('Applet Loaded');
		message('Click mouse to cancel all pending service requests');
		
		// simulate flashvars
		_root.gatewayUrl = "http://bumpslide.sourceforge.net/amfphp/gateway.php";		
		
		service = MyServiceProxy.getInstance();
		service.debug = true;
		service.addEventListener( MyServiceProxy.EVENT_SAY_HELLO_COMPLETE, Delegate.create( this, sayHello_result ) );
		service.addEventListener( MyServiceProxy.EVENT_TEST_XML_COMPLETE, Delegate.create( this, testXml_result ) );
		
		// these service calls will be enqueued (run one at a time)
		service.sayHello( 'David' );	// added to queue and run, as queue will be empty
		service.loadTestXml();			// added to queue, will run when current request is done
		service.sayHello( 'Jenny' );	// will replace current request (david)
		service.loadTestXml();			// will replace pending testXml request
		service.sayHello('Bob');		// will replace pending sayHello request (jenny)
				
		// if we allow multiple requests for the Remoting service, all requests will go through
		TestRemotingService.multipleRequestsAllowed = false;
		service.sayHello('Becky'); 		// this request will be enqueued
		service.sayHello('Alex');		// this request will be enqueued
		service.sayHello('Alex');		// this request is redundant and will be ignored
		
		/*
		Results...
		XML Loaded:20 items 
		sayHello_result: Hello, Bob
		sayHello_result: Hello, Becky
		sayHello_result: Hello, Alex
		*/
		
		
	}
	
	function onMouseDown() {
		service.reset();
		message('All services stopped');
	}

	
	function sayHello_result( e:ServiceEvent ) {
		message( "sayHello_result: " + e.result);
	}
	
	function testXml_result( e:ServiceEvent ) {
		message( "XML Loaded:" + e.result.length + " items ");
	}
	
	
	// All applets must contain a custom version of this method
	// Just change 'SimpleApplet' to whatever your class name is
	static function main(root_mc:MovieClip) : Void {			
		ClassUtil.applyClassToObj( Applet_3_ServiceProxy, root_mc );		
	}
	
}
