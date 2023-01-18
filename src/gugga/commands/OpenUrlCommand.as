
import gugga.common.ICommand;

/**
 * @author Krasimir
 */
class gugga.commands.OpenUrlCommand implements ICommand {
	private var mURL;
	private var mTarget ="_blank";
	
	
	public function OpenUrlCommand(aURL,aTarget)
	{
		mURL = aURL;
		if (aTarget)
			mTarget = aTarget;
	}
	public function execute() : Void {
		getURL(mURL,mTarget);
	}

	public function isReversible() : Boolean {
		return false;
	}

	public function undo() : Void {
	}

	public function clone() : ICommand {
		return new OpenUrlCommand(mURL,mTarget);
	}
	
	public function set Url(aURL:String)
	{
		mURL = aURL;
	}
	public function get Url()
	{
		return mURL;
	}
	
	public function get Target()
	{
		return mTarget ;
	}
	
	

}