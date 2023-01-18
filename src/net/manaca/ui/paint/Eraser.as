import net.manaca.lang.BObject;
import net.manaca.util.Delegate;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.ui.paint.Drawing;
import net.manaca.util.MovieClipUtil;
import net.manaca.ui.paint.EraserRecord;
import net.manaca.ui.moviecilp.edit.SelectControl;

/**
 * 橡皮擦
 * @author Wersling
 * @version 1.0, 2006-4-19
 */
class net.manaca.ui.paint.Eraser extends BObject implements Drawing{
	private var className : String = "net.manaca.ui.paint.Eraser";
	private var _paint_mc : MovieClip;
	private var _isdraw : Boolean;
	private var _record : Array;
	private var _selectControl:SelectControl;
	public function Eraser(mc:MovieClip) {
		super();
		if(mc != undefined){
			_paint_mc = mc;
		}else{
			throw new IllegalArgumentException("在构造一个橡皮擦工具时缺少画板参数",this,arguments);
		}
		_isdraw = false;
		_record = new Array();
	}
	
	public function startDraw(x : Number, y : Number,mcName:String) : Array {
		_isdraw = true;
		_selectControl = new SelectControl(_paint_mc);
		return null;
	}

	public function draw(x : Number, y : Number) : Array {
		if(_isdraw){
			var _mc:MovieClip = _selectControl.getSelect(x,y);
			if(_mc != null){
				_record.push(new EraserRecord(_mc._name));
				MovieClipUtil.remove(_mc);
			}
		}
		return null;
	}

	public function endDraw() : Array {
		_isdraw = false;
		return null;
	}
	
	/**
	 * 获取橡皮擦记录
	 * @return Array 一个橡皮擦记录得数组
	 */
	public function getRecord():Array{
		return _record;
		
	}
}