// =========================================================================================
// Interface: Tween_I
// 
// Ryan Taylor
// February 3, 2007
// http://www.boostworthy.com
// =========================================================================================
// 
// +          +          +          +          +          +          +          +          +
// 
// =========================================================================================

interface com.boostworthy.animation.tweens.Tween_I
{
	// =====================================================================================
	// INTERFACE DECLERATIONS
	// =====================================================================================
	
	public function Clone():Tween_I
	public function RenderFrame(nFrame:Number):Void
	public function GetFirstFrame():Number
	public function GetLastFrame():Number
}