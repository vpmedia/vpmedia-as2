import com.blitzagency.xray.util.XrayLoader;
import com.blitzagency.xray.logger.LogManager;
import com.blitzagency.xray.logger.XrayLog;

class com.blitzagency.Main_loadConnector
{
	static var app : Main_loadConnector;
	
	// if you use just the XrayLogger:
	static var logger:Object;
	// if you use the mtasc trace switch:
	static var log:XrayLog;

	function Main_loadConnector() 
	{
		// after Xray loads, it will call run
		XrayLoader.addEventListener(XrayLoader.LOADCOMPLETE, this, "run");
		XrayLoader.loadConnector("xrayConnector_1.6.swf");
	}

	// entry point
	public static function main(mc) 
	{
		app = new Main_loadConnector();
	}
	
	private function run(evtObj:Object):Void
	{
		// define bogus object
		var obj:Object = {};
		obj["John"] = {};
		obj["John"].phone = "ring";

		
		/*
		* WITHOUT USING MTASC's trace switch (XrayLogger only)
		* 	Comment out this block to use XrayLogger without MTASC's trace
		*/

		LogManager.setLevel(0);  // debug=0, info=1, warn=2, error=3, fatal=4
		logger = LogManager.getLogger("com.blitzagency.xray.logger.XrayLogger");
		logger.debug("testing Logger", obj);
		//logger.info("testing Logger", obj);
		//logger.warn("testing Logger", obj);
		//logger.error("testing Logger", obj);
		//logger.fatal("testing Logger", obj);
		
		
		/*
		* USING MTASC's trace switch with MtascUtility.as
		* 	Comment out this block to use XrayLogger with MTASC's trace
		*   
		*   your trace switch should look like this in mtasc's batch/command:
		* 
		*  		-trace com.blitzagency.xray.util.MtascUtility.trace
		* 
		* 	Your output will look like so:
		* 
		* (273) com.blitzagency.Main::run : line 42
			what's my obj?!
			John: [Object]
				phone: ring
		*/
		
		/*
		log = new XrayLog();
		trace(log.debug("what's my obj?!", obj));
		//trace(log.info("what's my obj?!", obj));
		//trace(log.warn("what's my obj?!", obj));
		//trace(log.error("what's my obj?!", obj));
		//trace(log.fatal("what's my obj?!", obj));
		*/
	}
}