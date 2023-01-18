import net.manaca.ui.controls.skin.ITextAreaSkin;
import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.awt.Dimension;
import net.manaca.lang.event.Event;
import net.manaca.util.Delegate;
import net.manaca.ui.controls.IContainers;
import TextField.StyleSheet;
import net.manaca.ui.controls.skin.mnc.TextAreaSkin;
import net.manaca.ui.controls.ScrollbarX;
import net.manaca.ui.controls.ScrollbarY;
import net.manaca.ui.controls.core.ScrollControlBase;
import net.manaca.ui.controls.core.ScrollPolicy;
/** 通知侦听器文本已更改 */
[Event("change")]
/** 通知侦听器文本已滚动 */
[Event("scroll")]
/**
 * TextArea 类的属性使您能够在运行时设置文本内容、格式以及水平和垂直位置
 * @author Wersling
 * @version 1.0, 2006-5-18
 */
class net.manaca.ui.controls.TextArea extends ScrollControlBase {
	private var className : String = "net.manaca.ui.controls.TextArea";
	private var _skin:ITextAreaSkin;
	private var _editable : Boolean  = true;
	private var _label:TextField;
	public function TextArea(target:MovieClip,new_name:String) {
		super(target,new_name);
		_preferredSize = new Dimension(100,100);
		_skin = new TextAreaSkin();
		
		this.paintAll();
		
		init();
	}
	
	private function init() : Void {
		_horizontalScrollbar = this.createHScrollBar();
		_horizontalScrollbar.lineScrollSize = 10;
		_verticalScrollbar = this.createVScrollBar();
		_verticalScrollbar.lineScrollSize = 1;

		
		_label = _skin.getLabel();
		_label.autoSize = false;
		_label.html = false;
		_label.multiline = true;
		_label.password = false;
		_label.scroll = 0;
		_label.selectable = true;
		_label.onChanged = Delegate.create(this,onChanged);
		_label.wordWrap = true;
		editable = _editable;
		_label.text = "";
		_label.onKillFocus = Delegate.create(this,onKillFocus);
		_label.onSetFocus = Delegate.create(this,onSetFocus);
		
		this.addEventListener("viewChanged",Delegate.create(this,onScrollChanged));
		onChanged();
	}
	
	private function onChanged() : Void {
		_label.text += "";
		
		var _visibleRows = _label.bottomScroll - _label.scroll + 1;
		var _totalRows = _label.maxscroll + _visibleRows-1;
		var _visibleColumns = _label._width;
		var _totalColumns = _label.maxhscroll + _visibleColumns;
		this.setScrollBarProperties(_totalColumns,_visibleColumns,_totalRows,_visibleRows);
		
		this.verticalScrollPosition = _label.bottomScroll-_visibleRows;
		this.dispatchEvent(new Event("change",text,this));
	}
	
	private function onScrollChanged() : Void {
		_label.hscroll = this._horizontalScrollPosition;
		_label.scroll = this._verticalScrollPosition +1;
	}

	/**
	 * 获取和设置该字段是 (true) 否 (false) 可编辑
	 * @param  value:Boolean - 
	 * @return Boolean 
	 */
	public function set editable(value:Boolean) :Void
	{
		_editable = value;
		_label.type = (_editable) ? "input" :  "dynamic";
	}
	public function get editable() :Boolean
	{
		return _editable;
	}
	/**
	 * 获取和设置文本区域的内容是否可以采用 HTML 格式,默认值为 false
	 * @param  value:Boolean - 
	 * @return Boolean 
	 */
	public function set html(value:Boolean) :Void
	{
		_label.html = value;
	}
	public function get html() :Boolean
	{
		return _label.html;
	}
	
	/**
	 * 获取文本区域中的字符数
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function get length() :Number
	{
		return _label.length;
	}
	
	/**
	 * 获取和设置文本区域最多可以容纳的字符数，默认为 null
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set maxChars(value:Number) :Void{
		_label.maxChars = value;
	}
	public function get maxChars() :Number{
		return _label.maxChars;
	}
	
	/**
	 * 获取 TextArea.hPosition 的最大值
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function get maxHPosition() :Number{
		return _label.maxhscroll;
	}
	
	/**
	 * 获取 TextArea.vPosition 的最大值
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function get maxVPosition() :Number{
		return _label.maxscroll;
	}
	
	/**
	 * 获取和设置指示字段是 (true) 否 (false) 为密码字段，默认为 false
	 * @param  value:Boolean - 
	 * @return Boolean 
	 */
	public function set password(value:Boolean) :Void{
		_label.password = value;
	}
	public function get password() :Boolean{
		return _label.password;
		
	}
	
	/**
	 * 获取和设置用户可在文本区域中输入的字符集，默认为 null
	 * @param  value:String - 
	 * @return String 
	 */
	public function set restrict(value:String) :Void{
		_label.restrict = value;
	}
	public function get restrict() :String
	{
		return _label.restrict;
	}
	
	/**
	 * 获取和设置文本内容
	 * @param  value:String - 
	 * @return String 
	 */
	public function set text(value:String) :Void{
		_label.text = value;
		this.onChanged();
	}
	public function get text() :String{
		return _label.text;
	}
	
	/**
	 * 获取和设置文本样式表
	 * @param  value:StyleSheet - 文本样式表
	 * @return StyleSheet 
	 */
	public function set styleSheet(value:StyleSheet) :Void
	{
		_label.styleSheet = value;
	}
	public function get styleSheet() :StyleSheet
	{
		return _label.styleSheet;
	}

	/**
	 * 获取和设置文本是 (true) 否 (false) 自动换行,默认值为 true
	 * @param  value:Boolean - 
	 * @return Boolean 
	 */
	public function set wordWrap(value:Boolean) :Void{
		_label.wordWrap = value;
		this.horizontalScrollPolicy = value ? ScrollPolicy.OFF : ScrollPolicy.AUTO;
		onChanged();
	}
	public function get wordWrap() :Boolean{
		return _label.wordWrap;
	}
	
	/**
	 * 更新组件
	 */
	public function Update(o:IContainers):Void{
		var s:Dimension = Dimension(o.getState());
		this.setSize(s.getWidth(),s.getHeight());
		onChanged();
	}
	
	//更新滚动条位置及其文本大小
	public function updateDisplayScroll(width:Number,height:Number){
		if(_verticalScrollbar.getVisible() && _horizontalScrollbar.getVisible()){
			_label._width = width-16;
			_label._height = height-16;
		}else if(_verticalScrollbar.getVisible() && !_horizontalScrollbar.getVisible()){
			_label._width = width-16;
			_label._height = height;
		}else if(!_verticalScrollbar.getVisible() && _horizontalScrollbar.getVisible()){
			_label._width = width;
			_label._height = height-16;
		}else{
			_label._width = width;
			_label._height = height;
		}
		super.updateDisplayScroll(width,height);
	}
}