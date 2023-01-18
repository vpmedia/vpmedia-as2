import mx.transitions.Tween;
import mx.transitions.easing.Strong;
import eu.orangeflash.lib.factory.DisplayFactory;
import eu.orangeflash.lib.utils.Calc;
import eu.orangeflash.lib.simplecomponents.DateChooser;
import eu.orangeflash.lib.simplecomponents.IDateChooserCell;
/**
 * Cell for the DateChooser component
 * 
 * @author  Nirth
 * @version 1.0
 * @see     MovieClip	
 * @see     IDateChooserCell
 * @since   
 */
class eu.orangeflash.lib.simplecomponents.DateChooserDefaultCell extends MovieClip implements IDateChooserCell {
	public static var WIDTH:Number = 19;
	public static var HEIGHT:Number = 17;
	private var tween:Tween;
	private var text:TextField;
	private var fx:MovieClip;
	private var light:MovieClip;
	private var dateChooser:DateChooser;
	private var index:Number;
	private var __enabled;
	//
	public function DateChooserDefaultCell(x:Number, y:Number, owner:DateChooser, id:Number) {
		createTextField("text", 3, 0, 0, WIDTH, HEIGHT);
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
		createFX();
	}
	/**
	 * Method,sets date for IDateChooserCell instance
	 * 
	 * @usage   		myInstance.setDate(31);
	 * @param   val 	String, which represents date
	 * @return  		Nothing
	 */
	public function setDate(val:String):Void {
		text.text = val;
	}
	/**
	* 
	*/
	//public function 
	//
	public function disable():Void
	{
		enabled = false;
		text.setTextFormat(0,2,new TextFormat("Tahoma",9,0x333333,false,false, false, null, null, "center"));
	}
	public function highLight():Void
	{
		createEmptyMovieClip("light", 1);
		light.beginFill(0xFFFFFF, 50);
		light.moveTo(-.5, -.5);
		light.lineTo(WIDTH-1, -1);
		light.lineTo(WIDTH-1, HEIGHT-1);
		light.lineTo(-1, HEIGHT-1);
		light.lineTo(-1, -1);
		light.endFill();
	}
	//Private methods
	//
	private function onRollOver():Void {
		tween.continueTo(100);
	}
	private function onRollOut():Void {
		tween.continueTo(0);
	}
	private function onRelease():Void {
		dateChooser.dispatchEvent({type:'click', target:dateChooser, cell:this, date:text.text, id:index});
	}
	private function createFX():Void {
		createEmptyMovieClip("fx", 2);
		fx.beginFill(0xFFFFFF, 43);
		fx.moveTo(0, 0);
		fx.lineTo(WIDTH, 0);
		fx.lineTo(WIDTH, HEIGHT);
		fx.lineTo(0, HEIGHT);
		fx.lineTo(0, 0);
		fx.endFill();
		//var duration:Number = Calc.round(Calc.random(1.5, 2.5), 3);
		tween = new Tween(fx, "_alpha", Strong.easeOut, WIDTH, 0, .5, true);
	}
}
