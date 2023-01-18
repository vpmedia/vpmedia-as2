import net.manaca.ui.awt.Graphics;
import net.manaca.ui.awt.Pen;
import net.manaca.ui.awt.SolidBrush;
import net.manaca.ui.controls.skin.IToolTipSkin;
import net.manaca.ui.controls.skin.Skin;
import net.manaca.ui.controls.themes.Themes;
import net.manaca.ui.controls.UIComponent;


/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-14
 */
class net.manaca.ui.controls.skin.halo.ToolTipSkin extends Skin  implements IToolTipSkin{
	private var className : String = "net.manaca.ui.controls.skin.halo.ToolTipSkin";
	private var _w : Number;
	private var _h : Number;
	private var _themes : Themes;
	private var _sb : SolidBrush;

	private var _pen : Pen;
	function ToolTipSkin() {
		super();
	}

	public function updateDisplay(name : String) : Void {
		_w = _component.getSize().getWidth();
		_h = _component.getSize().getHeight();
		_themes = _component.getThemes();
		_sb = new SolidBrush();
		_sb.setColor(0,100);
		_pen = new Pen();
		ControlBackground();
		ControlBorder();
	}
	private function ControlBackground() : Void {
		var _mc:MovieClip = createEmptyMc("ControlBackground");
		var _g:Graphics = new Graphics(_mc);
		_sb.setColor(_themes.Control);
		_g.fillRectangle(_sb,-1,-1,_w+2,_h+2);
		if(_mc.getDepth() > _mc._parent.ToolTip_textField.getDepth())_mc.swapDepths(_mc._parent.ToolTip_textField);
	}
	private function ControlBorder() : Void {
		var _mc:MovieClip = createEmptyMc("ControlBorder");
		var _g:Graphics = new Graphics(_mc);
		_pen.setColor(_themes.ControlBorder);
		_g.drawRectangle(_pen,-1,-1,_w+2,_h+2);
	}
	public function initialize(c : UIComponent) : Void {
	}

	public function paint() : Void {
	}

	public function paintAll() : Void {
	}

	public function updateSize() : Void {
	}

	public function updateThemes() : Void {
	}

	public function updateTextFormat() : Void {
	}

	public function destroy() : Void {
	}

	public function repaintAll() : Void {
	}

	public function repaint() : Void {
	}

}