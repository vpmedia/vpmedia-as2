import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.Button;
import net.manaca.ui.controls.themes.Themes;
import net.manaca.ui.awt.Graphics;
import net.manaca.ui.awt.SolidBrush;
import net.manaca.ui.awt.Rectangle;
import net.manaca.ui.controls.skin.IScrollbarSkin;
import net.manaca.ui.controls.skin.mnc.AbstractSkin;
import net.manaca.ui.controls.skin.mnc.IconSkin;
import flash.geom.Matrix;
import net.manaca.ui.controls.ScrollbarY;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-18
 */
class net.manaca.ui.controls.skin.mnc.ScrollbarYSkin extends AbstractSkin implements IScrollbarSkin {
	private var className : String = "net.manaca.ui.controls.skin.mnc.ScrollbarYSkin";
	private var _component:ScrollbarY;
	//private var _solidBrush : SolidBrush;
	private var _up_but : Button;
	private var _down_but : Button;
	private var _drag_but : Button;
	private var matrix : Matrix;
	public function ScrollbarYSkin() {
		super();
		matrix = new Matrix();
	}
	
	public function paint() : Void {
		updateParameter();
		this.drawBorder("inset",_w,_h,[0,0,0,0]);
		matrix.createGradientBox(_w, _h,0 * Math.PI/180, 0, 0);
		drawfillRectangleByGradient(
			createEmptyMc(_displayObject,"control"),
			[_themes.border_highlight_color,_themes.border_highlight_color],
			[0,100],
			[0,250],matrix,
			1,1,_w-2,_h-2
		);
	}
	public function paintAll() : Void {
		paint();
		_up_but = new Button(_displayObject,"up_but");
		_up_but.getDisplayObject().swapDepths(1002);
		_up_but.continuous = true;
		_down_but = new Button(_displayObject,"down_but");
		_down_but.getDisplayObject().swapDepths(1001);
		_down_but.continuous = true;
		_drag_but = new Button(_displayObject,"drag_but");
		_drag_but.getDisplayObject().swapDepths(1000);
		
		_up_but.angle = [0,0,1,1];
		_down_but.angle = [1,1,0,0];
		var _icon_skin:IconSkin = new IconSkin();
		var mc:MovieClip = _down_but.getIconPanel();// draw
		_icon_skin.drawBottomIcon(mc,_themes.border_color,8,5,180);
		_down_but.repaintAll();
		
		var mc:MovieClip = _up_but.getIconPanel();// draw
		_icon_skin.drawTopIcon(mc,_themes.border_color,8,5,0);
		
		updateSize();
	}

	public function updateSize() : Void {
		paint();
		
		_up_but.setLocation(0,0);
		_up_but.setSize(_w,_w);
		_down_but.setSize(_w,_w);
		_down_but.setLocation(0,_h-_down_but.getSize().getHeight());
	}
	
	public function getDragArea() : Rectangle {
		return new Rectangle(0,_w,_w,_h-_w*2);
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
	
	public function getUpButton() : Button {
		return _up_but;
	}

	public function getDownButton() : Button {
		return _down_but;
	}

	public function getDragButton() : Button {
		return _drag_but;
	}


}