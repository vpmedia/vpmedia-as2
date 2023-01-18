import net.manaca.ui.controls.skin.ISkin;
import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.ColorPicker;
import net.manaca.ui.controls.ColorChooser;
import net.manaca.ui.controls.Button;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-26
 */
interface net.manaca.ui.controls.skin.IColorPickerSkin extends ISkin {
	public function getClickButton():Button;
	public function getColorChooser():ColorChooser;
	public function getColorHoder() : MovieClip;

}