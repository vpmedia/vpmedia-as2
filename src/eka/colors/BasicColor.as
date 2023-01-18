
import eka.utils.* ;
import eka.colors.* ;

class eka.colors.BasicColor extends Color {

	// ----o Author Properties

	public static var className:String = "BasicColor" ;
	public static var classPackage:String = "eka.colors";
	public static var version:String = "1.0.0";
	public static var author:String = "ekameleon";
	public static var link:String = "http://www.ekameleon.net" ;

	// -----o Private MovieClip

	private var _mc:MovieClip;
	
	// -----o Constructor

	public function BasicColor (mc:MovieClip) { 
		super (mc) ;
		_mc = mc ;
	}

	// -----o Public Methods

	public function reset(Void):Void { ColorUtils.reset(this) }

	public function invert(Void):Void { ColorUtils.invert(this) }

	public function getTarget(Void):MovieClip { return _mc }

	
}
