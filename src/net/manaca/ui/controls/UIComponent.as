import flash.filters.ColorMatrixFilter;
import net.manaca.lang.BObject;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.lang.exception.IllegalStateException;
import net.manaca.manager.ToolTipManager;
import net.manaca.ui.awt.Dimension;
import net.manaca.ui.awt.Point;
import net.manaca.ui.awt.Rectangle;
import net.manaca.ui.controls.ComponentManager;
import net.manaca.ui.controls.skin.ISkin;
import net.manaca.ui.controls.themes.Themes;
import net.manaca.ui.controls.themes.ThemesManager;
import net.manaca.ui.font.Fonts;
import net.manaca.util.MovieClipUtil;
import net.manaca.util.Delegate;
import net.manaca.lang.event.FocusEvent;
import net.manaca.manager.FocusManager;
import net.manaca.util.ColorUtil;
import net.manaca.data.list.ArrayList;
import net.manaca.data.Iterator;
import net.manaca.lang.event.Event;
/**
 * 当大小发生变化时
 */
[Event(Event.RESIZE)]
/**
 * 当位置发生改变时
 */
[Event("move")]
/**
 * 一个具有图形表示能力的对象，可在屏幕上显示，并可与用户进行交互，大量的组件都继承此类
 * @author Wersling
 * @version 1.0, 2006-4-5
 */
class net.manaca.ui.controls.UIComponent extends BObject {
	private var className : String = "net.manaca.ui.controls.Component";
	static var UPDATE_THEMES:String = "updateThemes";
	private var _domain_parent:MovieClip;
	private var _domain:MovieClip;
	//皮肤
	private var _skin : ISkin;
	//主题
	private var _themes : Themes;
	//组件名称
	private var _componentName : String;
	private var _toolTip : String;
	private var _toolTipShow : Boolean;
	//文本格式化
	private var _textFormat : TextFormat;
	private var _maximumSize : Dimension;
	private var _minimumSize : Dimension;
	private var _preferredSize : Dimension;
	private var _enabled : Boolean;
	private var _rectangle : Rectangle;
	private var _isFocus : Boolean;
//	private var _childComponentList : ArrayList;
	private var _enabled_mc:MovieClip;

	private var _font : String;

	private var _focusEnabled : Boolean;
	//基本文本颜色是否被改变
	private var _alterant_text_color : Boolean = false;
	/**
	 * 构造一个 UIComponent
	 */
	private function UIComponent(target:MovieClip,new_name:String) {
		super();
		_domain_parent = target;
		if(target != undefined && new_name != undefined){
			_domain = target.createEmptyMovieClip(new_name,target.getNextHighestDepth());
		}else{
			throw new IllegalArgumentException("在建立"+new_name+"组件时缺少必要参数",this,arguments);
		}
		//_domain._focusrect = false;
//		_domain.onKillFocus = Delegate.create(this,onKillFocus);
//		_domain.onSetFocus = Delegate.create(this,onSetFocus);
		ComponentManager.register(this);
		_domain.useHandCursor = false;
		//_domain.focusrect = false;
		//_domain.tabChildren = false;
		_toolTipShow = true;
		_enabled  = false;
		_rectangle = new Rectangle(0,0);
//		_childComponentList = new ArrayList();
		focusEnabled(true);
		
		_textFormat = new TextFormat();
	}
	
//	/**
//	 * 添加子组件
//	 */
//	public function addChildComponent(c : UIComponent) : Void {
//		_childComponentList.push(c);
//	}
//	
//	/**
//	 * 获取指定ID的子组件
//	 */
//	public function getChildComponent(id : Number) : UIComponent {
//		return UIComponent(_childComponentList.getItemAt(id));
//	}
//	
//	/**
//	 * 删除一个子组件
//	 */
//	public function removeChildComponent(c : UIComponent) : Void {
//		_childComponentList.remove(c);
//	}
	
	/**
	 * 检查组件是否“包含”指定的点，其中 x 和 y 是相对于此组件的坐标系统定义的。
	 * @param x x位置
	 * @param y y位置
	 * @return Boolean
	 */
	public function contains(x:Number, y:Number):Boolean{
		return null;
	}
	
	/**
	 * 布局此组件
	 */
	public function doLayout():Void{
	}
	

	/**
	 * 返回 x 轴的对齐方式。
	 */
	public function getAlignmentX():Number{
		return null;
	}
	
