/**
 *@author Michael Bianco, http://developer.mabwebdesign.com/
 *@class easingScrollBar
 *@description a class to create an easing scroller
 *@version 1.2
 **/
class easingScrollBar extends MovieClip {
	private var target;
	private var lockPos:Array;
	private var scrollHeight:Number = 110;
	// the amount that the scrollbar can scroll
	private var easeSpeed:Number = 5;
	private var offSet:Number = 0;
	public var pixelFontSafe:Boolean = true;
	// if true, makes pixel fonts clear
	public var snapToExactPixels:Boolean = false;
	//if true, the scroller will make sure the content holder scrolls to the exact pixel
	public var noReverseScroll:Boolean = false;
	//if true, prevents the reverse scroll that occurs when the content is less than
	function easingScrollBar () {
		super ();
		initLockPos ();
	}
	/**
	 *@description inits the locking positions for the scrollers. 
	 *Use this function to re-init the locking position after initalization time
	 **/
	public function initLockPos ():Void {
		offSet = this._y;
		//the locking positions for stopDrag()
		lockPos = [this._x, this._y, this._x, this._y + scrollHeight];
	}
	private function onPress () {
		startDrag (this, false, lockPos[0], lockPos[1], lockPos[2], lockPos[3]);
	}
	private function onRelease () {
		stopDrag ();
	}
	private function onReleaseOutside () {
		stopDrag ();
	}
	/**
	 *@description sets the target for the scroller
	 *@param t the target holder that is being masked
	 *@param m the mask
	 **/
	public function setTarget (t, m):Void {
		if (noReverseScroll && t._height < m._height) {
			return;
		}
		target = t;
		target.path = this;
		//fract = height of the text-field or MC - height of the viewable area + the offset of the textfield divided by the scroll height
		target.fract = (t._height - m._height + t._y) / scrollHeight;
		target.oldY = 0;
		target.offSet = t._y;
		target.onEnterFrame = function () {
			var dest = -(((this.path._y - this.path.offSet) * this.fract) - this.offSet), i, l, p;
			//i = increment, l = distance left to go, p = pixelFontSafe
			this._y += (i = (p = this.path.pixelFontSafe) ? Math.round ((dest - this._y) / this.path.easeSpeed) : (dest - this._y) / this.path.easeSpeed);
			if (this.path.snapToExactPixels) {
				if (Math.abs (l = (dest - this._y)) < this.path.easeSpeed && i == 0 && p && l != 0) {
					l /= 5;
					this._y += p ? Math.round (l) : l;
				}
				else if (Math.abs (l) < 2 && l != 0) {
					this._y = Math.round (dest);
					//watch out for this line
				}
			}
		};
	}
}
