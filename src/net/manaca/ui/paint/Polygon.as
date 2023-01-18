import net.manaca.lang.BObject;
import net.manaca.util.Delegate;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.ui.paint.Drawing;

/**
 * 多边型
 * @author Wersling
 * @version 1.0, 2006-4-18
 */
class net.manaca.ui.paint.Polygon extends BObject implements Drawing{
	private var className : String = "net.manaca.ui.paint.Polygon";
	private var _paint_mc:MovieClip;
	private var _isdraw:Boolean;
	private var _record:Array;
	
	/**
	 * 构造一个多边型
	 * @param mc 指定画板
	 * @param border_count 指定边数
	 */
	public function Polygon(mc:MovieClip,border_count:Number) {
		super();
		if(mc != undefined){
			_paint_mc = mc;
		}else{
			throw new IllegalArgumentException("在构造一个多边型绘画工具时缺少画板参数",this,arguments);
		}
		_isdraw = false;
		_record = new Array();
	}
	
	public function startDraw(x : Number, y : Number,mcName : String) : Array {
		return null;
	}

	public function draw(x : Number, y : Number) : Array {
		return null;
	}

	public function endDraw(x : Number, y : Number) : Array {
		return null;
	}

	public function getRecord() : Array {
		return null;
	}

}