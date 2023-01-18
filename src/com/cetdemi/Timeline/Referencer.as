import com.cetdemi.Timeline.*;

/** * An abstract class that returns a reference to the root timeline * Or to the timeline controller
 * @author Patrick Mineault
 * @version 1.0 Sat Jan 15 01:01:26 2005
 */
 class com.cetdemi.Timeline.Referencer 
 {
	 /**
	 * Returns a reference to the root
	 */
	static function getRoot():MovieClip
	{
		return _root;
	}
	/**
	* Returns a reference to the Timeline controller instance
	*/
	static function getController():TimelineController
	{
		return _root.ctrl;
	}
}