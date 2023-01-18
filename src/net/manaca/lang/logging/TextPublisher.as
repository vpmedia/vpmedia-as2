import net.manaca.lang.logging.IPublisher;
import net.manaca.lang.logging.LogEvent;

/**
 * 
 * @author Wersling
 * @version 1.0, 2005-11-25
 */
class net.manaca.lang.logging.TextPublisher implements IPublisher {
	private var className : String = "net.manaca.lang.logging.TextPublisher";

	private var _TextField : TextField;
	/**
	 * 构造函数
	 * @param 无
	 */
	public function TextPublisher(txt:TextField) {
		_TextField = txt;
	}
	public function publish(e : LogEvent) : Void {
		var arg:Object = e.argument;
		var txt:String = "[" + e.level.getName() + "]";
		txt += " : ";
		//txt += analyzeObj(arg,1);
		txt += arg.toString()+"\n";
		_TextField.text += txt;
	}

	public function toString() : String {
		return className;
	}

}