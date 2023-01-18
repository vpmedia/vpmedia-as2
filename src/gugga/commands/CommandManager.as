/**
 * @author Krasimir
 */
 
import gugga.commands.CommandHistory;
import gugga.common.ICommand;
 
class gugga.commands.CommandManager extends  CommandHistory {
	
	private static var mInstance:CommandManager = undefined;
//	private var mHistory:CommandHistory;
	
	private function CommandManager()
	{
//			mHistory = new CommandHistory();
	}
	
	public static function get Instance():CommandManager
	{
		if (mInstance == undefined)
		{
			mInstance = new CommandManager();
		}
		return mInstance;
	}
	
	public function execute(aCmd:ICommand)
	{
		var clone:ICommand =  aCmd.clone();
		clone.execute();
		/* alternative 
			aCmd.execute();
		 	var clone:ICommand =  aCmd.clone();
		 */
		add(clone);
	}
	
}