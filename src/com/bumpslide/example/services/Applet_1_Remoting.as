
/**
 *  Remoting Service Test
 * 
 *  Open this file in FlashDevelop and hit the "Quick MTASC Build" button.
 *   
 *  Copyright (c) 2006, David Knape
 *  Released under the open-source MIT license. 
 *  See LICENSE.txt for full license terms.
 * 
 *  Compiles in FlashDevelop. No FLA necessary.  
 *  @mtasc -swf com/bumpslide/example/services/Applet_1_Remoting.swf -header 500:400:31:eeeedd -main 
 *  @author David Knape
 */


import com.bumpslide.example.services.*;
import com.bumpslide.services.*;
import com.bumpslide.util.*;

class com.bumpslide.example.services.Applet_1_Remoting extends com.bumpslide.core.MtascApplet
{	
	var svc:TestRemotingService;
	
	private function Applet_1_Remoting() {	
		
		super();
		
		sourceUrl = "Applet_1_Remoting.as";
		
		// simulate flashvars
		_root.gatewayUrl = "http://bumpslide.sourceforge.net/amfphp/gateway.php";		
			
		// instantiate service
		svc = new TestRemotingService();
		
		// listen for service events
		svc.addEventListener( ServiceEvent.EVENT_COMPLETE, Delegate.create( this, serviceComplete ) );
		svc.addEventListener( ServiceEvent.EVENT_ERROR, Delegate.create( this, serviceError) );
		
		// call method 'sayHello'
		svc.sayHello( "David" );
		svc.getObject();
	}
	
	function serviceComplete( e:ServiceEvent ) {
		message( "Complete: "+e.result);
		Debug.trace( e.result );
	}
	
	function serviceError( e:ServiceEvent ) {
		message( "Error: "+e.message);
	}
	
	// All applets must contain a custom version of this method
	// Just change 'SimpleApplet' to whatever your class name is
	static function main(root_mc:MovieClip) : Void {			
		ClassUtil.applyClassToObj( Applet_1_Remoting, root_mc );		
	}
	
}


/*
-------------------------------
AMFPHP Test Service....
------------------------------- 
<?php 

// save as TestService.php in your amfphp/services directory
// update gateway URL in PHP accordingly
class TestService {

	function TestService() {		
		$this->methodTable = array(
			'sayHello'=>array('arguments'=>array('name'), 'access'=>'remote')
		);
	}

	function sayHello( $name ) { 
		return "Hello, ".$name; 
	} 
}

?>
------------------------------- 
*/