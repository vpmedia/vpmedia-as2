import net.manaca.ui.controls.UIComponent;
/**
 * 提供一个可以处理子组件的操作，一般实现此接口的对象都需要重写paint方法和repaint方法
 * @author Wersling
 * @version 1.0, 2006-5-15
 */
interface net.manaca.ui.controls.IComponent {
	/**
	 * 添加一个子组件
	 */
	public function addChildComponent(c:UIComponent):Void;
	
	/**
	 * 获取指定ID的子组件
	 */
	public function getChildComponent(id:Number):UIComponent;
	
	/**
	 * 删除一个子组件
	 */
	public function removeChildComponent(c:UIComponent):Void;
	
	/**
	 * 绘制此组件的所有子组件。
	 */
	public function paintAll():Void;
	
	/**
	 * 重绘此组件的所有子组件。
	 */
	public function repaintAll():Void;
}