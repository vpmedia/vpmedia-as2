import net.manaca.ui.controls.skin.IPanelSkin;
import net.manaca.ui.controls.skin.Skin;
import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.awt.SolidBrush;
import net.manaca.ui.awt.Graphics;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-16
 */
class net.manaca.ui.controls.skin.halo.PanelSkin extends Skin implements IPanelSkin {
	private var className : String = "net.manaca.ui.controls.skin.halo.PanelSkin";
	private var _solidBrush : SolidBrush;
	private var _w : Number;
	private var _h : Number;
	public function PanelSkin() {
		super();
		_solidBrush = new SolidBrush();
	}
	public function updateDisplay(name : String) : Void {
		_w = _component.getSize().getWidth();
		_h = _component.getSize().getHeight();
		
//		var _g:Graphics = new Graphics(createEmptyMc("WindowBack"));
//		_g.fillRectangle(_solidBrush,0,0,_w,_h);
		createEmptyMc("WindowBack");
		var _g:Graphics = new Graphics(createEmptyMc("WindowBorder"));
		_g.fillRectangle(_solidBrush,0,0,_w,_h);
		MovieClip(this.getElement("WindowBack")).setMask(MovieClip(this.getElement("WindowBorder")));
	}

	public function getBoard() : MovieClip {
		return null;
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