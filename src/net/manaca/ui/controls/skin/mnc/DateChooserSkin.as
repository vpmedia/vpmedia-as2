import net.manaca.ui.controls.Panel;
import net.manaca.ui.controls.skin.IDateChooserSkin;
import net.manaca.ui.controls.skin.mnc.AbstractSkin;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-24
 */
class net.manaca.ui.controls.skin.mnc.DateChooserSkin extends AbstractSkin implements IDateChooserSkin {
	private var className : String = "net.manaca.ui.controls.skin.mnc.DateChooserSkin";
	private var _panel : Panel;
	public function DateChooserSkin() {
		super();
	}
	public function getPanel() : Panel {
		return _panel;
	}

	public function paint() : Void {
		updateParameter();
		this.drawBorder("inset",_w,_h);
		drawFillRoundRect(createEmptyMc(_displayObject,"control"),_themes.control_color,2,2,_w-3,_h-3,_themes.border_corner_radius - 2);
	}

	public function paintAll() : Void {
		paint();
		
		_panel = new Panel(_displayObject,"panel");
		_panel.getDisplayObject().swapDepths(1000);
		updateSize();
	}

	public function updateSize() : Void {
		paint();
		_panel.setLocation(2,2);
		_panel.setSize(_w-4,_h-4);
	}

	public function updateThemes() : Void {
		paint();
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