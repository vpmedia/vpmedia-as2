import net.manaca.ui.controls.skin.ICheckBoxSkin;
import net.manaca.ui.awt.Dimension;
import net.manaca.lang.event.ButtonEvent;
import net.manaca.ui.controls.skin.mnc.CheckBoxSkin;
import net.manaca.ui.controls.SimpleButton;
/** 在复选框上单击（松开）鼠标时，或者如果复选框具有焦点并按下空格键时触发 */
[Event("click")]
/**
 * 复选框 组件
 * @author Wersling
 * @version 1.0, 2006-5-18
 */
class net.manaca.ui.controls.CheckBox extends SimpleButton {
	private var className : String = "net.manaca.ui.controls.CheckBox";
	private var _skin:ICheckBoxSkin;
	private var _selected : Boolean  = false;
	private var _toggle : Boolean = true;
	public function CheckBox(target:MovieClip,new_name:String) {
		super(target,new_name);
		_skin = new CheckBoxSkin();
		_preferredSize = new Dimension(100,22);
		
		paintAll();
		_labelHolder = _skin.getTextHoder();
		toggle = _toggle;
		selected = _selected;
		label = "CheckBox";
	}
	
	/**
	 * 获取和设置在复选框旁边出现的文本
	 * @param  value:String - 
	 * @return String 
	 */
	public function set label(value:String) :Void{
		_label = value;
		_labelHolder.text = _label;
		_skin.updateTextFormat();
		_skin.updateChildComponent();
	}
	public function get label() :String{
		return _label;
	}
	
	private function onRelease():Void{
		selected = !selected;
		_skin.onOver();
		this.dispatchEvent(new ButtonEvent(ButtonEvent.CLICK,selected));
	}
}