import gugga.collections.ArrayList;
import gugga.collections.HashTable;
import gugga.tracking.IFilter;
import gugga.tracking.IPublisher;
import gugga.tracking.TrackableAction;
import gugga.tracking.TrackManager;
import gugga.tracking.TrackRecord;
import gugga.utils.ReflectUtil;

/**
 * @author Todor Kolev
 */
class gugga.tracking.Tracker 
{	
	private static var OBJECT_DEFAULT_LOGGER_VAR_NAME : String = "___default_logger";
	
	public static var Default : Tracker;
	public static var SessionID : String;
	private static var mTrackerMap:Object;
	
	private var mName : String;
	private var mPublishers : ArrayList;

	private var mFilter : IFilter;

	private var mTrackableActions : String;
	private var mTrackableActionsInternal : String;
		
	private function Tracker(aName:String)
	{
		mName = aName;
		mPublishers = new ArrayList();
	}
	
	public static function getTracker(aName:String) : Tracker
	{
		if (aName == undefined || aName == "") 
		{
			return new Tracker();
		}
		
		if (getTrackerMap()[aName] == undefined) 
		{
			getTrackerMap()[aName] = new Tracker(aName);
		}
		
		return getTrackerMap()[aName];
	}

	public static function getTrackerFor(aObject : Object) : Tracker 
	{
		var tracker : Tracker = Tracker(aObject[OBJECT_DEFAULT_LOGGER_VAR_NAME]);
		
		if(tracker == undefined || tracker == null)
		{
			var typeName : String = ReflectUtil.getTypeNameForInstance(aObject);
			
			tracker = Tracker.getTracker(typeName);
		}
		
		return tracker;
	}
	
	private static function getTrackerMap() : Object
	{
		if (mTrackerMap == undefined) 
		{
			mTrackerMap = new Object();
		}
		
		return mTrackerMap;
	}
	
	public function getParent() : Tracker
	{
		if (this.getName() == "global") 
		{
			return undefined;
		}
		
		var a:Array = this.getName().split(".");
		a.pop();
		
		while (a.length > 0) 
		{
			var name : String = a.join(".");
			
			if (getTrackerMap()[name] != undefined) 
			{
				return getTracker(name);
			} 
			else 
			{
				a.pop();
			}
		}
		
		return getTracker("global");
	}
	
	public function getName() : String
	{
		return this.mName;
	}
	
	public function setTrackableActions(aTrackableActions:String) : Void
	{
		mTrackableActions = aTrackableActions;
		mTrackableActionsInternal = "," + mTrackableActions.split(" ").join("") + ",";
	}
	
	public function getTrackableActions() : String
	{
		return mTrackableActions;
	}

	public function setFilter(aFilter:IFilter) : Void
	{
		mFilter = aFilter;
	}
	
	public function getFilter() : IFilter
	{
		return mFilter;
	}
	
	public function addPublisher(publisher:IPublisher) : Void
	{
		if (!mPublishers.containsItem(publisher)) 
		{
			mPublishers.addItem(publisher);
		}
	}
	
	public function removePublisher(publisher:IPublisher) : Void
	{
		mPublishers.removeItem(publisher);
	}
	
	public function getPublishers():ArrayList
	{
		return mPublishers;
	}
	
	private function getActivePublishers() : ArrayList
	{		
		if (this.getParent() != undefined) 
		{
			var v:ArrayList = new ArrayList();
			
			v.addAll(mPublishers);
			v.addAll(this.getParent().getActivePublishers());
						
			if (v.isEmpty()) 
			{
				v.addItem(TrackManager.getInstance().getDefaultPublisher());
			}	
			
			return v;
		}
		
		return this.getPublishers();
	}
	
	public function isLoggable(aAction:TrackableAction) : Boolean
	{
		if(mTrackableActions == "ALL")
		{
			return true;
		}

		if(mTrackableActions == "NONE")
		{
			return false;
		}
		
		return mTrackableActionsInternal.indexOf(aAction.toString(), 0) != -1;
	}
	
