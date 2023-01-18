import eu.orangeflash.effects.TweenEffect;

/**
* Class, moves target.
* 
* @author	Nirth
* @url		http://blog.orangeflash.eu
*/
class eu.orangeflash.effects.Move extends TweenEffect
{
	private var xf:Number;
	private var yf:Number;
	private var xt:Number;
	private var yt:Number;
	
	/**
	* Constructor, creates new Move instance.
	* 
	* @param	target		Object, effect target.
	* @param	easing		Function, easing function, see mx.transitions.easing package.
	* @param	xFrom		Number, start x position.
	* @param	xTo			Number, destination.
	* @param	yFrom		Number stat y position.
	* @param	yTo			Number destination
	* @param	duration	Number, duration in seconds.
	*/
	public function Move(target:Object, easing:Function, xFrom:Number, xTo:Number, yFrom:Number, yTo:Number, duration:Number)
	{
		super(target, easing, duration);
		
		if(xFrom != null && xFrom != undefined)
		{
			xf = xFrom;
			xt = xTo;			
			
			tweens.push(createTween("_x", xf, xt));
		}
		if(yFrom != null && yFrom != undefined)
		{
			yf = yFrom;
			yt = yTo;
			
			tweens.push(createTween("_y", yf, yt));
		}
		
		addTweenEvents();
	}
}