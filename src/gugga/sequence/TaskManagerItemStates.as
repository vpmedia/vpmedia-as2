import gugga.common.BaseEnum;

/**
 * @author Barni
 */
class gugga.sequence.TaskManagerItemStates extends BaseEnum 
{
	public static var Pending : TaskManagerItemStates = new TaskManagerItemStates("Pending", 0);
	public static var Running : TaskManagerItemStates = new TaskManagerItemStates("Running", 1);
	public static var Completed : TaskManagerItemStates = new TaskManagerItemStates("Completed", 2);
	public static var Interrupted : TaskManagerItemStates = new TaskManagerItemStates("Interrupted", 3);
	
	private function TaskManagerItemStates(aName : String, aOrderIndex : Number) 
	{
		super(aName, aOrderIndex);
	}
}