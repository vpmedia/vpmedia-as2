
import com.bumpslide.services.ServiceProxy;
import com.bumpslide.example.services.*;
import com.bumpslide.util.Debug;

class com.bumpslide.example.services.MyServiceProxy extends ServiceProxy {
	
	
	// our events names must follow the naming convention "onServiceComplete_{methodName}"
	// by creating these here, we make it easier to write the client code 
	static var EVENT_SAY_HELLO_COMPLETE : String = "onServiceComplete_sayHello";
	static var EVENT_TEST_XML_COMPLETE : String = "onServiceComplete_testXml";
	
	// proxy command 'sayHello'
	function sayHello ( name ) {
		return requestService( 'sayHello', TestRemotingService, arguments );
	}
	
	// proxy command 'loadTestXml'
	function loadTestXml() {
		return requestService( 'testXml', TestXmlService, arguments );
	}
	
	
	/**
	* static method, used to make 1 instance (singleton)
	* 
	* this must be replicated in the subclass implementation
	*/
	public static function getInstance() {
		if (instance == null) instance = new MyServiceProxy();
		return instance;
	}
	private static var instance;
	
	
}
