import net.manaca.ui.controls.skin.IRadioButtonSkin;
import flash.geom.Matrix;
import net.manaca.ui.controls.skin.mnc.SimpleButtonSkin;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-27
 */
class net.manaca.ui.controls.skin.mnc.RadioButtonSkin extends SimpleButtonSkin implements IRadioButtonSkin {
	private var className : String = "net.manaca.ui.controls.skin.mnc.RadioButtonSkin";
	private var matrix : Matrix;
	private var _selected_mc : MovieClip;
	private var _label_text : TextField;
	public function RadioButtonSkin() {
		super();
		matrix = new Matrix();
	}
	public function paint() : Void {
		updateParameter();
		matrix.createGradientBox((int(_h/3)-3)*2, int((_h/3)-3)*2,45 * Math.PI/180, 0, 0);
		drawfillCircle(createEmptyMc(_displayObject,"border"),_themes.border_color,0,_h/2,int(_h/3));
		drawfillCircle(createEmptyMc(_displayObject,"border_highlight"),_themes.border_highlight_color,0,_h/2,int(_h/3)-1);
		new Color(this._displayObject["border_highlight"]).setRGB(_themes.border_highlight_color);
		
		_selected_mc = createEmptyMc(_displayObject,"selected");
		drawfillCircleByGradient(_selected_mc,
			[_themes.focus_color,_themes.focus_color],
			[50,100],
			[0, 0xFF],
			matrix,
			0,_h/2,int(_h/3)-3
		);
		
		
	}

	public function paintAll() : Void {
		paint();
		_label_text = _displayObject.createTextField("_label_text",102,0,0,0,0);
		updateSize();
	}

	public function updateSize() : Void {
		updateParameter();
		updateChildComponent();
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
		updateChildComponent();
	}

	public function repaint() : Void {
		paint();
		updateChildComponent();
	}

	public function getTextHolder() : TextField {
		return _label_text;
	}

	public function setSelected(n : Boolean) : Void {
		_selected_mc._alpha = n ? 100:0;
	}

	public function updateChildComponent() : Void {
		var f:TextField = _label_text;
		f.autoSize = true;
		var fw = f._width;
		var fh = f._height;
		f.autoSize = false;
		_label_text._width = _w-int(_h/3);
		_label_text._height = fh;
		_label_text._x = int(_h/3);
		_label_text._y = int((_h-fh)/2);
	}

}