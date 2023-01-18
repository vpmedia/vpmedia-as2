import net.manaca.ui.controls.skin.mnc.AbstractSkin;
import net.manaca.util.ColorUtil;

/**
 * 提供一个处理鼠标动作的皮肤应对方案
 * @author Wersling
 * @version 1.0, 2006-5-31
 */
class net.manaca.ui.controls.skin.mnc.SimpleButtonSkin extends AbstractSkin {
	private var className : String = "net.manaca.ui.controls.skin.mnc.SimpleButtonSkin";
	private function SimpleButtonSkin() {
		super();
	}
	public function onOver() : Void {
		var _mc:MovieClip = this._displayObject["border_highlight"];
		if(_mc != undefined){
			var c:ColorUtil = new ColorUtil(_mc);
			c.setChangeRGB(ColorUtil.adjustBrightness2(_themes.focus_color,35),6);
		}
	}

	public function onOut() : Void {
		var _mc:MovieClip = this._displayObject["border_highlight"];
		if(_mc != undefined){
			var c:ColorUtil = new ColorUtil(_mc);
			c.setChangeRGB(_themes.border_highlight_color,6);
		}
	}

	public function onDown() : Void {
		var _mc:MovieClip = this._displayObject["border_highlight"];
		if(_mc != undefined){
			var c:ColorUtil = new ColorUtil(_mc);
			c.setChangeRGB(_themes.focus_color,6);
		}
	}
}