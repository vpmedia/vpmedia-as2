/**
 * 日志级别
 * @author Wersling
 * @version 1.0, 2005-10-22
 */
class net.manaca.lang.logging.Level {
	private var className : String = "wersling.log.Level";
	/**
	 * Field: 所有
	 * 所有的级别
	 */
	public static var ALL:Level = new Level("ALL", 1);
	
	/**
	 * Field: 日志
	 * 日志记录
	 */
	public static var LOG:Level = new Level("LOG", 1);
	
	/**
	 * Field: 测试 
	 * 测试代码时用
	 */
	public static var DEBUG:Level = new Level("DEBUG", 2);
	
	/**
	 * Field: 信息
	 * 应用程序的状态信息等
	 */
	public static var INFO:Level = new Level("INFO",4);
	
	/**
	 * Field: 异常
	 * 存在问题，但不会影响程序的基本运行
	 */
	public static var WARN:Level = new Level("WARN",8);
	
	/**
	 * Field: 错误
	 * 存在一个导致程序不能正常运行的错误，系统将停止运行
	 */
	public static var ERROR:Level = new Level("ERROR",16);
	
	/**
	 * Field: 致命的
	 * 主要是硬件等错误
	 */
	public static var FATAL:Level = new Level("FATAL",32);
	
	/**
	 * Field: NONE
	 * 一些搞不清楚的信息·#%……*%*
	 */
	public static var NONE:Level = new Level("NONE", 1024);
	/**
	 * @see static var INSPECT:Level = new Level("INSPECT", 0);
	 */
	/**
	 * 方法: getName
	 * @return String 级别名称
	 */
	public function getName():String { return _name; }
	
	/**
	 * 方法: getValue
	 * @return Number 级别值
	 */
	public function getValue():Number { return _value; }
	/**
	 * 方法: toString
	 * @return String 对象类型
	 */
	public function toString():String { return "[object wersling.log.Level." + getName() + "]"; }
	// 私有变量
	private var _name	:String;
	private var _value	:Number;
	/**
	 * 构造函数 Level
	 * @param name 	级别名称
	 * @param value	级别值
	 */
	private function Level(name:String, value:Number) {
		this._name = name;
		this._value = value;
	}
}