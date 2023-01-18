import net.manaca.ui.UIObject;
import net.manaca.ui.SwellUIList;
import net.manaca.lang.exception.UnsupportedOperationException;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-1-15
 */
class net.manaca.ui.SwellUIListCell extends  UIObject{
	private var className : String = "net.manaca.ui.SwellUIListCell";
	private var _Item : Object;
	private var _Index : Number;
	private var _Owner : SwellUIList;
	private var _isChoose : Boolean;
	public function SwellUIListCell() {
		super();
		_isChoose = false;
	}

	/* 广播事件，此处将传递this */
	/*
	private function onRelease():Void
	{
		if(!isChoose) dispatchEvent({type:"onListCellRelease",target:this});
		// 在这里设置当点击过后所触发的事件
		
	} 
	*/
	
	/**
	 * 在选择状态改变时执行此方法
	 */
	private function onChoose():Void{
		throw new UnsupportedOperationException("方法无法执行，需要在其子类实现",this,arguments);
	}
	/**
	 * 单元编号
	 * @param  value  参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function set Index(value:Number) :Void
	{
		_Index = value;
	}
	public function get Index() :Number
	{
		return _Index;
	}
	
	/**
	 * 单元包涵的值
	 * @param  value  参数类型：Object 
	 * @return 返回值类型：Object 
	 */
	public function set Item(value:Object) :Void
	{
		_Item = value;
	}
	public function get Item() :Object
	{
		return _Item;
	}
	
	/**
	 * Cell 持有对象 SwellUIList
	 * @param  value  参数类型：SwellUIList 
	 * @return 返回值类型：SwellUIList 
	 */
	public function set Owner(value:SwellUIList) :Void
	{
		_Owner = value;
	}
	public function get Owner() :SwellUIList
	{
		return _Owner;
	}
	
	/**
	 * 是否被选择
	 * @param  value  参数类型：Boolean 
	 * @return 返回值类型：Boolean 
	 */
	public function set isChoose(value:Boolean) :Void
	{
		_isChoose = value;
		onChoose();
	}
	public function get isChoose() :Boolean
	{
		return _isChoose;
	}
}