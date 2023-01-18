import com.bumpslide.util.Debug;

dynamic class com.bumpslide.example.services.TestRemotingService extends com.bumpslide.services.RemotingService
{
	private var serviceName = "TestService";
	private var availableMethods = ["sayHello", "getObject"];
	static public var multipleRequestsAllowed = false; 
}
