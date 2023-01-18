import gugga.common.ITask;

[Event("sectionAvailable")]
[Event("sectionUIInitialized")]
[Event("sectionInitialized")]

/**
 * @author Todor Kolev
 */
interface gugga.components.ISectionLoader extends ITask 
{
	public function unloadData() : Boolean;
}