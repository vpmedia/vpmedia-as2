import net.manaca.ui.controls.skin.IListSkin;
import net.manaca.ui.controls.skin.Skin;
import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.List;
import net.manaca.ui.controls.themes.Themes;
import net.manaca.ui.awt.SolidBrush;
import net.manaca.ui.awt.Graphics;
import net.manaca.ui.controls.Panel;
import net.manaca.ui.controls.ScrollbarY;
import net.manaca.ui.controls.skin.mnc.AbstractSkin;
import net.manaca.ui.controls.ScrollbarX;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-19
 */
class net.manaca.ui.controls.skin.mnc.ListSkin extends AbstractSkin implements IListSkin {
	private var className : String = "net.manaca.ui.controls.skin.mnc.ListSkin";
	private var _component:List;
	private var _scrollbarY : ScrollbarY;
	private var _panel : Panel;
	function ListSkin() {
		super();

	}
	public function paint() : Void {
		this.updateParameter();
		this.drawBorder("inset",_w,_h);
		drawFillRoundRect(createEmptyMc(_displayObject,"control"),_themes.control_color,2,2,_w-3,_h-3);
	}

	public function paintAll() : Void {
		//paint();
		_scrollbarY = new ScrollbarY(_displayObject,"scrollbarY");
		_scrollbarY.getDisplayObject().swapDepths(1001);

		_panel = new Panel(_displayObject,"panel");
		_panel.getDisplayObject().swapDepths(1000);
		
		this.updateSize();
	}
	public function getPanel() : Panel {
		return _panel;
	}
	

	public function updateSize() : Void {
		paint();
		_panel.setSize(_w-4,_h-4);
		_panel.setLocation(2,2);
		_scrollbarY.setLocation(_w-16,0);
		_scrollbarY.setSize(16,_h);
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



	public function getVScrollBar() : ScrollbarY {
		return _scrollbarY;
	}

	public function getHScrollBar() : ScrollbarX {
		return null;
	}

}