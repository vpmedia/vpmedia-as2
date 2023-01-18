import janumedia.application;
import UI.controls.*;
class janumedia.components.videoCam extends MovieClip {
	private var bg, btn:MovieClip;
	function videoCam() {
		this.attachMovie("podType3", "bg", 10);
		this.attachMovie("Button", "btn", 11, {_x:4});
		btn.icon = "icon_monitor";
	}
	function setSize(w:Number, h:Number) {
		btn._y = h-bg.bottomLeft._height+4;
		btn.setSize(30, 24);
	}
	function setPos(x:Number, y:Number) {
		this._x = x;
		this._y = y;
	}
}
