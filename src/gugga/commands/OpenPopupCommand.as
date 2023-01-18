import gugga.commands.IPopupCommandReciever;
import gugga.common.ICommand;

/**
 * @author Barni
 */
class gugga.commands.OpenPopupCommand implements ICommand 
{
	
//	private var mApplication:ITP3ApplicationCommandReciver;
	private var mReceiver:IPopupCommandReciever;
//	private var mPreviousState:ApplicatiotionNavigationalStateMemento;
	private var mPopupContentPath:String;
	private var mPopupXPosition:Number;
	private var mPopupYPosition:Number;
	
	public function OpenPopupCommand(aReciever : IPopupCommandReciever, aPopupContentPath : String, aPopupXPosition : Number, aPopupYPosition : Number)
	{
//		mApplication = ITP3ApplicationCommandReciver(_global.theApp);
		mReceiver = aReciever;
		mPopupContentPath = aPopupContentPath; 
		mPopupXPosition = aPopupXPosition;
		mPopupYPosition = aPopupYPosition;  
	}
	
	public function execute() : Void 
	{
//		mPreviousState =  mApplication.CreateNavigationState();
		mReceiver.openPopup(mPopupContentPath, mPopupXPosition, mPopupYPosition);
	}

	public function isReversible() : Boolean
	{
		return true;
	}

	public function undo() : Void
	{
//		mApplication.SetNavigationState(mPreviousState);
		//mReceiver.ClosePopup(mPopupContentPath);
		mReceiver.closePopup();
	}

	public function clone() : ICommand
	{
		var  copy:OpenPopupCommand =  new OpenPopupCommand(this.mReceiver, this.mPopupContentPath, this.mPopupXPosition, this.mPopupYPosition);
		
//		copy.mPreviousState = this.mPreviousState;
//		copy.mApplication = this.mApplication;
		return copy; 
	}
}