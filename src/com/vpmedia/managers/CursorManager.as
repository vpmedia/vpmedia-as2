import mx.managers.DepthManager;
import mx.utils.Delegate;
/*
Class: CursorManager
import com.carlosrovira.managers.CursorManager;
var c:CursorManager = CursorManager.getCursorManager();
c.setCursor("loading_arrow");
c.setCursor("loading_arrow", true);
c.removeCursor();
See Also:
<mx.managers.DepthManager> - http://livedocs.macromedia.com/flash/mx2004/main_7_2/wwhelp/wwhimpl/js/html/wwhelp.htm?href=00002429.html
<mx.utils.Delegate> - http://livedocs.macromedia.com/flash/mx2004/main_7_2/wwhelp/wwhimpl/js/html/wwhelp.htm?href=00002429.html
*/
class com.vpmedia.managers.CursorManager {
	private static var cursorInstance:CursorManager;
	private var cursor:MovieClip;
	private static var cursorID:Number;
	public static function getCursorManager ():CursorManager {
		if (cursorInstance == null) {
			cursorInstance = new CursorManager ();
			return cursorInstance;
		}
		else {
			return cursorInstance;
		}
	}
	private function CursorManager () {
	}
	public function setCursor (cursorReference:String, dontHideDefault:Boolean):Number {
		removeCursor ();
		cursor = DepthManager.createObjectAtDepth (cursorReference, DepthManager.kCursor, {_x:_root._xmouse, _y:_root._ymouse});
		cursor.onMouseMove = Delegate.create (this, moveCursor);
		Mouse.addListener (cursor);
		if (!dontHideDefault) {
			Mouse.hide ();
		}
		cursorID = Math.round (Math.random () * (100));
		return cursorID;
	}
	public function removeCursor (ID:Number):Void {
		Mouse.removeListener (cursor);
		Mouse.show ();
		cursor.removeMovieClip ();
		cursor = null;
		cursorID = null;
	}
	private function moveCursor ():Void {
		cursor._x = _root._xmouse;
		cursor._y = _root._ymouse;
		updateAfterEvent ();
	}
}
