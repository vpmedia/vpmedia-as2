// special thanks to Robert Penner (www.robertpenner.com) for providing the
// original code for this in ActionScript 1 on the FlashCoders mailing list
// origin code by darron schall
class com.vpmedia.managers.RegistrationManager extends MovieClip {
	private var xreg:Number;
	private var yreg:Number;
	function RegistrationManager() {
		setRegistration(0, 0);
	}
	function setRegistration(x:Number, y:Number):Void {
		this.xreg = x;
		this.yreg = y;
	}
	function get _x2():Number {
		var a = {x:this.xreg, y:this.yreg};
		this.localToGlobal(a);
		this._parent.globalToLocal(a);
		return a.x;
	}
	function set _x2(value:Number):Void {
		var a = {x:this.xreg, y:this.yreg};
		this.localToGlobal(a);
		this._parent.globalToLocal(a);
		this._x += value-a.x;
	}
	function get _y2():Number {
		var a = {x:this.xreg, y:this.yreg};
		this.localToGlobal(a);
		this._parent.globalToLocal(a);
		return a.x;
	}
	function set _y2(value:Number):Void {
		var a = {x:this.xreg, y:this.yreg};
		this.localToGlobal(a);
		this._parent.globalToLocal(a);
		this._y += value-a.y;
	}
	function set _xscale2(value:Number):Void {
		setPropRel("_xscale", value);
	}
	function get _xscale2():Number {
		return this._xscale;
	}
	function set _yscale2(value:Number):Void {
		setPropRel("_yscale", value);
	}
	function get _yscale2():Number {
		return this._yscale;
	}
	function set _rotation2(value:Number):Void {
		setPropRel("_rotation", value);
	}
	function get _rotation2():Number {
		return this._rotation;
	}
	function get _xmouse2():Number {
		return this._xmouse-this.xreg;
	}
	function get _ymouse2():Number {
		return this._ymouse-this.yreg;
	}
	private function setPropRel(property:String, amount:Number):Void {
		var a = {x:this.xreg, y:this.yreg};
		this.localToGlobal(a);
		this._parent.globalToLocal(a);
		this[property] = amount;
		var b = {x:this.xreg, y:this.yreg};
		this.localToGlobal(b);
		this._parent.globalToLocal(b);
		this._x -= b.x-a.x;
		this._y -= b.y-a.y;
	}
}
