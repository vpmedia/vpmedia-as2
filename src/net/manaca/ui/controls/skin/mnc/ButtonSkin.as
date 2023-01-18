import net.manaca.ui.controls.skin.IButtonSkin;
import net.manaca.ui.controls.skin.mnc.SimpleButtonSkin;

/**
 * 按钮皮肤
 * @author Wersling
 * @version 1.0, 2006-5-30
 */
class net.manaca.ui.controls.skin.mnc.ButtonSkin extends SimpleButtonSkin implements IButtonSkin {
	private var className : String = "net.manaca.ui.controls.skin.mnc.ButtonSkin";
	private var _component : net.manaca.ui.controls.Button;

	private var _selected_mc : MovieClip;
	private var _icon_mc:MovieClip;
	private var _label_text:TextField;
	public function ButtonSkin() {
		super();
	}

	public function paint() : Void {
		updateParameter();
		this.drawBorder("outset",_w,_h,_component.angle);
		new Color(this._displayObject["border_highlight"]).setRGB(_themes.border_highlight_color);
		drawFillRoundRect(createEmptyMc(_displayObject,"control"),_themes.control_color,3,4,_w-6,_h-7,_themes.border_corner_radius - 3,_component.angle);
		_selected_mc = createEmptyMc(_displayObject,"selected");
		drawFillRoundRect(_selected_mc,_themes.focus_color,1,1,_w-2,_h-2,_themes.border_corner_radius - 1,_component.angle);
	}

	public function paintAll() : Void {
		paint();
		_icon_mc = createEmptyMcByDepth(_displayObject,"_icon_mc",101);
		_label_text = _displayObject.createTextField("_label_text",102,0,0,0,0);
	}
	
	public function repaint() : Void {
		paint();
		//updateChildComponent();
	}
	
	public function repaintAll() : Void {
		paint();
		updateChildComponent();
	}

	public function updateSize() : Void {
		paint();
		updateChildComponent();
	}

	public function updateThemes() : Void {
		paint();
		updateTextFormat();
		updateChildComponent();
	}

	public function updateTextFormat() : Void {
		_label_text.setTextFormat(this.getControlTextFormat());
	}

	public function destroy() : Void {
		super.destroy();
	}

	public function getIconHolder() : MovieClip {
		return _icon_mc;
	}

	public function getTextHolder() : TextField {
		return _label_text;
	}
	
	public function updateChildComponent() : Void {
		var minx:Number = 4;
		var miny:Number = 4;
		var manw:Number = _w - minx*2;
		var manh:Number = _h - miny*2+1;;
		var f:TextField = _label_text;
		var icon:MovieClip = _icon_mc;
		
		f.autoSize = true;
		var fw = f._width;
		var fh = f._height;
		var iw = icon._width;
		var ih = icon._height;
		f.autoSize = false;
		
		if(iw > 0 && ih >0 && fw >4){
			icon._x = Math.max((int((manw-(fw+iw))/2))+minx,minx);
			f._x = int(icon._x + iw);
			var _fw = Math.min(manw-iw,fw);
			if(_fw < 0) _fw = 0;
			f._width = _fw;
		}else if(iw > 0 && ih >0){
			icon._x = Math.max((int((manw-iw)/2))+minx,minx);
		}else{
			f._width = Math.min(manw,fw);
			f._x =  Math.max((int((manw-fw)/2))+minx,minx);
		}
		f._y =  Math.max((int((manh-fh)/2))+miny-1,miny-2);
		icon._y = Math.max((int((manh-ih)/2))+miny,miny);
	}
	
	public function setSelected(n : Boolean) : Void {
		_selected_mc._alpha = n ? 100:0;
	}

}