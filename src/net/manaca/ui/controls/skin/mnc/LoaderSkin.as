import net.manaca.ui.controls.Loader;
import net.manaca.ui.controls.skin.ILoaderSkin;
import net.manaca.ui.controls.skin.mnc.AbstractSkin;
import net.manaca.ui.controls.Panel;
import net.manaca.ui.controls.ProgressBar;
/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-27
 */
class net.manaca.ui.controls.skin.mnc.LoaderSkin extends AbstractSkin implements ILoaderSkin {
	private var className : String = "net.manaca.ui.controls.skin.mnc.LoaderSkin";
	private var _component:Loader;
	private var _panel : Panel;
	private var _progressBar:ProgressBar;
	function LoaderSkin() {
		super();
	}

	public function getPanel() : Panel {
		return _panel;
	}

	public function getProgressBar() : ProgressBar {
		return _progressBar;
	}

	public function paint() : Void {
		this.updateParameter();
		this.drawBorder("inset",_w,_h);
	}

	public function paintAll() : Void {
		paint();
		_panel = new Panel(_displayObject,"panel");
		_panel.getDisplayObject().swapDepths(1000);
		
		_progressBar = new ProgressBar(_displayObject,"progressBar");
		_progressBar.getDisplayObject().swapDepths(1001);
		
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
		
	}

	public function repaintAll() : Void {
		paint();
		adjustPlace();
	}

	public function repaint() : Void {
		paint();
	}
	
	private function adjustPlace(){
		_panel.setSize(_w-2,_h-2);
		_panel.setLocation(1,1);
		_progressBar.setSize(_w-4,22);
		_progressBar.setLocation(2,_h-24);
	}
}