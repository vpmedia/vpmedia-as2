import mx.transitions.Tween;
import mx.transitions.easing.Regular;
import mx.utils.Delegate;
import flash.filters.*
import eu.orangeflash.lib.simplecomponents.IDateChooserCell;
import eu.orangeflash.lib.simplecomponents.DateChooser;
import eu.orangeflash.lib.simplecomponents.DateChooserDefaultCell;
class eu.orangeflash.lib.simplecomponents.DateChooserBlurCell extends MovieClip implements IDateChooserCell {
	public static var SIZE:Number = 20;
	private var text:TextField;
	private var blur:BlurFilter;
	private var index:Number;
	private var dateChooser:DateChooser;
	private var tween:Tween;
	public function DateChooserBlurCell(x:Number, y:Number, owner:DateChooser, id:Number) {
		createTextField("text", 1, 0, 0, SIZE, SIZE);
		text.setNewTextFormat(new TextFormat("Tahoma", 9, 0x000000, true, false, false, null, null, "center"));
		text.selectable = false;
		//
		dateChooser = owner;
		//
		_x = x;
		_y = y;
		//
		index = id;
		//
		initTween();
	}
	public function setDate(val:String):Void {
		text.text = val;
	}
	//
	private function onRollOver():Void {
		clearTweenEvents();
		tween.continueTo(5);
		tween.onMotionFinished = Delegate.create(this, reverse);
	}
	private function onRollOut():Void {
		clearTweenEvents();
		tween.continueTo(0);
	}
	private function initTween():Void {
		blur = new BlurFilter(5, 5, 1);
		tween = new Tween(blur, "blurX", Regular.easeIn, 5, 0, 1, true);
		tween.onMotionChanged = Delegate.create(this, updateFilter);
	}
	private function updateFilter():Void {
		blur.blurY = blur.blurX;
		text.filters = [blur];
	}
	private function reverse():Void {
		tween.yoyo();
		delete tween.onMotionFinished;
	}
	private function clearTweenEvents():Void {
		delete tween.onMotionFinished;
		tween.stop();
	}
}
