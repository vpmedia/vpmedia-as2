import net.manaca.lang.logging.LogEvent;
/**
 * 发布Log内容的接口
 * @author Wersling
 * @version 1.0, 2005-10-22
 */
interface net.manaca.lang.logging.IPublisher {
	/**
	 * 发布信息
	 */
	public function publish(e:LogEvent):Void;
	public function toString():String;
}