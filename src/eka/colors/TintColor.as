
import eka.colors.* ;

class eka.colors.TintColor extends BasicColor {

	// ----o Author Properties

	public static var className:String = "TintColor" ;
	public static var classPackage:String = "eka.colors";
	public static var version:String = "1.0.0";
	public static var author:String = "ekameleon";
	public static var link:String = "http://www.ekameleon.net" ;

	// -----o Constructor

	public function TintColor (mc:MovieClip) { super(mc) }

	// -----o Public Methods

	public function getTint():Object {
		var t:Object = getTransform();
		var percent:Number = 100 - t.ra ;
		var ratio:Number = 100 / percent;
		return { 
			percent: percent ,
			r : t.rb * ratio ,
			g : t.gb * ratio ,
			b : t.bb * ratio 
		}
	}

	public function setTint(r:Number, g:Number, b:Number, percent:Number):Void {
		var ratio:Number = percent / 100;
		var t:Object = { rb:r*ratio, gb:g*ratio, bb:b*ratio }
		t.ra = t.ga = t.ba = 100-percent ;
		setTransform (t);
	}

	public function getTint2():Object {
		var t:Object = getTransform();
		var percent:Number = 100 - t.ra ;
		var ratio:Number = 100 / percent ;
		return { 
			percent:percent ,
			rgb:ColorRGB.rgb2hex(t.rb*ratio, t.gb*ratio, t.bb*ratio) 
		}
	}
	
	public function setTint2(hex:Number, percent:Number):Void {
		var c:Object = ColorRGB.hex2rgb (hex) ;
		var ratio:Number = percent / 100 ;
		var t:Object = {rb:c.r*ratio, gb:c.g*ratio, bb:c.b*ratio};
		t.ra = t.ga = t.ba = 100-percent;
		setTransform (t);
	}


	public function setTintOffset(r:Number, g:Number, b:Number):Void {
		var t:Object = getTransform();
		with (t) { rb = r ; gb = g ; bb = b }
		setTransform (t);
	}

	public function getTintOffset():Object {
		var t:Object = getTransform() ;
		return {r:t.rb, g:t.gb, b:t.bb} ;
	}

}
