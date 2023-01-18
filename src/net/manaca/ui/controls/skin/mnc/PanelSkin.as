import net.manaca.ui.controls.skin.IPanelSkin;
import net.manaca.ui.controls.skin.mnc.AbstractSkin;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-16
 */
class net.manaca.ui.controls.skin.mnc.PanelSkin extends AbstractSkin implements IPanelSkin {
	private var className : String = "net.manaca.ui.controls.skin.mnc.PanelSkin";
	private var _back : MovieClip;
	public function PanelSkin() {
		super();
	}
	public function getBoard() : MovieClip {
		return _back;
	}

	public function paint() : Void {
		this.updateParameter();
		_back = createEmptyMc(_displayObject,"window_back");
		this.drawfillRectangle(_back,0x000000,0,0,_w,_h,0);
		var _border:MovieClip = createEmptyMc(_displayObject,"window_border");
		this.drawfillRectangle(_border,0x000000,0,0,_w,_h);
		_back.setMask(_border);
	}

	public function paintAll() : Void {
		paint();
	}

	public function updateSize() : Void {
		paint();
	}

	public function updateThemes() : Void {
	}

	public function updateTextFormat() : Void {
	}
	
	public function repaintAll() : Void {
		paint();
	}

	public function repaint() : Void {
		paint();
	}

}