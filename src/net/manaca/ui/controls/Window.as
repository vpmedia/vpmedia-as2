import net.manaca.ui.controls.skin.IWindowSkin;
import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.awt.Dimension;
import net.manaca.ui.controls.Button;
import net.manaca.lang.exception.IllegalStateException;
import net.manaca.lang.event.ButtonEvent;
import net.manaca.util.Delegate;
import net.manaca.ui.awt.Rectangle;
import net.manaca.util.DepthControl;
import net.manaca.ui.controls.Panel;
import net.manaca.data.list.ArrayList;
import net.manaca.ui.controls.IContainers;
import net.manaca.lang.IObject;
import net.manaca.data.Iterator;
import net.manaca.lang.event.Event;
import net.manaca.ui.controls.Label;
import net.manaca.ui.controls.skin.mnc.WindowSkin;
/** 单击（松开）关闭按钮时广播。 */
[Event("click")]
/** 创建窗口完成时广播 */
[Event("complete")]
/**
 * Window 组件在一个具有标题栏、边框和关闭按钮（可选）的窗口内显示影片剪辑的内容。
 * @author Wersling
 * @version 1.0, 2006-5-15
 */
class net.manaca.ui.controls.Window extends UIComponent implements IContainers {
	private var className : String = "net.manaca.ui.controls.Window";
	private var _componentName = "Window";
	private var _skin:IWindowSkin;
	//元素
	private var _close_but:Button;
	private var _min_but:Button;
	private var _max_but:Button;
	private var _size_but : Button;
	private var _drag_but:MovieClip;
	private var _panel:Panel;
	private var _label:Label;
	//保存在被最大化和最小化之前的位置
	private var _quondamRectangle:Rectangle;
	//组件状态
	private var _state:String = "restore";//restore,maximum,minimum
	private var _observers:ArrayList;
	//
	private var _stateBySize : Dimension;
	private var _windowType : String;

	private var _isDrag : Boolean = false;
	//载入的内容
	private var _content : MovieClip;

	private var __contentPath : String;

	/**
	 * 构造一个Window
	 * @param target : MovieClip - 构造位置
	 * @param new_name : String - 名称
	 * @param windowType : String - 窗口类型，默认“Sizable”，有以下几种形式：
	 * <li>None : 没有任何可操作按钮</li>
	 * <li>Closed : 大小固定的，只有关闭按钮</li>
	 * <li>Fixed : 大小固定的，只有关闭按钮和最小化的</li>
	 * <li>Sizable : 大小相当，可以调整的</li>
	 */
	public function Window(target : MovieClip, new_name : String) {
		super(target, new_name);
		_skin = new WindowSkin();
		
		_preferredSize = new Dimension(120,120);
		
		UpdateMaximumSize();
		
		_windowType = (windowType != undefined) ? windowType : "Sizable";
		_observers= new ArrayList();
		
		paintAll();
		init();
	}
	/** 构建按钮 */
	private function init():Void{
		_close_but = _skin.getCloseButton();
		_min_but = _skin.getMinButton();
		_max_but = _skin.getMaxButton();
		_size_but = _skin.getSizeButton();
		_drag_but = _skin.getDragButton();
		_panel = _skin.getPanel();
		_label = _skin.getLabel();
		
		_label.text = "Windows";
		_close_but.addEventListener(ButtonEvent.RELEASE,Delegate.create(this,onClose));
		_min_but.addEventListener(ButtonEvent.RELEASE,Delegate.create(this,changeState,"minimum"));
		_max_but.addEventListener(ButtonEvent.RELEASE,Delegate.create(this,changeState,"maximum"));
		//调整大小
		_size_but.addEventListener(ButtonEvent.PRESS,Delegate.create(this,startChangeSize));
		_size_but.addEventListener(ButtonEvent.RELEASE,Delegate.create(this,stopChangeSize));
		_size_but.addEventListener(ButtonEvent.RELEASE_OUT_SIDE,Delegate.create(this,stopChangeSize));
		
		//拖动
		_drag_but.onPress = Delegate.create(this,startDrag);
		_drag_but.onRelease = Delegate.create(this,stopDrag);
		_drag_but.onReleaseOutside = Delegate.create(this,stopDrag);
		
		//深度
		_skin.getBack().onPress = Delegate.create(this,setFocus);
		_skin.getBack().useHandCursor = false;
		
		_minimumSize = _skin.getMinimumSize();
		
		_stateBySize = _skin.getUsableArea();
		
		this.dispatchEvent(new Event("complete",null,this));
	}
	/**
	 * 获取可以装载元素的面板
	 * @param  value  参数类型：MovieClip 
	 * @return 返回值类型：MovieClip 
	 */
	public function getPanel() :MovieClip{
		return _panel.getBoard();
	}
	/**
	 * 获取可用区域
	 */
	public function getUsableArea():Dimension{
		return _skin.getUsableArea();
	}
	public function onKillFocus(oldFocus:UIComponent):Void{
		super.onKillFocus(oldFocus);
		_skin.updateFocus(false);
	}
	
