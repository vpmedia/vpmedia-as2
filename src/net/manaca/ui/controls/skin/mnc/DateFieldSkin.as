import net.manaca.ui.controls.skin.mnc.AbstractSkin;
import net.manaca.ui.controls.skin.IDateFieldSkin;
import net.manaca.ui.controls.DateChooser;
import net.manaca.ui.controls.DateField;
import net.manaca.ui.controls.Button;
import net.manaca.ui.controls.TextInput;
import net.manaca.ui.controls.skin.mnc.IconSkin;


/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-25
 */
class net.manaca.ui.controls.skin.mnc.DateFieldSkin extends AbstractSkin implements IDateFieldSkin {
	private var className : String = "net.manaca.ui.controls.skin.mnc.DateFieldSkin";
	private var _component:DateField;
	private var _button : Button;
	private var _textInput : TextInput;
	private var _dateChooser : DateChooser;
	function DateFieldSkin() {
		super();
	}
	public function paint() : Void {
		this.updateParameter();
	}

	public function paintAll() : Void {
		paint();
		
		_dateChooser = new DateChooser(_displayObject,"dateChooser");
		_dateChooser.getDisplayObject().swapDepths(1000);
		
		_button = new Button(_displayObject,"button");
		_button.getDisplayObject().swapDepths(1002);
		_button.angle = [0,1,0,1];
			
		var _icon_skin:IconSkin = new IconSkin();
		var mc:MovieClip = _button.getIconPanel();// draw
		_icon_skin.drawBottomIcon(mc,_themes.border_color,8,5,180);
		_button.repaintAll();
		
		_textInput = new TextInput(_displayObject,"textInput");
		_textInput.getDisplayObject().swapDepths(1001);
		adjustPlace();
	}

	public function updateSize() : Void {
		this.updateParameter();
		adjustPlace();
	}

	public function updateThemes() : Void {
	}

	public function updateTextFormat() : Void {
		_textInput.setTextFormat(this.getControlTextFormat());
	}

	public function repaintAll() : Void {
		paintAll();
	}

	public function repaint() : Void {
	}

	public function getClickButton() : Button {
		return _button;
	}

	public function getDateChooser() : DateChooser {
		return _dateChooser;
	}

	public function getTextInput() : TextInput {
		return _textInput;
	}
	
	/**
	 * 调整元素位置，一般在初始化和大小改变时执行
	 */
	private function adjustPlace(){
		_textInput.setSize(_w-_h+1,_h);
		_textInput.setLocation(0,0);
		
		_button.setLocation(_w-_h,0);
		_button.setSize(_h,_h);
		
		_dateChooser.setSize(150,155);
		//_dateChooser.setLocation(0,_h);
		_dateChooser.setLocation(_w-_h,_h);
		
	}

}