import gugga.common.IEventDispatcher;

[Event("taskAdded")] //ev.task
[Event("tasksAdded")] //ev.tasks
[Event("taskRemoved")] //ev.task
[Event("tasksRemoved")] //ev.tasks

/**
 * @author Todor Kolev
 */
interface gugga.sequence.ITasksContainer extends IEventDispatcher 
{
	public function getAllTasks() : Array;	
}