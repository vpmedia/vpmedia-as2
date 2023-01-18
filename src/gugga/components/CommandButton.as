import gugga.components.Button;
import gugga.common.ICommand;
import gugga.commands.CommandManager;

/**
 * @author bony
 */
class gugga.components.CommandButton extends Button 
{
	private var mCommand:ICommand;
	public function get Command() : ICommand { return mCommand; }
	public function set Command(aValue:ICommand) : Void { mCommand = aValue; }
	
	private function onRelease() : Void
	{
		super.onRelease();
		CommandManager.Instance.execute(mCommand);
	}
}