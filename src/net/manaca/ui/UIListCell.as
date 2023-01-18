/**
 * 显示一条数据
 * @author Wersling
 * @version 1.0, 2005-9-1
 */
import net.manaca.ui.UIObject;
import net.manaca.ui.UIList;
 
class net.manaca.ui.UIListCell extends UIObject {
	private var className : String = "net.manaca.ui.UIListCell";
	
	/* 数据 */
	private var _item:Object;
	/* 选项编号 -1 非法编号，将确定此条数据无效 */
	private var _index : Number;
	/* 所有者 */
	private var _owner : UIList;
	/* 是否被选择 */
	private var isChoose:Boolean;
	
	public function UIListCell() {
		super();
	}
	/* 广播事件，此处将传递this */
	/*private function onRelease():Void
	{
		if(!isChoose) dispatchEvent({type:"onListCellRelease",target:this});
		// 在这里设置当点击过后所触发的事件
	}*/
	/* 处理数据 */
	private function init():Void
	{
		super.init();
	}
	/* 设置数据 */
	public function set Item(item:Object):Void
	{
		_item = item;
		init(item);
	}
	public function get Item():Object
	{
		return _item;
	}
	/* 设置数据编号 */
	public function set Index(In:Number):Void
	{
		_index = In;
	}
	public function get Index():Number
	{
		return _index;
	}
	
	/* 所有者 */
	public function set Owner(value:UIList):Void
	{
		this._owner = value;	
	}
	public function get Owner():UIList
	{
		return this._owner;
	}
	/* 选择 */
	public function set Choose(B:Boolean):Void
	{
		isChoose = B;
	}
	public function get Choose():Boolean
	{
		return isChoose;
	}
}
