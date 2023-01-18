import net.manaca.ui.controls.skin.ISkin;
import net.manaca.ui.controls.RadioButton;
import net.manaca.ui.controls.UIComponent;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-27
 */
interface net.manaca.ui.controls.skin.IRadioButtonSkin extends ISkin {
	public function getTextHolder():TextField;
	
	public function onOver():Void;
	public function onOut() : Void;
	public function onDown():Void;
	
	public function setSelected(n:Boolean):Void;
	public function updateChildComponent():Void;
}