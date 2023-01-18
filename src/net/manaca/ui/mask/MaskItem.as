import net.manaca.lang.BObject;

/**
 * 一个遮罩单元
 * @author Wersling
 * @version 1.0, 2006-1-5
 */
class net.manaca.ui.mask.MaskItem extends BObject {
	private var className : String = "net.manaca.ui.mask.MaskItem";
	//加载元件名称
	private var _cellName:String;
	//元件宽
	private var _w:Number;
	//元件高
	private var _h:Number;
	/**
	 * 构造函数
	 * @param __cellName 加载元件名称
	 * @param __w 元件宽
	 * @param __h 元件高
	 */
	public function MaskItem(__cellName:String,__w:Number,__h:Number) {
		super();
		if(__cellName) cellName = __cellName;
		if(__w) w = __w;
		if(__h) h = __h;
	}
	/**
	 * 设置和获取加载元件名称
	 * @param  value  参数类型：String 
	 * @return 返回值类型：String 
	 */
	public function set cellName(value:String) :Void
	{
		_cellName = value;
	}
	public function get cellName() :String
	{
		return _cellName;
	}
	
	/**
	 * 设置和获取元件宽
	 * @param  value  参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function set w(value:Number) :Void
	{
		_w = value;
	}
	public function get w() :Number
	{
		return _w;
	}
	
	/**
	 * 设置和获取元件高
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
}