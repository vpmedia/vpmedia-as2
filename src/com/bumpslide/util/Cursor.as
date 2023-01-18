import com.bumpslide.util.Delegate;
/**
* Cursor Utility
* 
*/
class com.bumpslide.util.Cursor {
	
	
	static private var holder_mc : MovieClip;
	static private var mouseListener : Object;
	static private var level     : Number = 1;
	
	
	static public function init ( holder ) {		
		holder_mc = holder;		
		mouseListener = { onMouseMove: Delegate.create( Cursor, Cursor.update ) };
	}
	
	static public function display ( linkage_id:String ) {
		if(holder_mc==null) return;
		restore();
		level = level%2+1;
		holder_mc.attachMovie( linkage_id, 'cursor'+level, level, {_x: holder_mc._xmouse, _y: holder_mc._ymouse });
		
		Mouse.addListener( mouseListener );
		Mouse.hide();
	}
	
	static public function restore () {	
		holder_mc.cursor1.removeMovieClip();
		holder_mc.cursor2.removeMovieClip();
		Mouse.removeListener( mouseListener );
		Mouse.show();
	}
	
	static public function update() {
		holder_mc['cursor'+level]._x = holder_mc._xmouse;
		holder_mc['cursor'+level]._y = holder_mc._ymouse;
	}
	
	static public function getClip() {
		return holder_mc['cursor'+level];
	}
	
	
}