
/**
 * 
 * @author Wersling
 * @version 1.0, 2006-4-6
 */
class net.manaca.ui.awt.Point {
	private var className : String = "net.manaca.ui.awt.Point";
	private var __x:Number;
	private var __y:Number;
	public function Point(x:Number,y:Number) {
		super();
		__x = x;
		__y = y;
	}
	public function getX():Number{
		return __x;
	}
	public function getY():Number{
		return __y;
	}
	public function setY(y : Number) : Void {
		__y = y;
	}
	
	public function setX(x : Number) : Void {
		__x = x;
	}

}