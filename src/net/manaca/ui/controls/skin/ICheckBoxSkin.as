import net.manaca.ui.controls.skin.ISkin;
import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.CheckBox;
import net.manaca.ui.controls.Label;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-18
 */
interface net.manaca.ui.controls.skin.ICheckBoxSkin extends ISkin {
	public function getTextHoder():TextField;
	
	public function onOver():Void;
	public function onOut() : Void;
	public function onDown():Void;
	
	public function setSelected(n:Boolean):Void;
	public function updateChildComponent():Void;
}