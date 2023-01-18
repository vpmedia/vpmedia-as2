
import eka.colors.* ;

class eka.colors.SolidColor extends BasicColor {

	// ----o Author Properties

	public static var className:String = "SolidColor" ;
	public static var classPackage:String = "eka.colors";
	public static var version:String = "1.0.0";
	public static var author:String = "ekameleon";
	public static var link:String = "http://www.ekameleon.net" ;

	// -----o Constructor

	public function SolidColor (mc:MovieClip) { super(mc) }

	// -----o Virtual Properties

	public function get red():Number { return getRed() }
	public function set red(amount:Number):Void{ setRed(amount) }
	public function get green():Number { return getGreen() }
	public function set green(amount:Number) { setGreen(amount) }
	public function get blue():Number { return getBlue() }
	public function set blue(amount:Number):Void { setBlue(amount) }
	public function get redPercent():Number { return getRedPercent() }
	public function set redPercent(percent:Number):Void { setRedPercent(percent) }
	public function get greenPercent():Number { return getGreenPercent() }
	public function set greenPercent(percent:Number):Void { setGreenPercent(percent) }
	public function get bluePercent():Number { return getBluePercent() }
	public function set bluePercent(percent:Number):Void { setBluePercent(percent) }
	public function get redOffset():Number { return getRedOffset() }
	public function set redOffset(offset:Number):Void { setRedOffset(offset) }
	public function get greenOffset():Number { return getGreenOffset() }
	public function set greenOffset(offset:Number):Void { setGreenOffset(offset) }
	public function get blueOffset():Number { return getBlueOffset() }
	public function set blueOffset(offset:Number):Void { setBlueOffset(offset) }

	// -----o Public Methods

	public function getRGB2():Object {
		var t:Object = getTransform() ;
		return {r:t.rb, g:t.gb, b:t.bb} ;
	}
	
	public function setRGB2(r:Number, g:Number, b:Number):Void  { 
		setRGB (ColorRGB.rgb2hex(r,g,b)) ; 
	} 

	public function getRed():Number { return getTransform().rb }
	public function setRed(amount:Number):Void{
		var t:Object = getTransform();
		setRGB (ColorRGB.rgb2hex(amount, t.gb, t.bb)) ;
	}

	public function getGreen():Number { return getTransform().gb }
	public function setGreen(amount:Number) {
		var t:Object = getTransform();
		setRGB (ColorRGB.rgb2hex(t.rb, amount, t.bb)) ;
	}

	public function getBlue():Number { return getTransform().bb }
	public function setBlue(amount:Number):Void {
		var t:Object = getTransform() ;
		setRGB (ColorRGB.rgb2hex(t.rb, t.gb, amount)) ;
	}

	public function getRedPercent():Number { return getTransform().ra }
	public function setRedPercent(percent:Number):Void {
		var t:Object = getTransform();
		t.ra = percent ; setTransform (t) ; 
	}

	public function getGreenPercent():Number { return getTransform().ga }
	public function setGreenPercent(percent:Number):Void {
		var t:Object = getTransform();
		t.ga = percent ; setTransform (t);
	}

	public function getBluePercent():Number { return getTransform().ba }
	public function setBluePercent(percent:Number):Void {
		var t:Object = getTransform();
		t.ba = percent ; setTransform (t);
	}

	public function getRedOffset():Number { return getTransform().rb }
	public function setRedOffset(offset:Number):Void {
		var t:Object = getTransform() ;
		t.rb = offset ; setTransform (t) ;
	}

	public function getGreenOffset():Number { return getTransform().gb }
	public function setGreenOffset(offset:Number):Void {
		var t:Object = getTransform();
		t.gb = offset; setTransform (t);
	}

	public function getBlueOffset():Number { return getTransform().bb }
	public function setBlueOffset(offset:Number):Void {
		var t:Object = getTransform() ;
		t.bb = offset ; setTransform (t);
	}

}
