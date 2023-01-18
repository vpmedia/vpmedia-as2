/*
created by Satori Canton
(c) 2005 ActionScript.com
*/
class com.actionscript.transitions.ClipMask extends MovieClip {
	
	private var _mask:MovieClip;
	private var _image:MovieClip;
	private var _wOffset:Number;
	private var _hOffset:Number;
	
	function ClipMask() {
		
	}
	public function createMask(w:Number, h:Number):Void {
		this._wOffset = w/2;
		this._hOffset = h/2;
		var m:MovieClip = this.createEmptyMovieClip("_mask", 10);
		m.beginFill(0x000000);
		m.moveTo(-this._wOffset, -this._hOffset);
		m.lineTo(this._wOffset, -this._hOffset);
		m.lineTo(this._wOffset, this._hOffset);
		m.lineTo(-this._wOffset, this._hOffset);
		m.endFill();
		if(this._image != undefined) {
			this._image.setMask(m);
		}
	}
	public function setImage(s:String):Void {
		var m:MovieClip = this.attachMovie(s, "_image", 20);
		if(this._mask != undefined) {
			m.setMask(this._mask);
			this.setOffset(0, 0);
		}
	}
	public function setOffset(x:Number, y:Number):Void {
		this._image._x = -x - this._wOffset;
		this._image._y = -y - this._hOffset;
	}
}