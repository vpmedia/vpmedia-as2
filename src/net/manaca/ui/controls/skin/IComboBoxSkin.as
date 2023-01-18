import net.manaca.ui.controls.skin.ISkin;
import net.manaca.ui.controls.Button;
import net.manaca.ui.controls.List;
import net.manaca.ui.controls.TextInput;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-23
 */
interface net.manaca.ui.controls.skin.IComboBoxSkin extends ISkin {
	public function getClickButton():Button;
	public function getList():List;
	public function getTextInput() : TextInput;
}