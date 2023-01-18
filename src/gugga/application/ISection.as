import gugga.common.IEventDispatcher;
import gugga.common.IProgressiveTask;

/**
 * @author Barni
 */

[Event("initialize")]
[Event("initialized")]
[Event("activate")]
[Event("activated")]
[Event("open")]
[Event("opened")]
[Event("close")]
[Event("closed")]
[Event("destroy")]
[Event("destroyed")]
interface gugga.application.ISection extends IEventDispatcher 
{
	public function initialize():Void;

	public function activate():Void;
	public function open():Void;
	public function close():Void;

	public function destroy():Void;
	
	public function getPreOpenProgressMonitoringTask() : IProgressiveTask;
}