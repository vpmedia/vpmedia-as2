import net.manaca.ui.controls.skin.ISkin;
import net.manaca.ui.controls.TextInput;
import net.manaca.ui.controls.Panel;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-26
 */
interface net.manaca.ui.controls.skin.IColorChooserSkin extends ISkin {
	public function getSelectedColorHoder():MovieClip;
	public function getPanel():Panel;
	public function getInputText():TextInput;
}