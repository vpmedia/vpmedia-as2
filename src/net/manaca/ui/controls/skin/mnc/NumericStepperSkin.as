import net.manaca.ui.controls.skin.INumericStepperSkin;
import net.manaca.ui.controls.skin.mnc.AbstractSkin;
import net.manaca.ui.controls.TextInput;
import net.manaca.ui.controls.Button;
import net.manaca.app.command.InputText;
import net.manaca.ui.controls.skin.mnc.IconSkin;
/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-19
 */
class net.manaca.ui.controls.skin.mnc.NumericStepperSkin extends AbstractSkin implements INumericStepperSkin {
	private var className : String = "net.manaca.ui.controls.skin.mnc.NumericStepperSkin";
	private var _up_but:Button;
	private var _down_but:Button;
	private var _input_text:TextInput;
	public function NumericStepperSkin() {
		super();
	}
	public function getDownButton() : Button {
		return _down_but;
	}

	public function getUpButton() : Button {
		return _up_but;
	}

	public function getTextInput() : TextInput {
		return _input_text;
	}

	public function paint() : Void {
		updateParameter();
	}

	public function paintAll() : Void {
		paint();
		
		_up_but = new Button(_displayObject,"_up_but");
		_up_but.getDisplayObject().swapDepths(1001);
		_up_but.angle = [0,1,0,0];
		_up_but.continuous = true;
		
		_down_but = new Button(_displayObject,"_down_but");
		_down_but.getDisplayObject().swapDepths(1002);
		_down_but.angle = [0,0,0,1];
		_down_but.continuous = true;
		
		var _icon_skin:IconSkin = new IconSkin();
		var mc:MovieClip = _up_but.getIconPanel();
		_icon_skin.drawTopIcon(mc,_themes.border_color,6,3);
		
		var mc:MovieClip = _down_but.getIconPanel();// draw
		_icon_skin.drawBottomIcon(mc,_themes.border_color,6,3);
		
		_up_but.repaintAll();
		_down_but.repaintAll();
		
		_input_text = new TextInput(_displayObject,"_input_text");
		_input_text.getDisplayObject().swapDepths(1000);
		_input_text.restrict = "-0123456789.";
		
	}

	public function updateSize() : Void {
		paint();
		adjustPlace();
	}

	public function updateThemes() : Void {
		paint();
		updateTextFormat();
	}

	public function updateTextFormat() : Void {
		_input_text.setTextFormat(this.getControlTextFormat());
	}

	public function repaintAll() : Void {
		paint();
		adjustPlace();
	}

	public function repaint() : Void {
	}
	
	private function adjustPlace():Void{
		_up_but.setLocation(_w-_h,0);
		_up_but.setSize(_h,_h/2+1);
		_down_but.setLocation(_w-_h,_h/2);
		_down_but.setSize(_h,_h/2+1);
		_input_text.setSize(_w-_h+1,_h+1);
	}
}