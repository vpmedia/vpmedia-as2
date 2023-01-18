import net.manaca.ui.controls.skin.ITextInputSkin;
import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.themes.Themes;
import net.manaca.ui.awt.Graphics;
import net.manaca.ui.awt.SolidBrush;
import net.manaca.ui.controls.skin.mnc.AbstractSkin;
import net.manaca.ui.controls.TextInput;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-19
 */
class net.manaca.ui.controls.skin.mnc.TextInputSkin extends AbstractSkin implements ITextInputSkin {
	private var className : String = "net.manaca.ui.controls.skin.mnc.TextInputSkin";
	private var _text : TextField;
	private var _component :TextInput;
	public function TextInputSkin() {
		super();
	}
	public function getTextField() : TextField {
		return _text;
	}
	public function paint() : Void {
		this.updateParameter();
		this.drawBorder("inset",_w,_h,_component.angle);
		drawFillRoundRect(createEmptyMc(_displayObject,"control"),_themes.control_color,2,2,_w-3,_h-3,_themes.border_corner_radius - 2,_component.angle);
	}

	public function paintAll() : Void {
		paint();
		_text =  _displayObject.createTextField("label", 1000, 2, 0, _w-4, _h);
	}
	
	public function updateSize() : Void {
		paint();
		_text._width = _w-4;
		_text._height = _h;
	}

	public function updateThemes() : Void {
		paint();
		updateTextFormat();
	}

	public function updateTextFormat() : Void {
		_text.setTextFormat(this.getControlTextFormat());
	}

	public function repaintAll() : Void {
		updateSize();
	}

	public function repaint() : Void {
		updateSize();
	}

}