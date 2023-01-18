import mx.managers.DepthManager;
import mx.utils.Delegate;

/*
 	Class: CursorManager

	Manager for cursors

	Author:
		Carlos Rovira - carlos.rovira@lycos.es
		
		<http://www.carlosrovira.com>

	Package:
		com.carlosrovira.managers
	
	Usage:
	
		- First import and get the sigleton instance as follows:
		>	import com.carlosrovira.managers.CursorManager;
		>	var c:CursorManager = CursorManager.getCursorManager();
	
		- To set a MovieClip cursor with the "loading_arrow" identifier:
	
		>	c.setCursor("loading_arrow");
	
		- If you don't want to hide default cursor:
	
		>	c.setCursor("loading_arrow", true);
		
		- To remove the cursor:
		
		>	c.removeCursor();
	
	See Also:
		<mx.managers.DepthManager>
		<mx.utils.Delegate>
*/
class com.carlosrovira.managers.CursorManager { 

	/* Property: cursorInstance
	
		Holds the unique class instance allowed
	*/
	private static var cursorInstance:CursorManager;
	
	/* Property: cursor
		The current cursor
	*/
	private var cursor:MovieClip;
	private static var cursorID:Number;
	
	/*
		Function: getCursorManager
	
		CursorManager is a Singleton and this is the function to retrieve the unique instance
	
		Returns:
	
			The CursorManager reference
	*/
	public static function getCursorManager():CursorManager {
		
		if(cursorInstance == null) {
			cursorInstance = new CursorManager();
			return cursorInstance;
		} else {
			return cursorInstance;
		}
	}
	
	/*
		Function: CursorManager (Constructor)
	
		Private constructor (to complete the Singleton)
	
		Returns:
	
			Nothing
	*/
	private function CursorManager() {
		
	}
	
	/*
		Function: setCursor
	
		Changes the current cursor for another movieclip
	
		Parameters:
		
			cursorReference - (String) the movieclip's identifier
			dontHideDefault - (Boolean) false to hide the SO cursor, true to show.
			
		Returns:
	
			Nothing
	*/
	public function setCursor(cursorReference:String, dontHideDefault:Boolean):Number {
		
		// --- Remove posible cursor
		removeCursor();
		
		// --- Create Instance with DepthManager at kCursor special depth
		cursor = DepthManager.createObjectAtDepth(
				cursorReference, 
				DepthManager.kCursor, 
				{_x:_root._xmouse, _y:_root._ymouse}
			); 
		cursor.onMouseMove = Delegate.create(this, moveCursor);
		
		// --- Add Listener so cursor follows mouse
		Mouse.addListener(cursor); 
		
		// --- Maybe you don't want to hide default cursor ;)
		if(!dontHideDefault)
			Mouse.hide();
			
		cursorID = Math.round(Math.random()*(100));
		
		return cursorID;
	}
	
	/*
		Function: removeCursor
	
		Removes the current cursor
	
		Returns:
	
			Nothing
	*/
	public function removeCursor(ID:Number):Void {
		
		Mouse.removeListener(cursor);
		Mouse.show();
		
		//if(cursorID == ID)
			cursor.removeMovieClip();
		
		cursor = null;
		cursorID = null;
	}
	
	/*
		Function: moveCursor
	
		Handler for onMouseMove event
	
		Returns:
	
			Nothing
	*/
	private function moveCursor():Void { 
		cursor._x = _root._xmouse; 
		cursor._y = _root._ymouse;
		
		updateAfterEvent();
	}
} 
