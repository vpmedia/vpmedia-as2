// special thanks to Robert Penner (www.robertpenner.com) for providing the
// original code for this in ActionScript 1 on the FlashCoders mailing list

dynamic class com.darronschall.DynamicRegistration {
	
	private function DynamicRegistration() {
		
	}
	
	public static function initialize(target_mc):Void {
		var p = _global.com.darronschall.DynamicRegistration.prototype;
		target_mc.xreg = 0;
		target_mc.yreg = 0;
		target_mc.setRegistration = p.setRegistration;
		target_mc.setPropRel = p.setPropRel;
		with (target_mc) {
			addProperty("_x2", p.get_x2, p.set_x2);
			addProperty("_y2", p.get_y2, p.set_y2);
			addProperty("_xscale2", p.get_xscale2, p.set_xscale2);
			addProperty("_yscale2", p.get_yscale2, p.set_yscale2);
			addProperty("_rotation2", p.get_rotation2, p.set_rotation2);
			addProperty("_xmouse2", p.get_xmouse2, null);
			addProperty("_ymouse2", p.get_ymouse2, null);
		}
	}

	private function setRegistration(x:Number, y:Number):Void {
		this.xreg = x;
		this.yreg = y;
	}
	
	private function get_x2():Number {
		var a = {x:this.xreg, y:this.yreg};
 		this.localToGlobal(a);
		this._parent.globalToLocal(a);
 		return a.x;
	}
	
	private function set_x2(value:Number):Void {
		var a = {x:this. xreg, y:this. yreg};;
		this.localToGlobal(a);
		this._parent.globalToLocal(a);
		this._x += value - a.x;
	}

	private function get_y2():Number {
		var a = {x:this.xreg, y:this.yreg};
 		this.localToGlobal(a);
		this._parent.globalToLocal(a);
 		return a.y;
	}
	
	private function set_y2(value:Number):Void {
		var a = {x:this.xreg, y:this.yreg};
		this.localToGlobal(a);
		this._parent.globalToLocal(a);
		this._y += value - a.y;
	}
	
	private function set_xscale2(value:Number):Void {
		this.setPropRel("_xscale", value);
	}
	
	private function get_xscale2():Number {
		return this._xscale;
	}
	
	private function set_yscale2(value:Number):Void {
		this.setPropRel("_yscale", value);
	}
	
	private function get_yscale2():Number {
		return this._yscale;
	}
	
	private function set_rotation2(value:Number):Void {
		this.setPropRel("_rotation", value);
	}
	
	private function get_rotation2():Number {
		return this._rotation;
	}
	
	private function get_xmouse2():Number {
		return this._xmouse - this.xreg;
	}
	
	private function get_ymouse2():Number {
		return this._ymouse - this.yreg;
	}

	private function setPropRel(property:String, amount:Number):Void {
		var a = {x:this.xreg, y:this.yreg};
		this.localToGlobal (a);
		this._parent.globalToLocal (a);
		this[property] = amount;
		var b = {x:this.xreg, y:this.yreg};
		this.localToGlobal (b);
		this._parent.globalToLocal (b);
		this._x -= b.x - a.x;
		this._y -= b.y - a.y;
	}
}