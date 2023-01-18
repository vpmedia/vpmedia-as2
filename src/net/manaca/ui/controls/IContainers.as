import net.manaca.lang.IObject;
import net.manaca.ui.awt.Dimension;
/**
 * 一个容器，用于添加元素，在容器大小发生变化时，通知容器内的元素
 * @author Wersling
 * @version 1.0, 2006-5-17
 */
interface net.manaca.ui.controls.IContainers {
	
	/**
	 * 绑定一个指定对象
	 */
	public function attach(o:IObject):Void;
	
	/**
	 * 解除指定的绑定对象
	 */
	public function detach(o:IObject):Void;
	
	/**
	 * 通知所有被绑定对象
	 */
	public function notify():Void;
	
	/**
	 * 获取当前状态
	 */
	public function getState():Object;
	
	/**
	 * 设置当前可用大小
	 */
	public function setState(o:Object);
}