import gugga.collections.HashTable;
import gugga.tracking.TrackableAction;

/**
 * @author Todor Kolev
 */
class gugga.tracking.TrackRecord 
{
	public var Originator : Object;
	public var Action : TrackableAction;
	public var Arguments : HashTable;
	
	public var SessionID : String;
	
	public function TrackRecord(aOriginator:Object, aAction:TrackableAction, 
		aArguments:HashTable, aSessionID:String)
	{
		Originator = aOriginator;
		Action = aAction;
		Arguments = aArguments;
		SessionID = aSessionID;
	}
}