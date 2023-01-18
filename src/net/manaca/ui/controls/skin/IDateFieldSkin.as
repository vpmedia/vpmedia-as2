import net.manaca.ui.controls.skin.ISkin;
import net.manaca.ui.controls.TextInput;
import net.manaca.ui.controls.DateChooser;
import net.manaca.ui.controls.Button;


/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-25
 */
interface net.manaca.ui.controls.skin.IDateFieldSkin extends ISkin {
	public function getClickButton():Button;
	public function getDateChooser():DateChooser;
	public function getTextInput() : TextInput;
}