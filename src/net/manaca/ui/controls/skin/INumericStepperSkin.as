import net.manaca.ui.controls.skin.ISkin;
import net.manaca.ui.controls.TextInput;
import net.manaca.ui.controls.Button;
/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-19
 */
interface net.manaca.ui.controls.skin.INumericStepperSkin extends ISkin {
	public function getDownButton():Button;
	public function getUpButton():Button;
	public function getTextInput():TextInput;
}