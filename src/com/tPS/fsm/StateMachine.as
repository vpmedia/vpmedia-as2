import com.tPS.fsm.State;
/**
 * @author tPS
 * @version 1
 * 
 * Finite State Machine Abstract Class
 * Based on FSM by Richard Lord
 */
 
class com.tPS.fsm.StateMachine {
	private var currentState:State;
	private var lastState:State;
	private var nextState:State;
	
	function StateMachine(){
		currentState = null;
		lastState = null;
		nextState = null;
	}
	
	public function setNextState(s:State):Void{
		nextState = s;
	}
	
	public function update():Void{
		if(currentState){
			currentState.update();
		}
	}
	
	public function changeState(s:State):Void{
		currentState.exit();
		lastState = currentState;
		currentState = s;
		currentState.enter();		
	}
	
	public function toLastState():Void{
		changeState(lastState);
	}
	
	public function toNextState():Void{
		changeState(nextState);
	}
	
	public function get _state():State{
		return currentState;
	}
	
	public function get _nextState():State{
		return nextState;
	}
	
	public function get _lastState():State {
		return lastState;
	}
}