import gugga.common.BaseEnum;
/**
 * @author Todor Kolev
 */
class gugga.tracking.TrackableAction extends BaseEnum 
{
	public static var Navigate : TrackableAction = new TrackableAction("Navigate", 0);
	
	public static var Click : TrackableAction = new TrackableAction("Click", 1);
	public static var CustomTrigger : TrackableAction = new TrackableAction("CustomTrigger", 2);
	
	public static var LoadImage : TrackableAction = new TrackableAction("LoadImage", 3);
	public static var LoadVideo : TrackableAction = new TrackableAction("LoadVideo", 4);
	public static var LoadAudio : TrackableAction = new TrackableAction("LoadAudio", 5);
	public static var LoadXML : TrackableAction = new TrackableAction("LoadXML", 6);
	public static var LoadCustomAsset : TrackableAction = new TrackableAction("LoadCustomAsset", 7);
	
	public static var PlayVideo : TrackableAction = new TrackableAction("PlayVideo", 8);	
	public static var PauseVideo : TrackableAction = new TrackableAction("PauseVideo",9);
	public static var StopVideo : TrackableAction = new TrackableAction("StopVideo", 10);
	public static var FinishedVideo : TrackableAction = new TrackableAction("StopVideo", 11);
	
	public static var PlayAudio : TrackableAction = new TrackableAction("PlayAudio", 12);	
	public static var PauseAudio : TrackableAction = new TrackableAction("PauseAudio", 13);
	public static var StopAudio : TrackableAction = new TrackableAction("StopAudio", 14);
	public static var FinishedAudio : TrackableAction = new TrackableAction("FinishedAudio", 15);
	
	function TrackableAction(aName : String, aOrderIndex : Number) 
	{
		super(aName, aOrderIndex);
	}
}