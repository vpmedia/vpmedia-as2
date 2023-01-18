// *******************************************
//	 CLASS: ISlide 
//	 by Jens Krause [www.websector.de]
// *******************************************
interface de.websector.games.parachute.slides.ISlide
{
	function init (): Void;
	function initButtons (): Void;
	function onStartTween(): Void;
	function onEndTween (): Void;
}