import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.core.ScrollPolicy;
import net.manaca.ui.controls.skin.IScrollSkin;
import net.manaca.ui.controls.ScrollbarY;
import net.manaca.ui.controls.ScrollbarX;
import net.manaca.lang.event.Event;
import net.manaca.util.Delegate;
import net.manaca.ui.controls.SimpleScrollbar;
/**
 * 滚动条值发生变化时抛出
 */
[Event("scroll")]
/**
 * 在显示区域需要更新时抛出
 */
[Event("viewChanged")]
/**
 * 水平滚动条状态发生改变时抛出
 */
[Event("horizontalScrollPolicyChanged")]
/**
 * 垂直滚动条状态发生改变时抛出
 */
[Event("verticalScrollPolicyChanged")]
/**
 * ScrollControlBase 提供一个基本的滚动条控制
 * @author Wersling
 * @version 1.0, 2006-6-3
 */
class net.manaca.ui.controls.core.ScrollControlBase extends UIComponent {
	private var className : String = "net.manaca.ui.controls.core.ScrollControlBase";
	private var _skin:IScrollSkin;
	private var _horizontalScrollPosition : Number = 0;
	private var _horizontalScrollPolicy : String = ScrollPolicy.OFF;
	private var _verticalScrollPosition : Number = 0;
	private var _verticalScrollPolicy : String = ScrollPolicy.AUTO;
	private var _maxHorizontalScrollPosition : Number;
	private var _maxVerticalScrollPosition : Number;
	
	private var _horizontalScrollbar : ScrollbarX;
	private var _verticalScrollbar : ScrollbarY;
	private var __scrollHandler:Function;
	/**
	 * 是否显示滚动条提示，默认 false
	 */
	public var showScrollTips:Boolean = false;
	
	public function ScrollControlBase(target : MovieClip, new_name : String) {
		super(target, new_name);
		__scrollHandler = Delegate.create(this,scrollHandler);
	}
	
	/**
	 * 设置滚动条
	 * @param totalColumns:Number - 总列数
	 * @param visibleColumns:Number - 可见列数
	 * @param totalRows:Number - 总行数
	 * @param visibleRows:Number - 可见行数
	 */
	public function setScrollBarProperties(totalColumns:Number, visibleColumns:Number,totalRows:Number, visibleRows:Number):Void{
		if(! _horizontalScrollbar) _horizontalScrollbar = createHScrollBar();
		if(! _verticalScrollbar) _verticalScrollbar = createVScrollBar();
		//处理垂直滚动条
		if((totalRows > visibleRows && verticalScrollPolicy == ScrollPolicy.AUTO) || verticalScrollPolicy == ScrollPolicy.ON){
			_verticalScrollbar.setVisible(true);
			_verticalScrollbar.setScrollProperties(visibleRows,0,totalRows);
			_verticalScrollbar.scrollPosition = _verticalScrollPosition;
		}else if(verticalScrollPolicy == ScrollPolicy.OFF || totalRows <= visibleRows){
			_verticalScrollbar.setVisible(false);
			_verticalScrollbar.scrollPosition = 0;
		}
		if((totalColumns > visibleColumns && horizontalScrollPolicy == ScrollPolicy.AUTO) || horizontalScrollPolicy == ScrollPolicy.ON){
			_horizontalScrollbar.setVisible(true);
			_horizontalScrollbar.setScrollProperties(visibleColumns,0,totalColumns);
			_horizontalScrollbar.scrollPosition = _horizontalScrollPosition;
		}else if(horizontalScrollPolicy == ScrollPolicy.OFF || totalColumns <= visibleColumns){
			_horizontalScrollbar.setVisible(false);
			_horizontalScrollbar.scrollPosition = 0;
		}
		updateDisplayScroll(this.getSize().getWidth(),this.getSize().getHeight());
	}
	
	/**
	 * 更新滚动条
	 * @param width:Number - 显示区域宽度
	 * @param height:Number - 显示区域高度
	 */
	public function updateDisplayScroll(width:Number,height:Number){
		if(_verticalScrollbar.getVisible() && _horizontalScrollbar.getVisible()){
			_verticalScrollbar.setSize(_verticalScrollbar.getSize().getWidth(),height-_verticalScrollbar.getSize().getWidth());
			_horizontalScrollbar.setSize(width - _horizontalScrollbar.getSize().getHeight(),_horizontalScrollbar.getSize().getHeight());
			_verticalScrollbar.setLocation(width-_verticalScrollbar.getSize().getWidth(),0);
			_horizontalScrollbar.setLocation(0,height - _horizontalScrollbar.getSize().getHeight());
		}else if(_verticalScrollbar.getVisible() && !_horizontalScrollbar.getVisible()){
			_verticalScrollbar.setSize(_verticalScrollbar.getSize().getWidth(),height);
			_verticalScrollbar.setLocation(width-_verticalScrollbar.getSize().getWidth(),0);
		}else if(!_verticalScrollbar.getVisible() && _horizontalScrollbar.getVisible()){
			_horizontalScrollbar.setSize(width,_horizontalScrollbar.getSize().getHeight());
			_horizontalScrollbar.setLocation(0,height - _horizontalScrollbar.getSize().getHeight());
		}
	}
	
