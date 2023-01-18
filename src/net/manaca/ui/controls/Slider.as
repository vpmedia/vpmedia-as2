import net.manaca.ui.controls.UIComponent;

/**
 * 滑动组件
 * @author Wersling
 * @version 1.0, 2006-5-19
 */
class net.manaca.ui.controls.Slider extends UIComponent {
	private var className : String = "net.manaca.ui.controls.Slider";

	private var _horizontal : Boolean;

	private var _scrollPosition : Number;

	private var _minPos : Number;
	private var _maxPos : Number;
	public function Slider(target : MovieClip, new_name : String) {
		super(target, new_name);
	}
	/**
	 * 设置滑动条的每页最大滚动值和最小滚动值
	 * @param minPos:Number - 最小滚动值
	 * @param maxPos:Number - 最大滚动值
	 */
	public function setScrollProperties(minPos:Number, maxPos:Number):Void{
		_minPos = Math.max(minPos, 0);
		_maxPos = Math.max(maxPos,0);
		UpdateDrag_but();
	}
	/**
	 * 获取和设置滚动条是垂直方向 (false)（默认）还是水平方向 (true)。默认值为 false。
	 * @param  value:Boolean - 
	 * @return Boolean 
	 */
	public function set horizontal(value:Boolean) :Void
	{
		_horizontal = value;
		this.UpdateSkin();
	}
	public function get horizontal() :Boolean
	{
		return _horizontal;
	}
	
	/**
	 * 获取和设置滚动条当前的滚动位置
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set scrollPosition(value:Number) :Void
	{
		_scrollPosition = value;
//		this.dispatchEvent(new Event(Event.SCROLL,_scrollPosition));
//		if(!_isDrag)UpdateDrag_but();
	}
	public function get scrollPosition() :Number
	{
		return _scrollPosition;
	}
	
	/**
	 * 更新组件
	 */
	public function setSize(width:Number,height:Number):Void{
		super.setSize(width,height);
		UpdateDrag_but();
	}
	private function UpdateDrag_but() : Void {
		
	}

	private function UpdateSkin() : Void {
		
	}

}