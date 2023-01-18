import net.manaca.ui.awt.Graphics;
import net.manaca.ui.awt.Pen;
import net.manaca.ui.awt.SolidBrush;
import net.manaca.ui.controls.skin.IToolTipSkin;
import net.manaca.ui.controls.themes.Themes;
import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.skin.mnc.AbstractSkin;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-14
 */
class net.manaca.ui.controls.skin.mnc.ToolTipSkin extends AbstractSkin  implements IToolTipSkin{
	private var className : String = "net.manaca.ui.controls.skin.mnc.ToolTipSkin";
	function ToolTipSkin() {
		super();
	}
	public function paint() : Void {
		this.updateParameter();
		this.drawBorder("solid",_w,_h);
		drawfillRectangle(createEmptyMc(_displayObject,"control"),_themes.control_color,1,1,_w-2,_h-2);
	}
	public function paintAll() : Void {
		paint();
	}

	public function updateSize() : Void {
		paint();
	}

	public function updateThemes() : Void {
		paint();
	}

	public function updateTextFormat() : Void {
		paint();
	}

	public function repaintAll() : Void {
		paint();
	}

	public function repaint() : Void {
		paint();
	}
}