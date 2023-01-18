/**
 * 3D Renderer Class 
 * @author tPS
 * @version 1
 **/
import com.tPS.event.Delegate;

class com.tPS.tween.Thread extends com.tPS.event.AeventSource{
	static private var instance:Thread;
	private var counter:MovieClip;

	private function updateEvent(Void):Void{
		broadcastMessage("update");
	}

	private function Thread(){
		counter = _root.createEmptyMovieClip("thread_mc",_root.getNextHighestDepth());
		counter.onEnterFrame = Delegate.create(this,updateEvent);
	}

	static public function initialize():Thread{
		trace(toString() + " ---> initialize " + (instance == null));
		if(instance == null)
			instance = new Thread();
		return instance;
	}

	static public function beginThread($trgt:Object):Void{
		instance.addListener($trgt);
	}

	static public function endThread($trgt:Object):Void{
		instance.removeListener($trgt);
	}
	
	static public function toString() : String {
		return "[Thread]";
	}
	
}