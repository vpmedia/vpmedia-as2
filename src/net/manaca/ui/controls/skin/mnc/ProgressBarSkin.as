import net.manaca.ui.controls.skin.IProgressBarSkin;
import net.manaca.ui.controls.Label;
import net.manaca.ui.controls.skin.mnc.AbstractSkin;
import net.manaca.ui.controls.ProgressBar;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-19
 */
class net.manaca.ui.controls.skin.mnc.ProgressBarSkin extends AbstractSkin implements IProgressBarSkin {
	private var className : String = "net.manaca.ui.controls.skin.mnc.ProgressBarSkin";
	private var _component:ProgressBar;
	private var _bar:MovieClip;
	private var _label : Label;
	public function ProgressBarSkin() {
		super();
	}

	public function getBar() : MovieClip {
		return _bar;
	}

	public function getLabel() : Label {
		return _label;
	}

	public function paint() : Void {
		this.updateParameter();
		this.drawBorder("window",_w,5);
	}

	public function paintAll() : Void {
		paint();
		_bar = createEmptyMc(_displayObject,"_bar");
		_bar.swapDepths(1000);
		drawFillRoundRect(_bar,_themes.focus_color,0,0,8,5);
		_bar._alpha = 75;
		
		_label = new Label(_displayObject,"label");
		_label.getDisplayObject().swapDepths(1001);
		
		adjustPlace();
	}

	public function updateSize() : Void {
		paint();
		adjustPlace();
	}

	public function updateThemes() : Void {
		paint();
	}

	public function updateTextFormat() : Void {
		_label.setTextFormat(this.getControlTextFormat());
	}

	public function repaintAll() : Void {
		paint();
		adjustPlace();
	}

	public function repaint() : Void {
		paint();
	}
	private function adjustPlace(){
		_label.setLocation(0,5);
		_label.setSize(_w,_h-5);
	}
}