import net.manaca.lang.BObject;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.ui.moviecilp.edit.SelectControl;
import net.manaca.ui.controls.Selector;
import net.manaca.util.MovieClipUtil;
import net.manaca.util.Delegate;
import net.manaca.lang.event.Event;

/**
 * 元件编辑器
 * @author Wersling
 * @version 1.0, 2006-4-19
 */
class net.manaca.ui.moviecilp.edit.CilpEditControl extends BObject {
	private var className : String = "net.manaca.ui.moviecilp.edit.CilpEditControl";

	private var _isEdit : Boolean;
	private var _edit_mc:MovieClip;
	//编辑记录
	private var _record : Array;
	private var _edit_area_mc:MovieClip;
	//当前编辑对象
	private var _now_mc:MovieClip;
	private var _select_control:SelectControl;
	//编辑组件
	private var cs : Selector;
	private var _le:Function;
	/**
	 * 构造一个编辑器
	 * @param mc 指定需要编辑哪个元件中的元件
	 */
	public function CilpEditControl(mc:MovieClip) {
		super();
		if(mc != undefined && (typeof mc == "movieclip")){
			_edit_mc = mc;
		}else{
			throw new IllegalArgumentException("在构造一个元件编辑器时缺少编辑位置参数",this,arguments);
		}
		_isEdit = false;
		_record = new Array();
		_select_control = new SelectControl(_edit_mc);
		//建议编辑元件
		_edit_area_mc = _edit_mc.createEmptyMovieClip("_edit_area_mc",_edit_mc.getNextHighestDepth());
		var _keyEven:Object = new Object();
		_keyEven.onKeyDown = Delegate.create(this,onKeyDown);
		Key.addListener(_keyEven);
		
		_le = Delegate.create(this,UpdateRectangle);
	}
	/**
	 * 选择元件
	 */
	private function onSelect() : Void {
		if(_isEdit){
			var _mc:MovieClip  = _select_control.getSelect(_root._xmouse,_root._ymouse);
			if(_mc != null){
				if(_now_mc != _mc){
					clear();
					_now_mc = _mc;
					cs = new Selector(_edit_mc,"_Selector_mc");
					var r = _now_mc._rotation;
					_now_mc._rotation = 0;
					cs.setSize(_now_mc._width,_now_mc._height);
					cs.setLocation(_now_mc._x,_now_mc._y);
					cs.addEventListener(Event.CHANGE,_le);
//					cs._x = _now_mc._x;
//					cs._y = _now_mc._y;
					cs.rotation = r;
					_now_mc._rotation = r;
				}else{
					//_now_mc.startDrag();
					//_now_mc.onEnterFrame = Delegate.create(this,onMoviecs);
				}
			}else{
				clear();
				delete cs;
			}
		}
	}
	
	/**
	 * 更新大小
	 */
	private function UpdateRectangle(e:Event) : Void {
		_now_mc._x = e.value[0];
		_now_mc._y = e.value[1];
		_now_mc._width = e.value[2];
		_now_mc._height = e.value[3];
	}

	private function onUp():Void{
		_now_mc.stopDrag();
		_now_mc.onEnterFrame = null;
		delete _now_mc.onEnterFrame;
		onMoviecs();
	}
	/**
	 * 清理绘制的选择元素
	 */
	private function clear():Void{
		_now_mc = null;
		//MovieClipUtil.remove(cs.getDisplayObject());
		cs.removeEventListener(_le);
		cs.remove();
		cs = null;
	}
	/**
	 * 使选择元素与元件一起移动
	 */
	private function onMoviecs(){
//		cs._x = _now_mc._x;
//		cs._y = _now_mc._y;
		trace(1);
		cs.setLocation(_now_mc._x,_now_mc._y);
	}
	/**
	 * 开始编辑
	 */
	public function startEdit():Void{
		_isEdit = true;
		_edit_area_mc.onMouseDown = Delegate.create(this,onSelect);
		_edit_area_mc.onMouseUp = Delegate.create(this,onUp);
	}
	
	/**
	 * 结束编辑
	 */
	public function endEdit():Void{
		_isEdit = false;
		_edit_area_mc.onMouseDown = null;
		delete _edit_area_mc.onMouseDown;
	}


	private function onKeyDown() : Void {
		if(_now_mc != null){
			if(Key.isDown(Key.DELETEKEY)){
				MovieClipUtil.remove(_now_mc);
				clear();
			}
		}
	}


}