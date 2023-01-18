import net.manaca.ui.controls.skin.ISkin;
import net.manaca.ui.awt.Dimension;
import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.Window;
import net.manaca.ui.controls.Panel;
import net.manaca.ui.controls.Label;

/**
 * WindowSkin
 * @author Wersling
 * @version 1.0, 2006-5-15
 */
interface net.manaca.ui.controls.skin.IWindowSkin extends ISkin {
	public function getCloseButton():net.manaca.ui.controls.Button;
	public function getMinButton():net.manaca.ui.controls.Button;
	public function getMaxButton():net.manaca.ui.controls.Button;
	public function getSizeButton():net.manaca.ui.controls.Button;
	public function getDragButton():MovieClip;
	public function getPanel():Panel;
	public function getLabel():Label;
	/**
	 * 获取可用区域
	 */
	public function getUsableArea():Dimension;
	/**
	 * 获取最小大小
	 */
	public function getMinimumSize():Dimension;
	public function updateChildComponent():Void;
	/**
	 * 更新焦点
	 */
	public function updateFocus(f:Boolean):Void;
	/**
	 * 获得一个低部元素，用于获取焦点
	 */
	public function getBack() : MovieClip;

}