	/**
	 * 返回 y 轴的对齐方式。
	 */
	public function getAlignmentY():Number{
		return null;
	}
	
	/**
	 * 获得组件的背景色。
	 */
	public function getBackground():Number{
		return null;
	}
	
	/**
	 * 以 Rectangle 对象的形式获得组件的边界
	 * @return Rectangle
	 */
	public function getBounds():Rectangle{
		return _rectangle;
	}
	
	public function getDisplayObject():MovieClip{
		return _domain;
	}

	/**
	 * 获得组件的字体
	 * @return Font
	 */
	public function getFont():String{
		return (_font != undefined) ? _font :  getThemes().fontName;
	}
	
	/**
	 * 获得组件的位置，形式是指定组件左上角的一个点。
	 * @return Point
	 */
	public function getLocation():Point{
		return _rectangle.getLocation();
	}
	
	/**
	 * 获得组件的最大尺寸。
	 * @return Dimension
	 */
	public function getMaximumSize():Dimension{
		return _maximumSize;
	}
	
	/**
	 * 获得组件的最小尺寸。
	 * @return Dimension
	 */
	public function getMinimumSize():Dimension{
		return _minimumSize;
	}
	
	/**
	 * 获得组件的首选大小。
	 * @return Dimension
	 */
	public function getPreferredSize():Dimension{
		return _preferredSize;
	}
	
	/**
	 * 获得组件的名称。
	 * @return String
	 */
	public function getName():String{
		return _componentName;
	}
	
	/**
	 * 以 Dimension 对象的形式返回组件的大小。
	 */
	public function getSize():Dimension{
		if(_rectangle.isEmpty()) _rectangle.setSizeByDimension(this.getPreferredSize());
		return _rectangle.getSize();
	}
	
	/**
	 * 获取主题
	 */
	public function getThemes():Themes{
		return (_themes != undefined) ? _themes : ThemesManager.getThemes(this.getName());
	}
	
	/**
	 * 获取文本格式化对象
	 */
	public function getTextFormat():TextFormat{
//		if(_textFormat == undefined){
//			 var _tf:TextFormat = new TextFormat();
//			 _tf.font = this.getFont();
//			 _tf.size = 12;
//			 _tf.color = getThemes().ControlText;
//			 return _tf;
//		}else{
//			if(!_alterant_text_color) _textFormat.color = getThemes().ControlText;
//		}
		return _textFormat;
	}
	/**
	 * 确定此组件是否已启用。
	 */
	public function isEnabled():Boolean{
		return _enabled;
	}
	
	/**
	 * 返回此 Component 是否可以获得焦点
	 */
	public function isFocusable():Boolean{
		return null;
	}
	
	/**
	 * 绘制此组件。
	 */
	public function paint():Void{
		if(_skin){
			_skin.initialize(this);
			_skin.paint();
		}else{
			throw new IllegalStateException("在绘制组件时缺少必要的皮肤库",this,arguments);
		}
	}
	
	/**
	 * 绘制此组件的所有子组件。
	 */
	public function paintAll() : Void {
		if(_skin){
			_skin.initialize(this);
			_skin.paintAll();
		}else{
			throw new IllegalStateException("在绘制组件时缺少必要的皮肤库",this,arguments);
		}
	}
	
	/**
	 * 重绘此组件的所有子组件。
	 */
	public function repaintAll() : Void {
		if(_skin){
			_skin.repaintAll();
		}else{
			throw new IllegalStateException("在绘制组件时缺少必要的皮肤库",this,arguments);
		}
	}
	
	/**
	 * 重绘此组件。
	 */
	public function repaint():Void{
		if(_skin){
			_skin.repaint();
		}else{
			throw new IllegalStateException("在绘制组件时缺少必要的皮肤库",this,arguments);
		}
	}
	