	/** 获得时触发 */
	public function onSetFocus(newFocus:UIComponent):Void{
		super.onSetFocus(newFocus);
		DepthControl.bringToFront(this.getDisplayObject());
		_skin.updateFocus(true);
	}
	

	/**
	 * 更新组件
	 */
	public function Update(o:IContainers):Void{
		_maximumSize = Dimension(o.getState());
		if( _state == "maximum"){
			onMaximum();
		}
	}
	
	/**
	 * 绑定一个指定对象
	 */
	public function attach(o : IObject) : Void {
		_observers.push(o);
		notify();
	}
	
	/**
	 * 解除指定的绑定对象
	 */
	public function detach(o : IObject) : Void {
		_observers.remove(o);
	}
	
	/**
	 * 通知所有被绑定对象
	 */
	public function notify() : Void {
		var i:Number = _observers.size();
		var _iterator:Iterator = _observers.iterator();
		while(--i-(-1)){
			if(_iterator.hasNext()){
				_iterator.next().Update(this);
			}
		}
	}
	/**
	 * 获取但前窗口状态
	 */
	public function getWindowState() : String {
		return _state;
	}
	/**
	 * 设置但前窗口状态
	 * state:String - 有以下一种值：
	 * <li>restore</li>
	 * <li>maximum</li>
	 * <li>minimum</li>
	 */
	public function setWindowState(state:String):Void{
		_state = state;
		changeState(null,_state);
	}
	
	/**
	 * 获取当前可用大小
	 */
	public function getState() : Object {
		return _stateBySize;
	}
	
	/**
	 * 设置当前可用大小
	 */
	public function setState(o : Object) {
		_stateBySize = Dimension(o);
	}

	/**
	 * 获取和设置文字标题
	 * @param  value:String -文字标题
	 * @return String
	 */
	public function set title(value:String) :Void
	{
		_label.text = value;
	}
	public function get title() :String
	{
		return _label.text;
	}
	
	
	/**
	 * 获取和设置窗口显示类型
	 * @param  value:String - 窗口显示类型
	 * <li>None : 没有任何可操作按钮</li>
	 * <li>Closed : 大小固定的，只有关闭按钮</li>
	 * <li>Fixed : 大小固定的，只有关闭按钮和最小化的</li>
	 * <li>Sizable : 大小相当，可以调整的</li>
	 * @return String 
	 */
	public function set windowType(value:String) :Void
	{
		_windowType = value;
		UpdateButtonState();
		
//		this.UpdateSkin();
//		var b:MovieClip = MovieClip(_skin.getElement("WindowTop"));
//		if(_windowType != "None"){
//			b.onPress = Delegate.create(this,startDrag);
//			b.onRelease = Delegate.create(this,stopDrag);
//			b.onReleaseOutside = Delegate.create(this,stopDrag);
//		}else{
//			b.onPress = null;
//			b.onRelease = null;
//			b.onReleaseOutside = null;
//			delete b.onPress;
//			delete b.onRelease;
//			delete b.onReleaseOutside;
//		}
	}
	public function get windowType() :String
	{
		return _windowType;
	}
	
	/**
	 * 设置要在窗口中显示的内容的名称
	 * @param path:String -  内容的名称
	 */
	public function set contentPath(path:String):Void{
		__contentPath = path;
		_content = this.getPanel().attachMovie(path,path,this.getPanel().getNextHighestDepth());
	}
	public function get contentPath():String{
		return __contentPath;
	}
	/**
	 * 设置要在窗口中显示的内容的名称
	 * @param path:String -  内容的名称
	 */
	public function get content():MovieClip{
		return _content;
	}
	/**
	 * 改变状态
	 */
	private function changeState(e:ButtonEvent,state:String):Void{
		setFocus();
		if(state == "maximum"){
			if(_state == "restore"){
				onMaximum();
			}else{
				onRevert();
			}
		}else if(state == "minimum"){
			onMinimum();
		}
		UpdateButtonState();
		this.dispatchEvent(new Event(Event.RESIZE,_state));
	}
	
