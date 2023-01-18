import mx.transitions.Tween;
import mx.transitions.easing.Regular;
import mx.utils.Delegate;
import flash.filters.*
import eu.orangeflash.lib.simplecomponents.IDateChooserCell;
import eu.orangeflash.lib.simplecomponents.DateChooser;
import eu.orangeflash.lib.simplecomponents.DateChooserDefaultCell;
class eu.orangeflash.lib.simplecomponents.DateChooserFilterCell extends MovieClip implements IDateChooserCell {
	public static var SIZE:Number = 20;
	private var text:TextField;
	private var filter:GlowFilter;
	private var index:Number;
	private var dateChooser:DateChooser;
	private var tween:Tween;
	public function DateChooserFilterCell(x:Number, y:Number, owner:DateChooser, id:Number) {
		createTextField("text", 1, 0, 0, SIZE, SIZE);
		text.setNewTextFormat(new TextFormat("Tahoma", 10, 0x000000, false, false, false, null, null, "center"));
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
		tween.continueTo(10);
	}
	private function onRollOut():Void {
		clearTweenEvents();
		tween.continueTo(0);
	}
	private function initTween():Void {
		filter = new GlowFilter(0xFF6600,1,5,5,3,2);
		tween = new Tween(filter, "blurX", Regular.easeIn, 5, 0, 1, true);
		tween.onMotionChanged = Delegate.create(this, updateFilter);
	}
	private function updateFilter():Void {
		filter.blurY = filter.blurX;
		text.filters = [filter];
	}
	private function clearTweenEvents():Void {
		delete tween.onMotionFinished;
		tween.stop();
	}
}
