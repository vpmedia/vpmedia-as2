import net.manaca.ui.controls.skin.mnc.AbstractSkin;
import net.manaca.ui.controls.skin.IComboBoxSkin;
import net.manaca.ui.controls.Button;
import net.manaca.ui.controls.List;
import net.manaca.ui.controls.TextInput;
import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.ComboBox;
import net.manaca.ui.controls.skin.mnc.IconSkin;
/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-23
 */
class net.manaca.ui.controls.skin.mnc.ComboBoxSkin extends AbstractSkin implements IComboBoxSkin {
	private var className : String = "net.manaca.ui.controls.skin.mnc.ComboBoxSkin";
	private var _component:ComboBox;
	private var _button : Button;
	private var _list : List;
	private var _textInput : TextInput;
	public function ComboBoxSkin() {
		super();
	}
	
	public function getClickButton() : Button {
		return _button;
	}

	public function getList() : List {
		return _list;
	}

	public function getTextInput() : TextInput {
		return _textInput;
	}
	public function paint() : Void {
		updateParameter();
	}

	public function paintAll() : Void {
		paint();
		
		_button = new Button(_displayObject,"button");
		_button.getDisplayObject().swapDepths(1002);
			
		var _icon_skin:IconSkin = new IconSkin();
		var mc:MovieClip = _button.getIconPanel();// draw
		_icon_skin.drawBottomIcon(mc,_themes.border_color,8,5,180);
		_button.repaintAll();
		
		_textInput = new TextInput(_displayObject,"textInput");
		_textInput.getDisplayObject().swapDepths(1001);
		
		_list = new List(_displayObject,"list");
		_list.getDisplayObject().swapDepths(1000);
		
		adjustPlace();
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
		_textInput.setTextFormat(this.getControlTextFormat());
	}

	public function repaintAll() : Void {
		paint();
		adjustPlace();
	}

	public function repaint() : Void {
	}
	/**
	 * 调整元素位置，一般在初始化和大小改变时执行
	 */
	private function adjustPlace(){
		_textInput.setSize(_w-_h+1,_h);
		_textInput.setLocation(0,0);
		
		_button.setLocation(_w-_h,0);
		_button.setSize(_h,_h);
		_button.angle = [0,1,0,1];
		_list.setLocation(0,_h-1);
		var w:Number = _component.dropdownWidth;
		if(w == undefined) w = _w;
		
		var l = _component.length;
		if(l > _component.rowCount) l = _component.rowCount;
		
		var h:Number = _list.rowHeight*l+4;
		if(h < 22) h = 24;
		_list.setSize(w,h);
	}
}