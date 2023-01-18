import net.manaca.ui.paint.Record;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-4-19
 */
class net.manaca.ui.paint.EraserRecord extends Record {
	private var className : String = "net.manaca.ui.paint.EraserRecord";

	private var _mcName : String;
	public function EraserRecord(mcName:String) {
		super();
		_mcName	=	mcName;
	}
	/**
	 * 获取名称
	 * @return 返回值类型：String 
	 */
	public function getName() :String
	{
		return _mcName;
	}
	public function toString():String{
		return "Eraser|"+_mcName;
	}
}