import net.manaca.ui.controls.skin.ISkin;
import net.manaca.ui.controls.Panel;
import net.manaca.ui.controls.ProgressBar;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-27
 */
interface net.manaca.ui.controls.skin.ILoaderSkin extends ISkin {
	public function getPanel():Panel;
	public function getProgressBar():ProgressBar;
}