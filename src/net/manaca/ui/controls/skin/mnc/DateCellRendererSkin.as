import net.manaca.ui.controls.skin.mnc.ListCellRendererSkin;
import net.manaca.util.ColorUtil;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-7-3
 */
class net.manaca.ui.controls.skin.mnc.DateCellRendererSkin extends ListCellRendererSkin {
	private var className : String = "net.manaca.ui.controls.skin.mnc.DateCellRendererSkin";
	private var _background_color_type:String;
	public function DateCellRendererSkin() {
		super();
	}
	public function getBackground():String{
		return _background_color_type;
	}
	public function setBackground(type:String):Void{
		_background_color_type = type;
		new Color(this._displayObject["border_highlight"]).setRGB(_themes[type]);
	}
	public function onOut() : Void {
		var _mc:MovieClip = this._displayObject["border_highlight"];
		if(_mc != undefined){
			var c:ColorUtil = new ColorUtil(_mc);
			c.setChangeRGB(_themes[_background_color_type != undefined ? _background_color_type : "border_highlight_color"],6);
		}
	}
}