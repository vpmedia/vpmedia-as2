import com.tPS.ui.GenericLibraryElement;
import com.tPS.tween.Thread;

/**
 * @author tPS
 */
class com.tPS.movieClipUtils.EndlessStripe extends GenericLibraryElement {
	private var speed:Number;
	private var origin:Number;
	private var elapsed:Number;	
	
	function EndlessStripe($rt : MovieClip, $speed : Number) {
		super($rt);
		speed = $speed;
		setup();
		init();
	}
	
	private function setup() : Void {
		Thread.initialize();
	}
	
	private function init() : Void {
		origin = _rt._x;
		elapsed = 0;
		Thread.beginThread(this);
	}
	
	private function update() : Void {
		_rt._x += speed;
		
		elapsed += Math.abs(speed);
		if(elapsed >= _rt._width)
			reset();
	} 
	
	public function remove() : Void {
		Thread.endThread(this);
		broadcastMessage("removeStripe", this);		
	}
	
	public function reset() : Void {
		_rt._x = origin;
		init();
	}
	
	public function pause($pause:Boolean) : Void {
		if($pause){
			Thread.endThread(this);
		}else{
			Thread.beginThread(this);
		}
	}

}