	/**
	 * 删除此组件
	 */
	public function remove():Void{
		MovieClipUtil.remove(_domain);
		_skin = null;
		delete _skin;
		_themes = null;
		delete _themes;
	}
	/**
	 * 设置一个被绑定者，组件将获取它的位置及其大小，并删除这个被绑定者
	 * 此方法用于元件的可视化定位，你可以在Flash IDE中建立一个将被绑定的元件，然后指定到组件
	 * @param victim_mc:MovieClip - 被绑定者
	 */
	public function setBinding(victim_mc:MovieClip):Void{
		if(victim_mc instanceof MovieClip){
			this.setLocation(victim_mc._x,victim_mc._y);
			this.setSize(victim_mc._width,victim_mc._height);
			MovieClipUtil.remove(victim_mc);
		}
	}
	/**
	 * 移动组件并调整其大小
	 */
	public function setBounds(x:Number,y:Number,width:Number,height:Number):Void{
		setLocation(x,y);
		setSize(width,height);
	}
	
	/**
	 * 移动组件并调整其大小，使其符合新的有界矩形 r。
	 */
	public function setBoundsofRectangle(r:Rectangle):Void{
		setBounds(r.getX(),r.getY(),r.getWidth(),r.getHeight());
	}
	
	/**
	 * 根据参数 b 的值启用或禁用此组件。
	 */
	public function setEnabled(b:Boolean):Void{
		if(_enabled != b){
			_enabled = b;
			_domain.enabled = _enabled;
			if(!_enabled){
				onEnabled();
			}else{
				unEnabled();
			}
		}
	}

	/**
	 * 设置组件的字体
	 */
	public function setFont(f:String):Void{
		_font = f;
	}
	
	/**
	 * 将组件移到新位置。
	 */
	public function setLocation(x:Number,y:Number):Void{
		if(x != _rectangle.getX() || y != _rectangle.getY()){
			_rectangle.setLocation(x,y);
			updataLocation();
			this.dispatchEvent(new Event("move",_rectangle.getLocation(),this));
		}
	}
	/**
	 * 将组件移到新位置。
	 */
	public function setLocationOfPoint(p:Point):Void{
		setLocation(p.getX(),p.getY());
	}
	
	/**
	 * 将组件的名称设置为指定的字符串
	 */
	public function setName(name:String):Void{
		_componentName = name;
	}
	
	/**
	 * 将组件的首选大小设置为常量值。
	 */
	public function setPreferredSize(preferredSize:Dimension):Void{
		_preferredSize = preferredSize;
	}
	
	/**
	 * 调整组件的大小，使其宽度为 width，高度为 height
	 */
	public function setSize(width:Number,height:Number):Void{
		if(width != _rectangle.getWidth() || height != _rectangle.getHeight()){
			if(this.getMaximumSize() != undefined){
				var mw:Number = getMaximumSize().getWidth();
				var mh:Number = getMaximumSize().getHeight();
				width = Math.min(width,mw);
				height = Math.min(height,mh);
			}
			_rectangle.setSize(width,height);
			_skin.updateSize();
			updataSize();
			this.dispatchEvent(new Event(Event.RESIZE,_rectangle.getSize(),this));
		}
	}
	
	/**
	 * 调整组件的大小，使其宽度为 d.width，高度为 d.height。
	 */
	public function setSizeByDimension(d:Dimension){
		setSize(d.getWidth(),d.getHeight());
	}
	
	/**
	 * 设置组件主题
	 */
	public function setThemes(t:Themes):Void{
		if(t != undefined && _themes != t) {
			_themes = t;
			_skin.updateThemes();
			this.dispatchEvent(new Event(UPDATE_THEMES));
		}
	}
	
	/**
	 * 设置文本格式化对象
	 */
	public function setTextFormat(textFormat:TextFormat):Void{
		_textFormat = textFormat;
		_skin.updateTextFormat();
	}
	
	/**
	 * 获取组件皮肤
	 */
	public function getSkin():ISkin{
		return _skin;
	}
	/**
	 * 设置组件皮肤
	 */
	public function setSkin(skin:ISkin):Void{
		_skin = skin;
		paint();
	}
	/**
	 * 获取但前焦点对象
	 */
	public function getFocus():UIComponent{
		return FocusManager.getInstance().getFocus();
	}
	/**
	 * 设置当前对象为具有焦点
	 */
	public function setFocus():Void{
		FocusManager.getInstance().setFocus(this);
		//Selection.setFocus(_domain);
	}
	
