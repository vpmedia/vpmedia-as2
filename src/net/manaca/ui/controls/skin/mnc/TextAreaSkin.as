import net.manaca.ui.controls.skin.ITextAreaSkin;
import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.themes.Themes;
import net.manaca.ui.awt.SolidBrush;
import net.manaca.ui.controls.TextArea;
import net.manaca.ui.awt.Graphics;
import net.manaca.ui.controls.skin.mnc.AbstractSkin;
import net.manaca.ui.controls.ScrollbarX;
import net.manaca.ui.controls.ScrollbarY;

/**
 * TextAreaSkin
 * @author Wersling
 * @version 1.0, 2006-5-18
 */
class net.manaca.ui.controls.skin.mnc.TextAreaSkin extends AbstractSkin implements ITextAreaSkin {
	private var className : String = "net.manaca.ui.controls.skin.mnc.TextAreaSkin";

	private var _component:TextArea;

	private var _cornerRadius : Number;
	
	private var _scrollbarX:ScrollbarX;
	private var _scrollbarY:ScrollbarY;
	private var _label:TextField;
	function TextAreaSkin() {
		super();
	}
	public function paint() : Void {
		this.updateParameter();
		this.drawBorder("inset",_w,_h);
		drawFillRoundRect(createEmptyMc(_displayObject,"control"),_themes.control_color,2,2,_w-3,_h-3,0,[0,0,0,0]);
	}

	public function paintAll() : Void {
		paint();
		
		_label = _displayObject.createTextField("Label", 1000, 0, 0, 0, 0);
		
		_scrollbarX = new ScrollbarX(_displayObject,"scrollbarX");
		_scrollbarX.getDisplayObject().swapDepths(1001);
		
		_scrollbarY = new ScrollbarY(_displayObject,"scrollbarY");
		_scrollbarY.getDisplayObject().swapDepths(1002);
		
		updateTextFormat();
	}
	public function updateSize() : Void {
		paint();
	}

	public function updateThemes() : Void {
		paint();
		updateTextFormat();
	}

	public function updateTextFormat() : Void {
		_label.setTextFormat(this.getControlTextFormat());
	}
	public function repaintAll() : Void {
		paint();
	}

	public function repaint() : Void {
		paint();
	}

	public function getLabel() : TextField {
		return _label;
	}

	public function getVScrollBar() : ScrollbarY {
		return _scrollbarY;
	}

	public function getHScrollBar() : ScrollbarX {
		return _scrollbarX;
	}

}