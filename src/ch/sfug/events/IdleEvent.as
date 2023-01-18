import ch.sfug.events.Event;

/**
* Informs any listeners that the user has not performed any interaction for a specified amount of time.
* @author Stefan Thurnherr
*/
class ch.sfug.events.IdleEvent extends Event {
	
	public static var IDLE:String = "idle";
	
	private var idleSinceValue:Number;
	
	/**
	* Constructor.
	* @param	idleMilliSecs The number of milliseconds for which no user interaction with
	* the exercise has occurred.
	*/
	public function IdleEvent(type:String, idleMilliSecs:Number){
		super(type);
		this.idleSinceValue = idleMilliSecs;
		//trace("IdleEvent::constructor: instance created.");
	}
	
	/**
	* Getter method for the amount of time for which no interaction has occurred.
	* @return The number of idle milliseconds, i.e., the number of milliseconds that
	* have passed since the user's last interaction with the exercise. A negative number
	* means that an interaction has just happened (after an idle period).
	*/
	public function getIdleMilliSeconds():Number {
		return this.idleSinceValue;
	}
}