import com.tPS.ui.GenericLibraryElement;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.ColorTransform;
import flash.geom.Point;
import com.tPS.utils.FPSCounter;

/**
 * BitmapSubstitute
 * 
 * substitutes given MovieClip 
 * to BitmapData
 * 
 * @author tPS
 */
class com.tPS.movieClipUtils.BitmapSubstitute extends GenericLibraryElement {
	private var bitmap:BitmapData;
	
	function BitmapSubstitute($rt : MovieClip) {
		super($rt);
		init();
	}
	
	private function init() : Void {
		var fps:FPSCounter = new FPSCounter();
		
		//copy mc contents to bitmap
		bitmap = new BitmapData(_rt._width, _rt._height, true, 0x00000000);
		bitmap.draw(_rt);
		//remove clip and draw bitmap
		var pos:Point = new Point(_rt._x, _rt._y);
		_rt = _rt._parent.createEmptyMovieClip(_rt._name,_rt.getDepth());
		_rt._x = pos.x;
		_rt._y = pos.y;
		_rt.attachBitmap(bitmap, 0);
	}
	
	/**
	 * interface
	 */
	public function get _bitmap() : BitmapData {
		return bitmap;
	} 
	
	
	public function toString() : String {
		return "[BitmapSubstitute]";
	}

}