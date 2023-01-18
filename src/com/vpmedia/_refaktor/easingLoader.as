/**
 *@description:		A class that manages loading progress and creates an easing loading effect
 *@author:			Michael Bianco, http://developer.mabwebdesign.com/
 *@version:			1.1
 *@requires:		object.as, and the Delegate class
 **/
import Delegate;
class easingLoader {
	//MC Refs
	private var loadingTarget:MovieClip;
	private var loadingText:TextField;
	private var loadingBar;
	private var loadBarRatio:Number;
	private var percent:Number = 0;
	private var dest:Number;
	private var easeSpeed:Number = 10;
	private var interval:Number;
	//BOOLs
	private var pixelFontSafe:Boolean = false;
	//if true the percent text box always lands on a whole pixel
	private var alphaEffect:Boolean = false;
	//if true, an alpha effect is applied on the loading bar
	/**
	     *@description: constructor function
	     *@param: t, the actual bar that you want to represent the progress
	     *@param: w, the width ration that will represent the max width for the bar (IE, 1.5 will make the bar 150px)
	     **/
	function easingLoader (t, w) {
		super ();
		initBroadcaster ();
		loadingBar = t;
		loadBarRatio = w;
		loadingBar._width = 0;
	}
	/**
	     *@description: starts the loading progress
	     *@param: t, the loadingTarget that will be polled asking how much of it is done loading
	     **/
	function doLoadProgress (t:MovieClip) {
		loadingTarget = t;
		interval = setInterval (Delegate.create (this, _doLoadProgress), Math.round (1000 / 30));
	}
	/**
	     *@description: starts the loading progress and utilizes a text field to represent the percent complete also
	     *@param: t, the loadingTarget that will be polled asking how much of it is done loading
	     *@note: the loadingText class variable must be set to the textfield that you want to represent the loading
	     **/
	function doLoadProgressWithText (t:MovieClip) {
		loadingTarget = t;
		interval = setInterval (Delegate.create (this, _doLoadProgressWithText), Math.round (1000 / 30));
	}
	/**
	 *@description: internal loading progress polling function
	 **/
	function _doLoadProgress () {
		updatePercent ();
		updateBar ();
		checkFinished ();
	}
	/**
	 *@description: internal loading progress polling function
	 **/
	function _doLoadProgressWithText () {
		updatePercent ();
		updateBar ();
		updateText ();
		checkFinished ();
	}
	/**
	     *@description: updates the percent class variables by polling loadingTarge for its percent loaded
	     **/
	function updatePercent () {
		var tempPercent = Math.round (loadingTarget.getBytesLoaded () / loadingTarget.getBytesTotal () * 100);
		if (isNaN (tempPercent)) {
			//check for NaN
			tempPercent = 0;
		}
		dest = loadBarRatio * tempPercent;
		return percent = tempPercent;
	}
	/**
	     *@description: updates the loadingBar's _width to represent the loading progress
	     **/
	function updateBar () {
		loadingBar._width += (dest - loadingBar._width) / easeSpeed;
		if (alphaEffect) {
			loadingBar._alpha += (percent - loadingBar._alpha) / easeSpeed;
		}
	}
	/**
	     *@description: updates the the text field to represent the loading progress
	     **/
	function updateText () {
		loadingText._width = Math.round (loadingBar._width);
		loadingText.text = Math.round (loadingBar._width / loadBarRatio) + "%";
	}
	/** 
	     *@description: checks to see if loadingTarget is done loading & the bar has reached its full width
	     **/
	function checkFinished () {
		if (percent == 100 && Math.abs (dest - loadingBar._width) < 1) {
			//once the percent == 100 and the bars animation is done
			setAsFinished ();
		}
	}
	/**
	     *@description: sets the loading bar and the textfield to represent the completed progress
	     **/
	function setAsFinished () {
		//set all the elements to the done posistion
		loadingBar._alpha = 100;
		loadingBar._width = 100 * loadBarRatio;
		loadingText._width = 100 * loadBarRatio;
		//center the text field and say "complete"
		var temp = new TextFormat ();
		temp.align = "center";
		loadingText.setNewTextFormat (temp);
		loadingText.text = "Complete";
		finished ();
	}
	/**
	     *@description: calls when the whole loading progress is complete, this function clears the interval timer
	     *responsible for the loading animation, and broadcasts a loadingComplete event.
	     **/
	function finished () {
		clearInterval (interval);
		dispatchEvent ({type:"loadingComplete"});
	}
}
