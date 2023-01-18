import net.manaca.lang.event.Event;
/**
 * 
 * @author Wersling
 * @version 1.0, 2006-1-6
 */
interface net.manaca.lang.event.IEventDispatcher {
	/**
	 * 添加一个对数据的监听
	 */
	public function addListener(type:String, listener:Function):Void;
	/**
	 * 删除监听
	 */
	public function removeListener(type:String, listener:Function):Void;
	//public function dispatchEvent(eventObj:Event):Void;
}