import net.manaca.ui.controls.skin.IColorPickerSkin;
import net.manaca.ui.controls.skin.Skin;
import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.ColorPicker;
import net.manaca.ui.controls.themes.Themes;
import net.manaca.ui.awt.SolidBrush;
import net.manaca.ui.awt.Graphics;
import net.manaca.util.ColorUtil;
import net.manaca.ui.controls.Button;
import net.manaca.ui.controls.ColorChooser;
import net.manaca.ui.controls.skin.mnc.AbstractSkin;
import flash.geom.Point;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-26
 */
class net.manaca.ui.controls.skin.mnc.ColorPickerSkin extends AbstractSkin implements IColorPickerSkin {
	private var className : String = "net.manaca.ui.controls.skin.mnc.ColorPickerSkin";
	private var _component:ColorPicker;
	private var _button : Button;
	private var _color_mc : MovieClip;
	private var _icon_mc : MovieClip;
	private var _icon_bg_mc : MovieClip;
	private var _colorChooser:ColorChooser;
	function ColorPickerSkin() {
		super();
	}
	public function paint() : Void {
		updateParameter();
	}

	public function paintAll() : Void {
		paint();
		
		_button = new Button(_displayObject,"button");
		_button.getDisplayObject().swapDepths(1001);
		
		
		var mc:MovieClip = _button.getIconPanel();// draw
		_color_mc = mc.createEmptyMovieClip("color_mc",mc.getNextHighestDepth());
		_icon_bg_mc = mc.createEmptyMovieClip("icon_bg_mc",mc.getNextHighestDepth());
		_icon_mc = mc.createEmptyMovieClip("icon_mc",mc.getNextHighestDepth());
		
		
		_colorChooser = new ColorChooser(_displayObject,"colorChooser");
		_colorChooser.getDisplayObject().swapDepths(1000);
		
		adjustPlace();
	}
		
	public function getClickButton() : Button {
		return _button;
	}

	public function getColorChooser() : ColorChooser {
		return _colorChooser;
	}

	public function getColorHoder() : MovieClip {
		return _color_mc;
	}
	
	/**
	 * 调整元素位置，一般在初始化和大小改变时执行
	 */
	private function adjustPlace(){
		_button.setSize(_w,_h);
		_colorChooser.setLocation(_w,_h);
		
		//处理选择颜色
		_color_mc.clear();
		var _g:Graphics = new Graphics(_color_mc);
		_solidBrush.setColor(_component.selectedColor);
		_solidBrush.setAlpha(100);
		_g.fillRectangle(_solidBrush,0,0,_w-8,_h-8);
		
		//处理按钮下方图标
		_icon_mc.clear();
		var _g:Graphics = new Graphics(_icon_mc);
		_solidBrush.setColor(0x000000);
		_solidBrush.setAlpha(100);
		_g.fillPolygon(_solidBrush,[{x:1,y:1},{x:7,y:1},{x:4,y:4}]);
		
		_icon_bg_mc.clear();
		var _g:Graphics = new Graphics(_icon_bg_mc);
		_solidBrush.setColor(0xFFFFFF);
		_solidBrush.setAlpha(100);
		_g.fillRectangle(_solidBrush,0,0,7,4);
		
		_icon_mc._x = _icon_bg_mc._x = _color_mc._width - _icon_mc._width;
		_icon_mc._y = _icon_bg_mc._y = _color_mc._height - _icon_mc._height;
		
		_button.repaintAll();
	}
	public function updateSize() : Void {
		paint();
		adjustPlace();
	}

	public function updateThemes() : Void {
		
	}
	
	public function repaintAll() : Void {
	}

	public function repaint() : Void {
	}

	public function updateTextFormat() : Void {
	}

}