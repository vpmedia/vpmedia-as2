import net.manaca.ui.controls.skin.IScrollbarSkin;
import net.manaca.ui.controls.skin.SkinFactory;
import net.manaca.ui.awt.Dimension;
import net.manaca.lang.event.ButtonEvent;
import net.manaca.util.Delegate;
import net.manaca.lang.event.Event;
import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.skin.mnc.ScrollbarSkin;
import net.manaca.ui.controls.IContainers;

/**
 * 抽象的滚动条对象，定义一个滚动条所需要的方法
 * @author Wersling
 * @version 1.0, 2006-5-18
 */
class net.manaca.ui.controls.SimpleScrollbar extends UIComponent {
	private var className : String = "net.manaca.ui.controls.SimpleScrollbar";
	private var _scrollPosition : Number = 0;
	private var _lineScrollSize : Number = 1;
	private var _pageScrollSize : Number;
	private var _pageSize : Number = 10;
	private var _minPos : Number = 0;
	private var _maxPos : Number = 100;
	//是否拖动
	private var _isDrag : Boolean = false;
	private function SimpleScrollbar(target : MovieClip, new_name : String) {
		super(target, new_name);
	}
	
	private function updateDragButton(){
	}
	/**
	 * 设置滚动条的每页显示值、最大滚动值和最小滚动值
	 * @param pageSize:Number - 每页显示值
	 * @param minPos:Number - 最小滚动值
	 * @param maxPos:Number - 最大滚动值
	 */
	public function setScrollProperties(pageSize:Number,minPos:Number, maxPos:Number):Void{
		minPos = Math.max(minPos, 0);
		maxPos = Math.max(maxPos,0);
		pageSize = pageSize > 0 ? pageSize : 1;

		if(minPos != _minPos || maxPos != _maxPos || pageSize != _pageSize){
			_minPos = minPos;
			_maxPos = maxPos;
			_pageSize = pageSize;
			
			if(scrollPosition >= (_maxPos - _minPos-_pageSize) && (_maxPos - _minPos-_pageSize) >= 0){
				_scrollPosition = (_maxPos - _minPos-_pageSize);
				this.dispatchEvent(new Event(Event.SCROLL,_scrollPosition,this));
			}
			
			updateDragButton();
		}
	}
	
	/**
	 * 获取和设置当用户单击滚动条的箭头按钮时滚动的行数或像素数，默认值为 1
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set lineScrollSize(value:Number) :Void
	{
		_lineScrollSize = value;
	}
	public function get lineScrollSize() :Number
	{
		return _lineScrollSize;
	}
	
	/**
	 * 获取和设置当用户单击滚动条的轨道时滚动的行数或像素数，默认值为 1
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set pageScrollSize(value:Number) :Void
	{
		_pageScrollSize = value;
	}
	public function get pageScrollSize() :Number
	{
		return _pageScrollSize;
	}
	
	/**
	 * 获取和设置滚动条当前的滚动位置
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set scrollPosition(value:Number) :Void{
		if(_scrollPosition != value) {
			_scrollPosition = value;
			this.dispatchEvent(new Event(Event.SCROLL,_scrollPosition,this));
			if(!_isDrag) updateDragButton();
		}
	}
	public function get scrollPosition() :Number{
		return _scrollPosition;
	}
	/**
	 * 获取下一个可以滚动的值。该属性为只读
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function get nextScroll() :Number{
		if(scrollPosition + lineScrollSize >= (_maxPos - _pageSize)){
			var _v = _maxPos-_pageSize;
			return _v > _minPos ? _v : _minPos;
		}else{
			return scrollPosition + lineScrollSize;
		}
	}
	/**
	 * 获取上一个可以滚动的值。该属性为只读
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function get previousScroll() :Number{
		if(scrollPosition - lineScrollSize < _minPos){
			return _minPos;
		}else{
			return scrollPosition - lineScrollSize;
		}
	}
	/**
	 * 更新组件
	 */
	public function setSize(width:Number,height:Number):Void{
		super.setSize(width,height);
		updateDragButton();
	}
	
	/**
	 * 更新组件
	 */
	public function Update(o:IContainers):Void{
		var _size:Dimension = Dimension(o.getState());
		this.setSize(this.getSize().getWidth(),_size.getHeight());
	}
}