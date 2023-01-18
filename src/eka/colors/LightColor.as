
import eka.colors.* ;

class eka.colors.LightColor extends BasicColor {

	// ----o Author Properties

	public static var className:String = "LightColor" ;
	public static var classPackage:String = "eka.colors";
	public static var version:String = "1.0.0";
	public static var author:String = "ekameleon";
	public static var link:String = "http://www.ekameleon.net" ;

	// -----o Constructor

	public function LightColor (mc:MovieClip) { super (mc) }

	// -----o Virtual Properties

	public function get brightness ():Number { return getBrightness() }
	public function set brightness(percent:Number):Void { setBrightness(percent) }
	public function get contrast() { return getContrast() }
	public function set contrast(percent:Number):Void { setContrast(percent) }
	public function get brightOffset():Number { return getBrightOffset() }
	public function set brightOffset(offset:Number):Void { setBrightOffset(offset) }
	public function get negative():Number { return getNegative() }
	public function set negative(percent:Number):Void { setNegative(percent) }

	// -----o Public Methods

	public function getBrightness():Number {
		var t:Object = getTransform();
		with (t) return rb ? 100-ra : ra-100;
	}

	public function setBrightness(percent:Number):Void {
		var t:Object = getTransform();
		with (t) {
			ra = ga = ba = 100 - Math.abs (percent) ;
			rb = gb = bb = (percent > 0) ? (percent*2.56) : 0 ;
		}
		setTransform (t);
	}

	public function getContrast():Number { return getTransform().ra }

	public function setContrast(percent:Number):Void {
		var t:Object = {};
		t.ra = t.ga = t.ba = percent;
		t.rb = t.gb = t.bb = 128 - (128/100 * percent);
		setTransform(t);
	}

	public function getBrightOffset():Number { return getTransform().rb }

	public function setBrightOffset(offset:Number):Void {
		var t:Object = getTransform()
		with (t) rb = gb = bb = offset;
		setTransform (t);
	}

	public function getNegative():Number { return getTransform().rb * 2.55 }

	public function setNegative(percent:Number):Void {
		var t:Object = {} ;
		t.ra = t.ga = t.ba = 100 - 2 * percent;
		t.rb = t.gb = t.bb = percent * (2.55) ;
		setTransform (t);
	}

}
