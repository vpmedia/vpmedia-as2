class UI.general.InfoBox extends UI.core.events {
    
	var createEmptyMovieClip, attachMovie, __label, closeBtn, shadow, dragHit, blockFocus, __get__title, __container, __width, __height, UISpace, drawRect;
    
	function InfoBox () {
		super();
		this.createEmptyMovieClip("UISpace", 0);
		this.attachMovie("ShadowBox", "shadow", 1);
		this.attachMovie("Label", "__label", 2);
		this.createEmptyMovieClip("dragHit", 5);
		this.attachMovie("closeBtn", "closeBtn", 6);
		__label.setFormat("color", 3290163);
		__label._x = 16;
		__label._y = 7;
		var col = new Color (closeBtn);
		col.setRGB(0x666666);
		closeBtn._y = 12;
		shadow._x = 2;
		shadow._y = 5;
		shadow.space4._yscale = 50;
		shadow.space4._alpha = 100;
		var owner = this;
		dragHit.onPress = function () {
			owner.startDrag(false,0,0,Stage.width,Stage.height);
		};
		dragHit.onRelease = (dragHit.onReleaseOutside = function () {
			owner.stopDrag();
		});
		dragHit.tabEnabled = false;
		dragHit._focusrect = false;
		dragHit.useHandCursor = false;
		closeBtn.onPress = function () {
			owner._visible = false;
			owner.content = "";
		};
		closeBtn.tabEnabled = false;
		closeBtn._focusrect = false;
		closeBtn.useHandCursor = false;
		blockFocus();
		
		Stage.addListener(this);
	}
	function onResize(){
		this._x = (Stage.width - this._width)/2;
		this._y = (Stage.height - this._height)/2;
	}
	function set title(s) {
		__label.text = s;
	}
	function set content(i) {
		__container.removeMovieClip();
		this.attachMovie(i, "__container", 4);
		__container._x = 6;
		__container._y = 26;
	}
	function get content() {
		return (__container);
	}
	function setSize(w, h) {
		__width = w;
		__height = h;
		UISpace.clear();
		shadow.setSize(w - 4, h - 7);
		__label.setSize(w - 38, 20);
		closeBtn._x = w - 20;
		var _local2 = w - 10;
		var _local5 = h - 10;
		var _local4 = 5;
		var _local3 = 5;
		drawRect(UISpace, _local4, _local3, _local2, _local5, 0x999999, 100, 4);
		UISpace.endFill();
		var _local8 = [0xEEEEEE, 0xCCCCCC];
		var _local6 = [100, 100];
		var _local11 = [0, 255];
		var _local7 = {matrixType:"box", x:0, y:0, w:w, h:h, r:(Math.PI/2)};
		UISpace.beginGradientFill("linear", _local8, _local6, _local11, _local7);
		drawRect(UISpace, _local4 + 1, _local3 + 1, _local2 - 2, _local5 - 2, null, 100, 4);
		UISpace.endFill();
		drawRect(UISpace, _local4 + 1, _local3 + 19, _local2 - 2, 1, 0, 10);
		drawRect(UISpace, _local4 + 1, _local3 + 20, _local2 - 2, 1, 0x666666, 20);
		dragHit.clear();
		drawRect(dragHit, _local4, _local3, _local2, 19, 0, 0);
		__container.setSize(w - 12, h - 31);
	}
	function show(){
		onResize();
		this._visible = true;
		_global.stageCover.drawRec();
	}
	function hide(){
		this._visible = false;
		_global.stageCover.clearRec();
	}
}