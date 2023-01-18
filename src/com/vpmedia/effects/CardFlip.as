// implementations
import flash.filters.*;
import flash.geom.*;
import flash.display.*;
import mx.transitions.*;
import mx.transitions.easing.*;
// start class
class com.vpmedia.effects.CardFlip {
	// START CLASS
	public var className:String = "CardFlip";
	public var classPackage:String = "com.vpmedia.effects";
	public var version:String = "1.0.0";
	public var author:String = "András Csizmadia";
	//
	private var cardWrapper:MovieClip;
	private var cardFront:MovieClip;
	private var cardBack:MovieClip;
	private var cardBackLinkageID:String;
	private var cardSide:Number = 1;
	private var flipComplete:Boolean = false;
	private var xAxis:Number;
	private var dropShadow:DropShadowFilter = null;
	function CardFlip (cardW:MovieClip, back:String, xa:Number, ds:DropShadowFilter) {
		cardWrapper = cardW;
		cardBackLinkageID = back;
		//init card
		cardWrapper.createEmptyMovieClip ("back", cardWrapper.getNextHighestDepth ());
		cardBack = cardWrapper.back;
		cardBack._visible = false;
		cardBack.attachMovie (cardBackLinkageID, "mc", cardBack.getNextHighestDepth ());
		xAxis = xa;
		if (ds) {
			dropShadow = ds;
			cardWrapper.filters = [ds];
		}
	}
	public function flip (t, b, r1, r2) {
		flipComplete = false;
		var time:Number = t;
		var blurAmt:Number = b;
		switch (cardSide) {
		case 1 :
			cardSide = 2;
			var cfrTween = new Tween (cardWrapper, "_rotation", Strong.easeIn, cardWrapper._rotation, r2, time, true);
			break;
		case 2 :
			cardSide = 1;
			var cfrTween = new Tween (cardWrapper, "_rotation", Strong.easeIn, cardWrapper._rotation, r1, time, true);
			break;
		}
		var myBlur:BlurFilter = new BlurFilter (0, 0, 3);
		cardWrapper.filters = [myBlur, dropShadow];
		var blurTween = new Tween (myBlur, "blurX", Strong.easeIn, blurAmt, blurAmt, time, true);
		blurTween.cRef = this;
		blurTween.onMotionChanged = function () {
			this.cRef.cardWrapper.filters = [myBlur, this.cRef.dropShadow];
		};
		var cfTween = new Tween (cardWrapper, "_xscale", Strong.easeIn, 100, 0, time, true);
		var cfxTween = new Tween (cardWrapper, "_x", Strong.easeIn, xAxis, xAxis + cardWrapper._width / 2, time, true);
		cfTween.cRef = this;
		cfTween.onMotionFinished = function () {
			if (this.cRef.cardSide == 1) {
				this.cRef.cardBack._alpha = 0;
				this.cRef.cardBack._visible = false;
			} else {
				this.cRef.cardBack._visible = true;
				this.cRef.cardBack._alpha = 100;
			}
			if (flipComplete != true) {
				cfTween.yoyo ();
				cfxTween.yoyo ();
				flipComplete = true;
			} else {
				this.cRef.cardWrapper.filters = [new BlurFilter (0, 0, 3), this.cRef.dropShadow];
			}
		};
	}
}
