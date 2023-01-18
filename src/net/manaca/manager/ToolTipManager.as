import net.manaca.lang.BObject;
import net.manaca.util.Delegate;
import net.manaca.ui.controls.ToolTip;
/**
 * ToolTipManager 包含众多属性，用于配置该工具提示需要多长时间显示出来，
 * 需要多长时间隐藏。考虑一个在不同的鼠标位置（如 JTree）有不同工具提示的组件。
 * 在鼠标移动到 JTree 中和具有有效工具提示的区域上时，
 * 该工具提示将在 initialDelay 毫秒后显示出来。在 dismissDelay 毫秒后，
 * 将隐藏该工具提示。如果鼠标在具有有效工具提示的区域上，并且当前能看到该工具
 * 提示，则在鼠标移动到没有有效工具提示的区域时，将隐藏该工具提示。如果鼠标接
 * 下来在 reshowDelay 毫秒内移回具有有效工具提示的区域，则将立即显示该工具提示，
 * 否则在 initialDelay 毫秒后将再次显示该工具提示。 
 * @author Wersling
 * @version 1.0, 2006-4-30
 */
class net.manaca.manager.ToolTipManager extends BObject{
	private var className : String = "net.manaca.manager.ToolTipManager";
	private static var _instance : ToolTipManager;
	private var _dismiss : Number;
	private var _initial : Number;
	private var _reshow : Number;
	private var _isEnabled : Boolean;
	private var _isinitial:Boolean;//是否初始化
	private var _mouse_event:MovieClip;
	private var _reshow_time_out:Number;
	private var _dismiss_time_out:Number;
	//是否显示
	private var _isShow : Boolean;
	private var _toolTip:ToolTip;
	private var _nowShowObj : Object;//但前显示对象
	
	private var _registerList:Array;
	/**
	 * @return singleton instance of ToolTipManager
	 */
	public static function getInstance() : ToolTipManager {
		if (_instance == null)
			_instance = new ToolTipManager();
		return _instance;
	}
	
	/**
	 * 构造函数
	 */
	private function ToolTipManager() {
		super();
		_dismiss = 3000;
		_initial = 1000;
		_reshow = 500;
		_registerList = new Array();
		_mouse_event = _root.createEmptyMovieClip("ToolTipManager_mouse_event",_root.getNextHighestDepth());
		_toolTip = new ToolTip(_mouse_event,"_manaca_toolTip_info_object");
		setEnabled(true);
	}
	/**
	 * 添加一个需要显示提示的对象
	 * @param object 要将工具提示文本与其关联的 object

	 */
	public function push(object:Object,display:String):Void{
		if(typeof(object) == "movieclip"){
			if(display != undefined && display != ""){
				object.toolTip = display;
				object.toolTipShow = true;
			}else if(display == ""){
				object.toolTip = display;
				object.toolTipShow = false;
			}
			_registerList.push(object);
		}
	}
	
	/**
	 * 删除指定元素的提示
	 */
	public function remove(object:Object):Void{
		for (var i : Number = 0; i < _registerList.length; i++) {
			if(_registerList[i] == object){
				_registerList.splice(i,1);
			}
		}
	}
	
	/**
	 * 返回取消工具提示的延迟值。
	 */
	public function getDismissDelay():Number{
		return _dismiss;
	}
	/**
	 * 返回初始延迟值。
	 */
	public function getInitialDelay():Number{
		return _initial;
	}
	
	/**
	 * 返回重新显示延迟属性。
	 */
	public function getReshowDelay():Number{
		return _reshow;
	}
	
	/**
	 * 如果启用该对象，则返回 true。
	 */
	public function isEnabled():Boolean{
		return _isEnabled;
	}
	
	/**
	 * 设置取消工具提示的延迟值。默认 2000
	 * @param milliseconds
	 */
	public function setDismissDelay(milliseconds:Number):Void{
		_dismiss = milliseconds;
	}
	/**
	 * 设置初始延迟值。默认 2000
	 */
	public function setInitialDelay(milliseconds:Number):Void{
		_initial = milliseconds;
	}
	
	/**
	 * 设置重新显示延迟属性。默认 500
	 */
	public function setReshowDelay(milliseconds:Number):Void{
		_reshow = milliseconds;
	}
	
	/**
	 * 启用或禁用工具提示。
	 */
	public function setEnabled(b:Boolean):Void{
		_isEnabled = b;
		if(_isEnabled) {
			_mouse_event.onMouseMove = Delegate.create(this,onMouseMoveEvent);
			_mouse_event.onMouseDown = Delegate.create(this,onMouseDownEvent);
		}else{
			_mouse_event.onMouseMove = null;
			delete _mouse_event.onMouseMove;
		}
	}
	
	/**
	 * 鼠标移动
	 */
	private function onMouseMoveEvent() : Void {
		clearInterval(_dismiss_time_out);
		clearInterval(_reshow_time_out);
		if(_isinitial){
			_reshow_time_out = setInterval(this,"onReshow",_reshow);
		}else{
			_reshow_time_out = setInterval(this,"onReshow",_initial);
		}
		if(_isShow && !_nowShowObj.hitTest(_root._xmouse,_root._ymouse,true)) {
			hide();
		}
	}
	//鼠标停止
	private function onReshow():Void{
		_isinitial = true;
		clearInterval(_reshow_time_out);
		show();
		clearInterval(_dismiss_time_out);
		_dismiss_time_out = setInterval(this,"onDismiss",_dismiss);
	}
	
	private function onDismiss():Void{
		clearInterval(_dismiss_time_out);
		_isinitial = false;
		hide();
	}
	//鼠标按下
	private function onMouseDownEvent() : Void {
		clearInterval(_reshow_time_out);
		onDismiss();
	}
	
	private function show():Void{
		if(!_isShow){
			var _arr:Array = new Array();
			for (var i : Number = 0; i < _registerList.length; i++) {
				if(_registerList[i].hitTest(_root._xmouse,_root._ymouse,true) && isVisible(_registerList[i])){
					_arr.push(_registerList[i]);
//					if(_registerList[i].toolTipShow && _registerList[i].toolTip != ""){
//						
//						_toolTip.showCaption(_registerList[i].toolTip);
//						_isShow = true;
//						_nowShowObj = _registerList[i];
//						break;
//						return ;
//					}
				}
			}
			if(_arr.length > 0){
				var _nowMc:MovieClip = _arr[0];
				for (var i : Number = 1; i < _arr.length; i++) {
					if(_nowMc.getDepth() < _arr[i].getDepth()) _nowMc = _arr[i];
					if(isParent(_nowMc,_arr[i])) _nowMc = _arr[i];
				}
				if(_nowMc.toolTipShow) {
					_toolTip.showCaption(_nowMc.toolTip);
					_isShow = true;
					_nowShowObj =_nowMc;
				}
			}

		}
	}
	//判断_now_mc是否为_par_mc的子元件
	private function isParent(_par_mc,_now_mc):Boolean{
		var _p:MovieClip = _now_mc;
		while(_p._parent != undefined){
			if(_p._parent == _par_mc) return true;
			_p = _p._parent;
		}
		return false;
	}
	//判断_now_mc是否可见
	private function isVisible(_now_mc):Boolean{
		var _p:MovieClip = _now_mc;
		while(_p._parent != undefined){
			if(_p._visible == false) return false;
			_p = _p._parent;
		}
		return true;
	}
	private function hide():Void{
		if(_isShow) _toolTip.hide();
		_isShow = false;
	}
}