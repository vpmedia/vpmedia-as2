import com.bumpslide.example.history.demo2.BaseClip;
import com.bumpslide.util.ClassUtil;

/**
* This class is mapped to the root of our demo movie
*  
* Because this class extends BaseClip, we will ensure that the 
* singleton ModelLocator is initialized before the other view 
* clips try to bind to it.
* 
* We can also use this class as a place to put all the crap 
* we used to shove in the first frame of a FLA file. 
* 
* @author David Knape
* 
*/
class com.bumpslide.example.history.demo2.HistoryDemoApp extends BaseClip {	
	
	static function main( timeline:MovieClip ) : Void 
	{
		ClassUtil.applyClassToObj( HistoryDemoApp, timeline );
	}	
	
	private function HistoryDemoApp()
	{
		stop();	
		
		trace('[HistoryDemoApp] constructed');
		
		// this is a good time to load config files and things of that sort
		// once that is done, we can go ahead and start the app 
		
		gotoAndStop('start');
	}
}
