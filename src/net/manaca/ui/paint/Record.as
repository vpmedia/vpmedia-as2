import net.manaca.lang.BObject;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-4-18
 */
class net.manaca.ui.paint.Record extends BObject {
	private var className : String = "net.manaca.ui.paint.Record";
	//用于记录绘画元素编号
	static private var _record_id:Number = 0;
	private function Record() {
		super();
	}
	
	/**
	 * 获取绘画ID
	 */
	static public function getId():Number{
		return _record_id++;
	}
}