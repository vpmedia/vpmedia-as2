import gugga.application.ApplicatiotionNavigationalStateMemento;
import gugga.commands.IApplicationCommandReceiver;
import gugga.common.ICommand;

/**
 * @author Krasimir
 */
class gugga.commands.NavigationCommand implements ICommand {
	
//	private var mApplication:Application;
	private var mReceiver:IApplicationCommandReceiver;
	private var mPreviousState:ApplicatiotionNavigationalStateMemento;
	private var mNavigateTo:String;
	
	public function NavigationCommand(aNavigateTo:String)
	{
	//	mApplication = Application.Instance;
		mReceiver = IApplicationCommandReceiver(_global.ApplicationController);
		
		mNavigateTo = aNavigateTo;
	}

	public function execute() : Void {
		mPreviousState =  mReceiver.CreateNavigationState();
		mReceiver.NavigateTo(mNavigateTo);
	}

	public function isReversible() : Boolean {
		return true;
	}

	public function undo() : Void {
	 	mReceiver.SetNavigationState(mPreviousState);
	}
	
	public function clone():ICommand
	{
		var  copy:NavigationCommand =  new NavigationCommand(this.mNavigateTo);
		
		copy.mNavigateTo = this.mNavigateTo;
		copy.mPreviousState = this.mPreviousState;
//		copy.mApplication = this.mApplication;
		copy.mReceiver = this.mReceiver;
		return copy; 
	}
	
	

}