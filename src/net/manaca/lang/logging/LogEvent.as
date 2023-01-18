import net.manaca.lang.logging.Level;
/**
 * 用于封装Log信息的类
 * @author Wersling
 * @version 1.0, 2005-10-22
 */
class net.manaca.lang.logging.LogEvent {
	private var className : String = "wersling.log.LogEvent";
	/**
	 * Field: loggerId
	 * The originator logger id.
	 */
	public var loggerId:String;
	/**
	 * Field: 时间
	 * 信息产生时间
	 */
	public var time:Date;

	/**
	 * Field: 级别
	 * 信息级别. {@see <pre>@link wersling.Log.Level</pre>}
	 */
	public var level:Level;
	
	/**
	 * Field: 参数
	 * 信息发送的参数
	 */
	public var argument:Object;
	
	// Group: Constructor
	/**
	 * 构造函数
	 * @param loggerId 	信息ID
	 * @param argument 	参数
	 * @param level		级别
	 */
	public function LogEvent(loggerId:String, argument:Object, level:Level) {
		this.loggerId = loggerId;
		this.argument = argument;
		this.level = level;
		time = new Date();
	}
	
	/**
	 * 将 LogEvent 包装成一个对象
	 * @param  _logEvent LogEvent
	 * @return  Object 包装好的对象
	 */
	public static function serialize(_logEvent:LogEvent):Object {
		var o:Object = new Object();
		o.loggerId = _logEvent.loggerId;
		o.time = _logEvent.time;
		o.levelName = _logEvent.level.getName();
		o.argument = _logEvent.argument;
		return o;
	}
	/**
	 * 将一个对象拆分成一个LogEvent
	 * @param o 需要拆分的对象
	 * @return LogEvent 
	 */
	public static function deserialize(o:Object):LogEvent {
		var l:Level = Level[""+o.levelName];
		var e:LogEvent = new LogEvent(o.loggerId, o.argument, l);
		e.time = o.time;
		return e;
	}
}