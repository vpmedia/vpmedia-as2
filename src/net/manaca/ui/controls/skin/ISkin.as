import net.manaca.ui.controls.UIComponent;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-11
 */
interface net.manaca.ui.controls.skin.ISkin {
	
	/**
	 * 初始化对象，需要传递一个
	 * @param c:UIComponent - 指示一个组件对象
	 */
	public function initialize(c:UIComponent):Void;
	
	/**
	 * 绘制此组件。
	 */
	public function paint():Void;
	
	/**
	 * 绘制此组件的所有子组件。
	 */
	public function paintAll() : Void ;
	
	/**
	 * 更新大小
	 */
	public function updateSize():Void;
	
	/**
	 * 更新样式
	 */
	public function updateThemes() : Void ;
	
	/**
	 * 更新文本样式，此方法只更新自身的TextFormat
	 */
	public function updateTextFormat() : Void;
	/**
	 * 破坏所有元素
	 */
	public function destroy():Void;
	

	public function repaintAll() : Void;

	public function repaint() : Void;

}