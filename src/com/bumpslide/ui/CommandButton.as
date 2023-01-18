import com.bumpslide.events.*;
import org.asapframework.management.movie.*;

/**
* Command Button sends named command event
* to the nearest ASAP Local Controller
* 
* @author David Knape 
*/

class com.bumpslide.ui.CommandButton extends com.bumpslide.ui.Button
{	
	// controller that will receive the command event
	private var mController:LocalController;
	
	// name/type of the event that will be sent to the controller
	private var mCommandEvent : String;
	
	// additional argument to pass along in command event
	private var mCommandArg : Object  = null;
	
	
	/**
	* find nearest local controller
	*/
	function CommandButton() {
		super();
		mController = MovieManager.getInstance().getNearestLocalController(this);
		//trace('created command button ' + this._name );
	}
	
	/**
	* set command to issue when released
	* 
	* @param	eventName
	*/
	public function set commandEvent (eventName:String) 
	{		
		//debug('setting commandEvent ='+eventName );
		mCommandEvent = eventName;		
	}
	
	/**
	* set command argument to pass along with event when released
	* 
	* @param	eventName
	*/
	public function set commandArg (arg:Object) 
	{		
		mCommandArg = arg;		
	}
	
	public function onRelease () : Void 
	{
		if(mCommandEvent==undefined) {
			debug('onRelease, commandEvent is undefined');		
		} else if(mCommandEvent!=null && mController!=null) {
			runCommand( mCommandEvent, mCommandArg );
		} 
		
		super.onRelease();
	}
}
