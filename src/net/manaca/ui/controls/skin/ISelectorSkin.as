import net.manaca.ui.controls.skin.ISkin;
import net.manaca.ui.controls.Selector;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-20
 */
interface net.manaca.ui.controls.skin.ISelectorSkin extends ISkin {
	/**
	 * 构造子元素
	 */
	public function createChildComponent(o:Selector):Void;
	/**
	 * 更新子元素
	 */
	public function UpdateChildComponent(o:Selector):Void;
	/**
	 * 获取子元素
	 */
	public function getChildComponent(name:String):MovieClip;
}