	/** 失去焦点时触发 */
	public function onKillFocus(newFocus:UIComponent):Void{
		this.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT,newFocus,this));
		_isFocus = false;
	}
	
	/** 获得时触发 */
	public function onSetFocus(oldFocus:UIComponent):Void{
		this.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_IN,oldFocus,this));
		_isFocus = true;
	}
	
	public function isFocus():Boolean{
		return _isFocus;
	}
	
	/**
	 * 获取和设置 是否获得输入焦点
	 * @param  value:Boolean - 
	 * @return Boolean 
	 */
	public function set focusEnabled(value:Boolean) :Void{
		_focusEnabled = value;
		if(_focusEnabled){
			_domain.onKillFocus = Delegate.create(this,onKillFocus);
			_domain.onSetFocus = Delegate.create(this,onSetFocus);
			_domain.tabEnabled = true;
			_domain.focusEnabled = true;
		}else{
			_domain.onKillFocus = null;
			delete _domain.onKillFocus;
			_domain.onSetFocus = null;
			delete _domain.onSetFocus;
			_domain.tabEnabled = false;
			_domain.focusEnabled = false;
		}
	}
//	
//	private function findFocusInChildren(o:Object):Object{
//		if (o.focusTextField != undefined)
//		{
//			return o.focusTextField;
//		}
//		if (o.tabEnabled == true)
//			return o;
//
//		return undefined;
//	}
//	private function findFocusFromObject(o:Object):Object{
//		if (o.tabEnabled != true)
//		{
//			if (o._parent == undefined)
//				return undefined;
//			if (o._parent.tabEnabled == true)
//				o = o._parent;
//			else if (o._parent.tabChildren)
//				o = findFocusInChildren(o._parent);
//			else
//				o = findFocusFromObject(o._parent);
//		}
//		return o;
//	}
	public function get focusEnabled() :Boolean{
		return _focusEnabled;
	}
	/**
	 * 设置组件是否可见
	 */
	public function setVisible(b:Boolean):Void{
		_domain._visible = b;
	}
	
	/**
	 * 获取组件是否可见
	 */
	public function getVisible():Boolean{
		return _domain._visible;
	}
	
	/**
	 * 更新，用于观察者模式，获取通知
	 */
	public function Update(o):Void{
		
	}
	
	/**
	 * 设置提示文字
	 * @param  value  参数类型：String 
	 * @return 返回值类型：String 
	 */
	public function set toolTip(value:String) :Void{
		if(_toolTip.length == undefined) {
			ToolTipManager.getInstance().push(_domain,value);
		}
		
		if(_toolTip.length < 1){
			ToolTipManager.getInstance().remove(_domain);
		}
	}
	public function get toolTip() :String{
		return _toolTip;
	}
	/**
	 * 是否显示提示
	 * @param  value  参数类型：Boolean 
	 * @return 返回值类型：Boolean 
	 */
	public function set toolTipShow(value:Boolean) :Void
	{
		_toolTipShow = value;
	}
	public function get toolTipShow() :Boolean
	{
		return _toolTipShow;
	}
	
	/**
	 * 处理组件的部分方法，这个方法可以在需要的时候重构，从而减少重复代码
	 */
	private function commitProperties():Void{
		
	}
	
	private function updataLocation():Void{
		_domain._x = _rectangle.getX();
		_domain._y = _rectangle.getY();
	}

	/** 在组件被禁用的时候触发 */
	private function onEnabled():Void{
		_enabled_mc = _domain._parent.createEmptyMovieClip("_enabled_mc",_domain._parent.getNextHighestDepth());
		_enabled_mc.useHandCursor = false;
		_enabled_mc._x =this.getLocation().getX();
		_enabled_mc._y =this.getLocation().getY();
		_enabled_mc._alpha = 0;
		var _w = this.getSize().getWidth();
		var _h = this.getSize().getHeight();
		_enabled_mc.beginFill(0xFF0000);
		_enabled_mc.moveTo(0, 0);
		_enabled_mc.lineTo(_w, 0);
		_enabled_mc.lineTo(_w, _h);
		_enabled_mc.lineTo(0, _h);
		_enabled_mc.lineTo(0, 0);
		_enabled_mc.endFill();
		_enabled_mc.onRelease = function() {};
		_domain.filters = [new ColorMatrixFilter(ColorUtil.adjustDesaturate(0.2))];
		
	}
	/** 在组件取消禁用的时候触发 */
	private function unEnabled():Void{
		MovieClipUtil.remove(_enabled_mc);
		_domain.filters = [new ColorMatrixFilter(ColorUtil.adjustDesaturate(1))];
	}	
	private function updataSize() : Void {
		
	}

}