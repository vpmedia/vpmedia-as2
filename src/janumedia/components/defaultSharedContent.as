class janumedia.components.defaultSharedContent extends MovieClip {
	var info:MovieClip;
	function defaultSharedContent() {
		setSize();
	}
	function setSize(w:Number, h:Number) {
		//_global.tt("setSize "+(this._parent.width-this._width)/2);
		//this._x = (this._parent.width)/2;
		//this._y = (this._parent.height-this._height)/2;
		this.info._x = (this._parent.width/2)-(this._width/2);
		this.info._y = (this._parent.height/2)-(this._height/2);
	}
}
