/**
*	@author Todor Kolev
*/

import gugga.tracking.formatters.DefaultFormatter;
import gugga.tracking.IFilter;
import gugga.tracking.IFormatter;
import gugga.tracking.IPublisher;
import gugga.tracking.TrackRecord;
import gugga.logging.Logger;
import gugga.utils.DebugUtils;
import gugga.debug.Debugger;

class gugga.tracking.publishers.DefaultPublisher implements IPublisher
{
	private var mFilter:IFilter;
	private var mFormatter:IFormatter;
	private var mTrackableActions:String;
	private var mTrackableActionsInternal:String;

	public function DefaultPublisher() 
	{
		this.setFormatter(new DefaultFormatter());
	}

	public function publish(aTrackRecord:TrackRecord):Void
	{
		if (this.isLoggable(aTrackRecord)) 
		{
			var trackString : String;
			
			trackString = this.getFormatter().formatOriginator(aTrackRecord);
			trackString += ", " + aTrackRecord.Action.toString();
			trackString += ", " + DebugUtils.objectToString(aTrackRecord.Arguments);
			
			Logger.logInfo(trackString, this);
		}
	}
	
	public function setFilter(mFilter:IFilter):Void
	{
		this.mFilter = mFilter;
	}
	
	public function getFilter():IFilter
	{
		return this.mFilter;
	}

	public function setFormatter(mFormatter:IFormatter):Void
	{
		this.mFormatter = mFormatter;
	}

	public function getFormatter():IFormatter
	{
		return this.mFormatter;
	}
	
	public function setTrackableActions(trackableActions : String) : Void 
	{
		mTrackableActions = trackableActions;
		mTrackableActionsInternal = "," + mTrackableActions.split(" ").join("") + ",";
	}
	
	public function getTrackableActions() : String 
	{
		return mTrackableActions;
	}
	
	//TODO: messy logic. should be cleared
	public function isLoggable(aTrackRecord:TrackRecord):Boolean
	{
		if(mTrackableActions == "ALL")
		{
			return true;
		}

		if(mTrackableActions == "NONE")
		{
			return false;
		}
		
		if (mTrackableActionsInternal.indexOf(aTrackRecord.Action.toString(), 0) < 0) 
		{
			return false;
		}
		
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
}