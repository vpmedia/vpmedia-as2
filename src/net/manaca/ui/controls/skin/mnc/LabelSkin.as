import net.manaca.ui.controls.skin.Skin;
import net.manaca.ui.controls.skin.ILabelSkin;
import net.manaca.ui.controls.skin.mnc.AbstractSkin;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-17
 */
class net.manaca.ui.controls.skin.mnc.LabelSkin extends AbstractSkin implements ILabelSkin{
	private var className : String = "net.manaca.ui.controls.skin.mnc.LabelSkin";
	private var _label_text:TextField;
	public function LabelSkin() {
		super();
	}
	public function paint() : Void {
		this.updateParameter();
		if(_label_text == undefined) _label_text = _displayObject.createTextField("_label_text",102,0,0,0,0);
		_label_text._width = _w;
		_label_text._height = _h;
	}

	public function paintAll() : Void {
		paint();
	}

	public function updateSize() : Void {
		paint();
	}

	public function updateThemes() : Void {
		paint();
		updateTextFormat();
	}

	public function updateTextFormat() : Void {
		_label_text.setTextFormat(this.getControlTextFormat());
	}
	public function repaintAll() : Void {
		paint();
	}

	public function repaint() : Void {
		paint();
	}

	public function getTextHoder() : TextField {
		return _label_text;
	}

}