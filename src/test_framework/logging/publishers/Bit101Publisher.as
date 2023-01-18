/**
 * @author todor
 */
 
import test_framework.logging.LogRecord;
import test_framework.logging.publishers.DefaultPublisher;

class test_framework.logging.publishers.Bit101Publisher extends DefaultPublisher {
	private var mDebugPanelConnection:LocalConnection;
	
	public function Bit101Publisher(){
		mDebugPanelConnection = new LocalConnection();
	}
	
	/**
	*	@see logging.IPublisher
	*/	
	public function publish(logRecord:LogRecord):Void
	{
		if (this.isLoggable(logRecord)) {
			var traceStr:String = this.getFormatter().format(logRecord);
			mDebugPanelConnection.send("trace", "trace", traceStr);
		}
	}
}