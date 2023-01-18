import net.manaca.ui.controls.skin.ISkin;
import net.manaca.ui.awt.Rectangle;
import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.Button;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-18
 */
interface net.manaca.ui.controls.skin.IScrollbarSkin extends ISkin {
	/**
	 * 可移动区域
	 */
	public function getDragArea():Rectangle;
	
	public function getUpButton():Button;
	public function getDownButton():Button;
	public function getDragButton():Button;
}