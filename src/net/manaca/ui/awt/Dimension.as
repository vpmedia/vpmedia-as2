
/**
 * Dimension 类封装单个对象中组件的宽度和高度（精确到整数）。
 * 该类与组件的某个属性关联。
 * 
 * 通常，width 和 height 的值是非负整数。
 * 允许创建 dimension 的构造方法不会阻止您为这些属性设置负值。
 * 如果 width 或 height 的值为负，则由其他对象所定义的一些方法的行为是不明确的。 
 * @author Wersling
 * @version 1.0, 2006-4-6
 */
class net.manaca.ui.awt.Dimension {
	private var className : String = "net.manaca.ui.awt.Dimension";
	private var _height:Number;
	private var _width:Number;

	/**
	 * 构造一个Dimension
	 * @param width 宽度
	 * @param height 高度
	 */
	 
	public function Dimension(width:Number,height:Number) {
		super();
		if(width != undefined) _width = width;
		if(height != undefined) _height = height;
	}
	
	/**
	 * 获取高度
	 */
	public function getHeight():Number{
		return _height;
	}
	
	/**
	 * 获取宽度
	 */
	public function getWidth():Number{
		return _width;
	}
	
	/**
	 * 设置高度
	 */
	public function setHeight(height:Number):Void{
		_height = height;
	}
	
	/**
	 * 设置宽度
	 */
	public function setWidth(width:Number):Void{
		_width = width;
	}
	
	/**
	 * 设置大小
	 */
	public function getSize():Dimension{
		return  new Dimension(_width,_height);
	}
	
	/**
	 * 设置大小
	 */
	public function setSize(d:Dimension):Void{
		_height = d.getHeight();
		_width = d.getWidth();
	}
	
	public function setSizeN(width:Number,height:Number){
		if(width != undefined) _width = width;
		if(height != undefined) _height = height;
	}
	
	public function toString():String{
		return "Dimension:\n	_width:" + _width+"\n	_height:" + _height;
	}
}