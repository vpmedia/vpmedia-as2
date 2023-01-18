import net.manaca.ui.controls.skin.ISkin;
import net.manaca.ui.controls.ScrollbarY;
import net.manaca.ui.controls.ScrollbarX;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-6-3
 */
interface net.manaca.ui.controls.skin.IScrollSkin extends ISkin {
	public function getVScrollBar() : ScrollbarY;
	public function getHScrollBar() : ScrollbarX;
}