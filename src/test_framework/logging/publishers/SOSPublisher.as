/**
 * @author todor
 */
 
import test_framework.logging.LogRecord;
import test_framework.logging.publishers.DefaultPublisher;

class test_framework.logging.publishers.SOSPublisher extends DefaultPublisher 
{
	private var mSocket:XMLSocket;
	
	public function SOSPublisher()
	{
		mSocket = new XMLSocket();
		mSocket.connect("localhost", 4444);
	}
	
	/**
	*	@see logging.IPublisher
	*/	
	public function publish(logRecord:LogRecord):Void
	{
		if (this.isLoggable(logRecord)) 
		{
			var traceStr:String = this.getFormatter().format(logRecord);
			mSocket.send(traceStr + "\n");
		}
	}
}