import net.manaca.ui.controls.skin.IButtonSkin;
import net.manaca.ui.controls.skin.mnc.ButtonSkin;
/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-19
 */
class net.manaca.ui.controls.skin.mnc.ListCellRendererSkin extends ButtonSkin implements IButtonSkin {
	private var className : String = "net.manaca.ui.controls.skin.mnc.ListCellRendererSkin";
	private var _selected_mc : MovieClip;

	private var _icon_mc : MovieClip;
	private var _label_text : TextField;
	public function ListCellRendererSkin() {
		super();
	}
	
	public function paint() : Void {
		updateParameter();
		drawFillRoundRect(createEmptyMc(_displayObject,"border_highlight"),0xffffff,0,0,_w,_h);
		new Color(this._displayObject["border_highlight"]).setRGB(_themes.border_highlight_color);
		
		_selected_mc = createEmptyMc(_displayObject,"selected");
		drawFillRoundRect(_selected_mc,_themes.focus_color,0,0,_w,_h);
	}

	public function setSelected(n : Boolean) : Void {
		_selected_mc._alpha = n ? 50:0;
	}
	
	public function updateChildComponent() : Void {
		var minx:Number = 2;
		var miny:Number = 0;
		var manw:Number = _w-2;
		var manh:Number = _h;;
		var f:TextField = _label_text;
		var icon:MovieClip = _icon_mc;
		
		f.autoSize = true;
		var fw = f._width;
		var fh = f._height;
		var iw = icon._width;
		var ih = icon._height;
		f.autoSize = false;
		if(iw > 0 && ih >0 && fw >4){
			icon._x = minx;
			f._x = int(icon._x + iw);
		}else if(iw > 0 && ih >0){
			icon._x = minx;
		}else{
			f._width = Math.max(manw,fw);
			f._x =  minx;
		}
		f._y =  Math.max((int((manh-fh)/2))+miny,miny-2);
		icon._y = Math.max((int((manh-ih)/2))+miny,miny);
	}

}