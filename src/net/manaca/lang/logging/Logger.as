import net.manaca.lang.logging.IPublisher;
import net.manaca.lang.logging.Level;
import net.manaca.lang.logging.LogEvent;
import net.manaca.lang.logging.TracePublisher;
import net.manaca.lang.logging.ConsolePublisher;
/**
 * 日志
 * @author Wersling
 * @version 1.0, 2005-10-22
 */
class net.manaca.lang.logging.Logger {
	private var className : String = "wersling.log.Logger";
	//日志编号
	private var _loggerId : String;
	//日志级别，默认为LOG
	private var _level : Level;
	//发布信息的方式列表
	private var _publishers : Object;
	//保存所有的日志
	private static var _instances:Object = new Object();
	/**
	 * 获取一个日志对象
	 * @param logId 日志编号
	 * @param maxDepth 显示级别，默认为4
	 */
	public static function getLogger(logId:String, maxDepth:Number):Logger
	{
		if(logId.length > 0) {
			var log:Logger = _instances[logId];
			//如果不存在就建一个咯
			if(log == undefined) {
				log = new Logger(logId);
				var tp:TracePublisher = new TracePublisher();
				var cp:ConsolePublisher = new ConsolePublisher();
				if(maxDepth == undefined) maxDepth = 4;
				tp.maxDepth = maxDepth;
				cp.maxDepth = maxDepth;
				log.addPublisher(tp);
				log.addPublisher(cp);
			}
			return log;
		}
		return null;
	}
	/** 发布一个日志 */
	public function log(argument)	:Void { publish(argument, Level.LOG); }
	/** 发布一个测试 */
	public function debug(argument)	:Void { publish(argument, Level.DEBUG); }
	/** 发布一个信息 */
	public function info(argument)	:Void { publish(argument, Level.INFO); }
	/** 发布一个警告 */
	public function warn(argument)	:Void { publish(argument, Level.WARN); }
	/** 发布一个错误 */
	public function error(argument)	:Void { publish(argument, Level.ERROR); }
	/** 发布一个灾难 */
	public function fatal(argument)	:Void { publish(argument, Level.FATAL); }
	/**
	 * 构造函数
	 * @param 无
	 */
	public function Logger(logId:String) {
		this._loggerId = logId;
		this._level = Level.LOG;
		_publishers = new Object();
		//_filters = new Array();
		// save instance
		_instances[logId] = this;
	}
	/**
	 * 添加一个发布方式
	 */
	public function addPublisher(publisher:IPublisher):Void {
		if( !_publishers[publisher.toString()] ) _publishers[publisher.toString()] = publisher;
	}
	/**
	 * 删除发布方式
	 */
	public function removePublisher(publisher:IPublisher):Void {
		delete _publishers[publisher.toString()];
	}
	/**
	 * 获取日志编号
	 * @return String 日志编号
	 */
	public function getId():String { return _loggerId; }
	/**
	 * 获取所有发布方式
	 * @param Object
	 */
	public function getPublishers():Object { return _publishers; }
	/**
	 * 发布信息
	 * @param 参数
	 * @param 级别
	 */
	public function publish(argument, level:Level):Void {
		if( level.getValue() >= _level.getValue() ) {
			var e:LogEvent = new LogEvent(this._loggerId, argument, level);
			for(var publisher:String in _publishers) IPublisher(_publishers[publisher]).publish(e);
		}
	}
	/**
	 *
	 * @param  value 参数类型：Level 
	 * @return 返回值类型：Level 
	 */
	public function set setLevel ( value:Level) :Void
	{
		_level =  value;
		trace("[INFO] ：信息显示级别："+value.getName());
	}
	public function get setLevel() :Level
	{
		return _level;
	}
}