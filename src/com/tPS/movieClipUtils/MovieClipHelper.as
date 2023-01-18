import flash.geom.Point;
/**
 * Helper 
 * to get additional Props
 * from MovieClips
 * @author tPS
 */
class com.tPS.movieClipUtils.MovieClipHelper {
	
	public static function getCenter(mc:MovieClip) : Point {
		var pt:Point = new Point();
		pt.x = mc._x + (mc._width*.5);
		pt.y = mc._y + (mc._height*.5);
		return pt;
	}
	
}