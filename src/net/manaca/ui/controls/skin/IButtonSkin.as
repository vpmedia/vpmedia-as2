import net.manaca.ui.controls.skin.ISkin;
import net.manaca.ui.controls.UIComponent;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-15
 */
interface net.manaca.ui.controls.skin.IButtonSkin extends ISkin {
	public function getIconHolder():MovieClip;
	public function getTextHolder():TextField;
	
	public function onOver():Void;
	public function onOut() : Void;
	public function onDown():Void;
	
	public function setSelected(n:Boolean):Void;
	public function updateChildComponent():Void;

}