	private function isPublishable(aTrackRecord:TrackRecord) : Boolean
	{
		if (this.getFilter() == undefined || this.getFilter() == null) 
		{
			return true;
		}
		
		if (this.getFilter().isLoggable(aTrackRecord)) 
		{
			return true;
		}

		return false;	
	}
	
	
	public function track(aOriginator : Object, aAction : TrackableAction, aArguments : HashTable) : Void
	{
		if (this.isLoggable(aAction)) 
		{
			var trackRecord : TrackRecord = new TrackRecord(aOriginator, aAction, aArguments, SessionID);
			
			if (this.isPublishable(trackRecord)) 
			{
				var ap:ArrayList = this.getActivePublishers();
				for (var p = 0; p < ap.length; p++) 
				{
					IPublisher(ap[p]).publish(trackRecord);
				}
			}
		}
	}
	
	public function trackNavigate(aOriginator : Object, aSectionPath : String) : Void
	{
		var trackArguments : HashTable = new HashTable();
		trackArguments["sectionPath"] = aSectionPath;
		
		track(aOriginator, TrackableAction.Navigate, trackArguments);
	}	
	
	public function trackClick(aOriginator : MovieClip, aX : Number, aY : Number) : Void
	{
		var trackArguments : HashTable = new HashTable();
		trackArguments["x"] = aX;
		trackArguments["y"] = aY;
		
		track(aOriginator, TrackableAction.Click, trackArguments);
	}

	public function trackCustomTrigger(aOriginator : Object, aArguments : HashTable) : Void
	{
		track(aOriginator, TrackableAction.CustomTrigger, aArguments);
	}

	public function trackPlayVideo(aOriginator : Object, aVideoPath : String, aVideoTitle : String) : Void
	{
		var trackArguments : HashTable = new HashTable();
		trackArguments["videoPath"] = aVideoPath;
		trackArguments["videoTitle"] = aVideoTitle;
		
		track(aOriginator, TrackableAction.PlayVideo, trackArguments);
	}	
	
	public function trackPauseVideo(aOriginator : Object, aVideoPath : String, aVideoTitle : String) : Void
	{
		var trackArguments : HashTable = new HashTable();
		trackArguments["videoPath"] = aVideoPath;
		trackArguments["videoTitle"] = aVideoTitle;
		
		track(aOriginator, TrackableAction.PauseVideo, trackArguments);
	}
		
	public function trackStopVideo(aOriginator : Object, aVideoPath : String, aVideoTitle : String) : Void
	{
		var trackArguments : HashTable = new HashTable();
		trackArguments["videoPath"] = aVideoPath;
		trackArguments["videoTitle"] = aVideoTitle;
		
		track(aOriginator, TrackableAction.StopVideo, trackArguments);
	}	

	public function trackFinishedVideo(aOriginator : Object, aVideoPath : String, aVideoTitle : String) : Void
	{
		var trackArguments : HashTable = new HashTable();
		trackArguments["videoPath"] = aVideoPath;
		trackArguments["videoTitle"] = aVideoTitle;
		
		track(aOriginator, TrackableAction.FinishedVideo, trackArguments);
	}	
	
	public function trackPlayAudio(aOriginator : Object, aAudioPath : String, aAudioTitle : String) : Void
	{
		var trackArguments : HashTable = new HashTable();
		trackArguments["audioPath"] = aAudioPath;
		trackArguments["audioTitle"] = aAudioTitle;
		
		track(aOriginator, TrackableAction.PlayAudio, trackArguments);
	}	

	public function trackPauseAudio(aOriginator : Object, aAudioPath : String, aAudioTitle : String) : Void
	{
		var trackArguments : HashTable = new HashTable();
		trackArguments["audioPath"] = aAudioPath;
		trackArguments["audioTitle"] = aAudioTitle;
		
		track(aOriginator, TrackableAction.PauseAudio, trackArguments);
	}	
}