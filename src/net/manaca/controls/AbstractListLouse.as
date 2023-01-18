import net.manaca.ui.UIObject;
import net.manaca.controls.IListLouse;
import mx.transitions.OnEnterFrameBeacon;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-3-14
 */
class net.manaca.controls.AbstractListLouse extends UIObject implements IListLouse{
	private var className : String = "net.manaca.controls.AbstractListLouse";
	private var _h : Number;
	public function AbstractListLouse() {
		super();
	}
	/** 加载完成执行 */
	public function onLoad():Void{
		super.onLoad();
	}
	
	public function onEnterFrame(){
		if(random(3) == 2) h = this._height++;
	}
	/**
	 *
	 * @param  value  参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function set h(value:Number) :Void
	{
		_h = value;
	}
	public function get h() :Number
	{
		return _h;
	}
	
	public function getAttributeName() : String {
		return "_h";
	}

}