	/** 还原窗口 */
	private function onRevert():Void{
		if(_state == "minimum" || _state == "maximum"){
			this.setBoundsofRectangle(Rectangle(_quondamRectangle.clone()));
		}
		_state = "restore";
	}
	
	/** 最小化窗口 */
	private function onMinimum():Void{
		if(_state == "restore"){
			_quondamRectangle = Rectangle(this.getBounds().clone());
			this.setSize(_minimumSize.getWidth(),_minimumSize.getHeight());
		}else{
			this.setSize(_minimumSize.getWidth(),_minimumSize.getHeight());
		}
		_state = "minimum";
	}
	
	/** 最大化窗口 */
	private function onMaximum():Void{
		if(_state == "restore"){
			_quondamRectangle = Rectangle(this.getBounds().clone());
			this.setLocation(0,0);
			this.setSizeByDimension(_maximumSize);
		}else{
			this.setLocation(0,0);
			this.setSize(_maximumSize.getWidth(),_maximumSize.getHeight());
		}
		_state = "maximum";
	}
		
	/** 拖动窗体 */
	private function startDrag():Void{
		setFocus();
		if(_state != "maximum"){
			getDisplayObject().startDrag();
		}
	}
	private function stopDrag():Void{
		getDisplayObject().stopDrag();
		this.setLocation(getDisplayObject()._x,getDisplayObject()._y);
		//更新原来记录的位置
		_quondamRectangle.setLocation(getDisplayObject()._x,getDisplayObject()._y);
	}
	
	/** 改变大小 */
	private function startChangeSize() : Void {
		setFocus();
		if(_state == "restore"){
			if(!_isDrag){
				var left = this.getMinimumSize().getWidth()-16;
				var right = this.getMaximumSize().getWidth()-16;
				var top = this.getMinimumSize().getHeight()-19;
				var buttom = this.getMaximumSize().getHeight()-19;
				_size_but.getDisplayObject().startDrag(false,left,top,right,buttom);
				_size_but.getDisplayObject().onMouseMove = Delegate.create(this,moveChangeSize);
				_isDrag = true;
			}
		}
	}
	private function moveChangeSize():Void{
		if(_isDrag){
			var w:Number  =_size_but.getDisplayObject()._x+16;
			var h:Number  =_size_but.getDisplayObject()._y+19;
			this.setSize(w,h);
		}
	}
	private function stopChangeSize() : Void {
		if(_isDrag){
			_size_but.getDisplayObject().stopDrag();
			moveChangeSize();
			_size_but.getDisplayObject().onMouseMove = null;
			delete _size_but.getDisplayObject().onMouseMove;
			_isDrag = false;
		}
	}
	
	/**
	 * 更新大小
	 */
	private function updataSize(){
		//更新大小给子对象
		setState(_skin.getUsableArea());
		notify();
	}
	
	//更新最大化窗口大小
	private function UpdateMaximumSize(){
		if(_domain_parent == _level0){
			_maximumSize = new Dimension(Stage.width,Stage.height);
		}else{
			_maximumSize = new Dimension(_domain_parent._width,_domain_parent._height);
		}
	}
	
	private function onClose() : Void {
		this.setVisible(false);
		this.dispatchEvent(new Event("click",null,this));
	}
	
	/**
	 * 改变按钮状态
	 */
	private function UpdateButtonState():Void{
		_close_but.setVisible(false);
		_max_but.setVisible(false);
		_min_but.setVisible(false);
		_size_but.setVisible(false);
		switch (_windowType) {
		    case "None":
		        break;
		    case "Closed":
		    	_close_but.setVisible(true);
		    	_close_but.angle = [1,1,1,1];
		        break;
		    case "Fixed":
		    	_close_but.setVisible(true);
				if(_state == "minimum"){
					 _min_but.setVisible(false);
					 _close_but.angle = [1,1,1,1];
				}else{
					_min_but.setVisible(true);
					_close_but.angle = [0,1,0,1];
				}
				_min_but.angle = [1,0,1,0];
		        break;
		    case "Sizable":
		    	_close_but.setVisible(true);
				_max_but.setVisible(true);
				if(_state == "minimum"){
					 _min_but.setVisible(false);
					 _size_but.setVisible(false);
					 _max_but.angle = [1,0,1,0];
				}else if(_state == "maximum"){
					 _min_but.setVisible(true);
					 _size_but.setVisible(false);
				}else{
					 _min_but.setVisible(true);
					 _size_but.setVisible(true);
					 _max_but.angle = [0,0,0,0];
				}
				_close_but.angle = [0,1,0,1];
				_min_but.angle = [1,0,1,0];
		}
	}
}