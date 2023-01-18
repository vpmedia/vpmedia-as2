/**
* @author Patrick Matte
* last revision January 30th 2006
*/

class demos.bitmapData.MovieClipReference {
	
	public var targetMovieClip:MovieClip;
	
	public function MovieClipReference(targetMovieClip){
		this.targetMovieClip = targetMovieClip;
	}
	
	public function gotoAndStop(frame:Number):Void{
		targetMovieClip.gotoAndStop(frame);
	}
	
	public function set _x(newX:Number):Void{
		targetMovieClip._x = newX;
	}
			
	public function set _y(newY:Number):Void{
		targetMovieClip._y = newY;
	}
	
	public function set _yscale(newYScale:Number):Void{
		targetMovieClip.scale = newYScale;
	}
			
	public function set _xscale(newXScale:Number):Void{}
			
	public function set _visible(value:Boolean):Void{
		targetMovieClip._visible = value;
	}
			
	public function swapDepths(newDepth:Boolean):Void{
		targetMovieClip.swapDepths(newDepth);
	}
	
	public function get _totalframes():Number{
		return targetMovieClip._totalframes;
	}
	
}