/**
 * @author tPS
 * Finite State Machine State Interface
 */
interface com.tPS.fsm.State {
	public function enter():Void;	//called while entering the state
	public function exit():Void;	//called while exit from the state
	public function update():Void; // called every updatecycle
	public function toString():String;
}