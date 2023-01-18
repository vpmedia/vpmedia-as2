import net.manaca.ui.controls.skin.ISkin;
import net.manaca.ui.controls.Label;


/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-19
 */
interface net.manaca.ui.controls.skin.IProgressBarSkin extends ISkin {
	public function getBar():MovieClip;
	public function getLabel():Label;
}