	/**
	 * 获取和设置水平滚动条位置，默认 0
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set horizontalScrollPosition(value:Number) :Void{
		if (_horizontalScrollbar != value){
			_horizontalScrollPosition = value;
			_horizontalScrollbar.scrollPosition = value;
			
			dispatchEvent(new Event("viewChanged"));
		}
	}
	public function get horizontalScrollPosition() :Number{
		return _horizontalScrollPosition;
	}
	
	/**
	 * 获取和设置水平滚动条 是 显示 ("on")、不显示 ("off") 还是在需要时显示 ("auto")，默认 {@see net.manaca.ui.controls.core.ScrollPolicy#OFF}
	 * @param  value:String - 
	 * @return String 
	 */
	public function set horizontalScrollPolicy(value:String) :Void{
		var newPolicy:String = value;
		if(newPolicy != _horizontalScrollPolicy){
			_horizontalScrollPolicy = value;
			updateDisplayScroll(this.getSize().getWidth(),this.getSize().getHeight());
			dispatchEvent(new Event("horizontalScrollPolicyChanged"));
		}
	}
	public function get horizontalScrollPolicy() :String{
		return _horizontalScrollPolicy;
	}
	
	/**
	 * 获取和设置垂直滚动条位置，默认 0
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set verticalScrollPosition(value:Number) :Void{
		if (_verticalScrollPosition != value){
			_verticalScrollPosition = value;
			_verticalScrollbar.scrollPosition = value;
		
			dispatchEvent(new Event("viewChanged"));
		}
	}
	public function get verticalScrollPosition() :Number{
		return _verticalScrollPosition;
	}
	
	/**
	 * 获取和设置垂直滚动条 是 显示 ("on")、不显示 ("off") 还是在需要时显示 ("auto")，默认 {@see net.manaca.ui.controls.core.ScrollPolicy#AUTO}
	 * @param value:String 
	 * @return String
	 */
	public function set verticalScrollPolicy(value:String):Void{
		var newPolicy:String = value;
		if(newPolicy != _verticalScrollPolicy){
			_verticalScrollPolicy = value;
			updateDisplayScroll(this.getSize().getWidth(),this.getSize().getHeight());
			dispatchEvent(new Event("verticalScrollPolicyChanged"));
		}
	}
	public function get verticalScrollPolicy(): String{
		return _verticalScrollPolicy;
	}
	
	/**
	 * 获取和设置最大的水平滚动位置
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set maxHorizontalScrollPosition(value:Number) :Void{
		_maxHorizontalScrollPosition = value;
	}
	public function get maxHorizontalScrollPosition() :Number{
		return _maxHorizontalScrollPosition;
	}
	
	/**
	 * 获取和设置最大的垂直滚动位置
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set maxVerticalScrollPosition(value:Number) :Void{
		_maxVerticalScrollPosition = value;
	}
	public function get maxVerticalScrollPosition() :Number{
		return _maxVerticalScrollPosition;
	}
	/**
	 * 获取一个水平滚动条
	 */
	private function createHScrollBar():ScrollbarX{
		if(!_horizontalScrollbar){
			_horizontalScrollbar = _skin.getHScrollBar();
			_horizontalScrollbar.addEventListener(Event.SCROLL,__scrollHandler);
		}
		return _horizontalScrollbar;
	}
	/**
	 * 获取一个垂直滚动条
	 */
	private function createVScrollBar():ScrollbarY{
		if(!_verticalScrollbar){
			_verticalScrollbar = _skin.getVScrollBar();
			_verticalScrollbar.addEventListener(Event.SCROLL,__scrollHandler);
		}
		return _verticalScrollbar;
	}
	
	/**
	 * 但滚动条值发生改变时
	 */
	private function scrollHandler(event:Event) : Void {
		var scrollBar:SimpleScrollbar = SimpleScrollbar(event.target);
		var pos:Number = scrollBar.scrollPosition;
		
		if(scrollBar == _horizontalScrollbar){
			horizontalScrollPosition = pos;
		}
		if(scrollBar == _verticalScrollbar){
			verticalScrollPosition = pos;
		}
		//this.dispatchEvent(event);
	}
}