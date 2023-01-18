import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.Button;
import net.manaca.ui.controls.themes.Themes;
import net.manaca.ui.awt.Graphics;
import net.manaca.ui.awt.SolidBrush;
import net.manaca.ui.awt.Rectangle;
import net.manaca.ui.controls.skin.IScrollbarSkin;
import net.manaca.ui.controls.skin.mnc.AbstractSkin;
import net.manaca.ui.controls.skin.mnc.IconSkin;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-18
 */
class net.manaca.ui.controls.skin.mnc.ScrollbarSkin extends AbstractSkin implements IScrollbarSkin {
	private var className : String = "net.manaca.ui.controls.skin.mnc.ScrollbarSkin";
	private var _solidBrush : SolidBrush;
	
	private var _up_but : Button;
	private var _down_but : Button;
	private var _drag_but : Button;
	public function ScrollbarSkin() {
		super();
	}
	
	public function paint() : Void {
		updateParameter();
	}
	public function paintAll() : Void {
		paint();
		_up_but = new Button(_displayObject,"up_but");
		_up_but.getDisplayObject().swapDepths(1000);

		_down_but = new Button(_displayObject,"down_but");
		_down_but.getDisplayObject().swapDepths(1001);

		_drag_but = new Button(_displayObject,"drag_but");
		_drag_but.getDisplayObject().swapDepths(1002);
		
		updateSize();
	}

	public function updateSize() : Void {
		updateParameter();
		
		_up_but.setSize(_w,_w);
		_down_but.setSize(_w,_w);
		
		updataHorizontal();
	}
	
	public function updataHorizontal(b:Boolean) : Void {
		updateParameter();
		
		_up_but.setLocation(0,0);
		if(!b){
			 _down_but.setLocation(0,_h-_down_but.getSize().getHeight());
		}else{
			if(b) _down_but.setLocation(_w-_down_but.getSize().getHeight(),0);
		}
		
		if(!b){
			_up_but.angle = [0,0,1,1];
			_down_but.angle = [1,1,0,0];
		}else{
			_up_but.angle = [1,0,1,0];
			_down_but.angle = [0,1,0,1];
		}
		
//		var mc:MovieClip = _down_but.getIconPanel();// draw
//		new IconSkin().drawDirectionIndicatorIcon(mc,_themes.border_color,10,10,180);
//		
//		var mc:MovieClip = _up_but.getIconPanel();// draw
//		new IconSkin().drawDirectionIndicatorIcon(mc,_themes.border_color,10,10,0);
	}
	
	public function getDragArea() : Rectangle {
		return new Rectangle(0,_w,_w,_h-_w*2);
//		if(_component.horizontal) return new Rectangle(_w,0,_w-_h*2,_h);
	}


	



	public function updateThemes() : Void {
	}

	public function updateTextFormat() : Void {
	}


	public function repaintAll() : Void {
	}

	public function repaint() : Void {
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