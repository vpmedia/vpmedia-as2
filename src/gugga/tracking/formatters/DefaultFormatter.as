import gugga.common.UIComponentEx;
import gugga.tracking.IFormatter;
import gugga.tracking.TrackRecord;
import gugga.utils.ReflectUtil;

/**
 * @author Todor Kolev
 */
class gugga.tracking.formatters.DefaultFormatter implements IFormatter 
{
	public function formatOriginator(aTrackRecord : TrackRecord) : String 
	{
		if(typeof(aTrackRecord.Originator) == "string")
		{
			return aTrackRecord.Originator.toString();
		}
		else if(aTrackRecord.Originator instanceof MovieClip)
		{			
			var originatorParents : Array = new Array();
			var tempObject : MovieClip = MovieClip(aTrackRecord.Originator);
			
			while(tempObject)
			{
				if ((tempObject instanceof UIComponentEx) 
					&& UIComponentEx(tempObject).TrackableID != undefined
					&& UIComponentEx(tempObject).TrackableID != null)
				{
					originatorParents.push(UIComponentEx(tempObject).TrackableID);
				}
				
				tempObject = tempObject._parent;
			}
			
			var originatorName : String = "";
			while(originatorParents.length > 0)
			{
				if(originatorName != "")
				{
					originatorName += ".";
				}
				
				originatorName += originatorParents.pop().toString();
			}
			
			return originatorName;
		}
		else
		{
			return ReflectUtil.getTypeNameForInstance(aTrackRecord.Originator);
		}
	}
}