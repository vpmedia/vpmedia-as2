import net.manaca.ui.controls.skin.ICheckBoxSkin;
import net.manaca.ui.controls.Label;
import net.manaca.ui.controls.skin.mnc.SimpleButtonSkin;
import net.manaca.ui.awt.GradientBrush;
import flash.geom.Matrix;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-18
 */
class net.manaca.ui.controls.skin.mnc.CheckBoxSkin extends SimpleButtonSkin implements ICheckBoxSkin {
	private var className : String = "net.manaca.ui.controls.skin.mnc.CheckBoxSkin";
	private var matrix : Matrix;
	private var _label_text : TextField;

	private var _selected_mc : MovieClip;
	function CheckBoxSkin() {
		super();
		matrix = new Matrix();
	}
	
	public function paint() : Void {
		this.updateParameter();
		var __w = _h-10;
		matrix.createGradientBox(__w-4, __w-4,45 * Math.PI/180, 0, 0);
		
		drawfillRectangle(createEmptyMc(_displayObject,"border"),_themes.border_color,5,5,__w,__w);
		drawfillRectangle(createEmptyMc(_displayObject,"border_highlight"),_themes.border_highlight_color,6,6,__w-2,__w-2);
		new Color(this._displayObject["border_highlight"]).setRGB(_themes.border_highlight_color);
		_selected_mc = createEmptyMc(_displayObject,"selected");
		drawfillRectangleByGradient(_selected_mc,
			[_themes.focus_color,_themes.border_color],
			[100,100],
			[0,255],matrix,
			7,7,__w-4,__w-4
		);
		drawfillRectangleByGradient(createEmptyMc(_displayObject,"control"),
			[_themes.border_color,_themes.border_highlight_color],
			[30,30],
			[0,255],matrix,
			7,7,__w-4,__w-4
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

	public function getTextHoder() : TextField {
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
		_label_text._width = _w-_h+4;
		_label_text._height = fh;
		_label_text._x = _h-4;
		_label_text._y = int((_h-fh)/2);
	}

}