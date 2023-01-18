import com.cetdemi.Timeline.*;
import mx.events.EventDispatcher;
import mx.remoting.debug.NetDebug;

/**
 * Creates a timeline animation. 
 * The Anim class is based on a Singleton pattern, to make sure there is only one running instance of
 * the anim class. This makes overlapping animations impossible (that's good!)
 * 
 * @class com.cetdemi.Timeline.Anim
 */
 
 /**
 * Broadcast when animation advances
 */
 [Event("move")]
 /**
 * Broadcast when animation ends
 */
 [Event("finish")]
class com.cetdemi.Timeline.Anim extends EventDispatcher
{
	/**
	* Center at the begging of the animation
	*/
	private var c1:Number;
	/**
	* Delta of the center
	*/
	private var delc:Number;
	
	/**
	* Inverse of start zoom
	*/
	private var w1:Number;
	/**
	* Delta of the width (1/zoom)
	*/
	private var delw:Number;
	
	/**
	* Index of where the animation is at
	*/
	var index:Number;
	
	/**
	* Simplicity index, used to drop/add frames
	*/
	var simplicity:Number;
	
	/**
	* Total number of steps in the anim
	*/
	var steps:Number;
	
	/**
	* Interval used to advance the anim
	*/
	private var interval;
	
	/**
	* Shortcut for use with Math,sin
	*/
	private var period;
	
	/**
	* getTimer'd value
	*/
	var now;
	
	/**
	* Animation speed
	*/
	var animSpeed;
	
	/**
	* The animation object itself
	*/
	static var anim:Anim;
	
	/**
	 * Animation prototype
	 */
	private function Anim()
	{
		animSpeed = Referencer.getController().params.refAnimSpeed;
	}
	
	/**
	 * Begins the animation
	 * 
	 * @argument o1 The offset at the beginning
	 * @argument z1 The zoom at thee beginning
	 * @argument o2 The offset at thte end
	 * @argument z2 The zoom at the end
	 */
	function begin(o1, z1, o2, z2)
	{
		//Reset tooltip
		_global.tooltip.$tt._visible = false;
		
		var c2;
		var w2;
		var delz;
		var delo;
		
		if(Math.abs(o1 - o2) < 0.001 && Math.abs(z1 - z2) < 0.001)
		{
			return;
		}
		c1 = o1 + 0.5/z1;
		c2 = o2 + 0.5/z2;
		delo = o2 - o1;
		delz = z2 - z1;
		delc = c2 - c1;
		
		//Clear previous animation
		clearInterval(interval);
		
		index = 0;
		
		//Try to find an apprpriate number of steps
		var z_ratio = z2/z1;
		if(z_ratio < 1)
		{
			z_ratio = 1/z_ratio;
		}
		var a = z_ratio*15;
		var b = delc*(z2 + z1)/z_ratio*20;
	
		//Remove Math.round for hilarious results
		//Note that this function is mostly trial and error, 
		//no particularly brilliant algorithm here
		var z_corrector = (z2 + 1)/(z1 + 1) < 1 ? Math.log(z2 + 1)/Math.log(z1 + 1) : Math.log(z1 + 1)/Math.log(z2 + 1);
		z_corrector = 0.25*Math.log(1/z_corrector);
		simplicity = Math.pow(Math.log(z1) + Math.log(z2) - z_corrector, 0.25);

		steps = Math.round(animSpeed*simplicity*3.5) + 2;
		steps = Math.round(Math.min(animSpeed*12, steps));
		interval = setInterval(this, "advance", 15);
		period = Math.PI/steps;
		
		w1 = 1/z1;
		w2 = 1/z2;
		delw = w2 - w1;
		
		//The simplicity index evaluates how easy is an animation, depending on start and end zoom
		now = getTimer();
	}
	
	/**
	 * Moves the timeline
	 *
	 * Some analysis reveals easily that the right curve for speed is sine from 0 to Pi
	 * It rises and then goes down smoothly, which is what is wanted
	 * By integrating, we get int( sin(x) dx ) = -cos(x)
	 * By figuring out the various constants, we get the desired effect
	 */
	private function advance()
	{
		if(index == steps + 1)
		{
			clearInterval(interval);
			interval = false;
			dispatchEvent({type:"finish"});
			return;
		}
		var ctrl = Referencer.getController();

		var t = ((1 - Math.cos(period*index))/2);
		t = Math.pow(t, 0.5);
		if(!t)
		{	
			t = 0;
		}
		
		//Doing this will automagically invalidate render
		var zoom = 1/(delw*t + w1);
		ctrl.renderer.zoom   = zoom
		ctrl.renderer.offset = delc*t + c1 - 0.5/zoom;
		
		dispatchEvent({type:"move"});
		
		if(index == steps)
		{
			if(ctrl.renderer.zoom < 1.001)
			{
				ctrl.renderer.zoom = 1;
			}
			
			//We're trying to enable a more intelligent animation
			//By adjusting animSpeed to fit
			var currLag = ((getTimer() - now)/steps*simplicity*animSpeed/ctrl.params.refAnimSpeed);
			//trace(currLag);
			
			//We want to achieve 30 frames per second
			//simplicity give a minimum vlue around 1.5, so 33.3*1.5 +-= 50
			if (currLag > 30)
			{
				animSpeed = ctrl.params.refAnimSpeed/( 1 + (currLag - 30)/20);
			}
			else
			{
				animSpeed = ctrl.params.refAnimSpeed - (ctrl.params.refAnimSpeed - animSpeed)*0.9;
			}
			//trace('currLag:' + (getTimer() - now)/steps*simplicity);
			
		}
		index++;
	}
	
	/**
	* Singleton access point
	*/
	static function getAnim():Anim
	{
		if(anim == null)
		{
			anim = new Anim();
		}
		return anim;
	}
}