import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.skin.IButtonSkin;
import net.manaca.lang.event.ButtonEvent;
import net.manaca.util.Delegate;
/**
 * 当用户在按钮上单击并释放鼠标
 */
[Event("release")]
/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-30
 */
class net.manaca.ui.controls.SimpleButton extends UIComponent {
	private var className : String = "net.manaca.ui.controls.SimpleButton";
	private var _skin:IButtonSkin;
	private var _toggle : Boolean;
	private var _selected : Boolean;
	private var _label : String;
	private var _labelHolder:TextField;
	function SimpleButton(target : MovieClip, new_name : String) {
		super(target, new_name);
		_domain.onRelease = Delegate.create(this,onRelease);
		_domain.onPress = Delegate.create(this,onPress);
		_domain.onRollOver = Delegate.create(this,onRollOver);
		_domain.onRollOut = Delegate.create(this,onRollOut);
		_domain.onReleaseOutside = Delegate.create(this,onReleaseOutside);
	}
	
	/**
	 * 在按钮上显示的文本
	 * @param  value:String 
	 * @return String
	 */
	public function set label(value:String) :Void{
		_label = value;
		_labelHolder.text = value;
		_skin.updateTextFormat();
		_skin.updateChildComponent();
	}
	public function get label() :String{
		return _label;
	}
	
	/**
	 * 按钮的行为与切换开关相同 (true) 还是不同 (false)。默认值为 false。
	 * @param  value  参数类型：Boolean 
	 * @return 返回值类型：Boolean 
	 */
	public function set toggle(value:Boolean) :Void{
		_toggle = value;
	}
	public function get toggle() :Boolean{
		return _toggle;
	}
	
	/**
	 * 获取和设置按钮处于选中状态 (true) 还是未处于选中状态 (false)。默认值为 false。
	 * @param  value  参数类型：Boolean 
	 * @return 返回值类型：Boolean 
	 */
	public function set selected(value:Boolean) :Void{
		_selected = value;
		if(toggle && _selected){
			_skin.setSelected(true);
		}else{
			_skin.setSelected(false);
		}
	}
	public function get selected() :Boolean{
		if(!toggle) return false;
		return _selected;
	}
	
	private function onPress():Void{
		_skin.onDown();
	}
	private function onRelease():Void{
		_skin.onOver();
		this.dispatchEvent(new ButtonEvent(ButtonEvent.RELEASE));
	}
	private function onReleaseOutside():Void{
		_skin.onOut();
		this.dispatchEvent(new ButtonEvent(ButtonEvent.RELEASE_OUT_SIDE));
	}
	private function onRollOver():Void{
		_skin.onOver();
		this.dispatchEvent(new ButtonEvent(ButtonEvent.ROLL_OVER));
	}
	private function onRollOut():Void{
		_skin.onOut();
		this.dispatchEvent(new ButtonEvent(ButtonEvent.ROLL_OUT));
	}
}