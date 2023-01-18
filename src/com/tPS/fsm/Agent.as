import com.tPS.fsm.StateMachine;
/**
 * @author tPS
 * @version 1
 * Finite State Machine Agent
 * Based on FSM by Richard Lord
 */
class com.tPS.fsm.Agent {
	private var fsm:StateMachine;
	
	function Agent(){
		fsm = new StateMachine();
	}
	
	public function update():Void{
		fsm.update();
	}
	
	function get _fsm():StateMachine{
		return fsm;
	}
}