import net.manaca.lang.BObject;
import net.manaca.util.Delegate;
import net.manaca.lang.event.Event;

/**
 * 文本输入控制器
 * @author Wersling
 * @version 1.0, 2006-6-21
 */
class net.manaca.app.command.InputText extends BObject {
	private var className : String = "net.manaca.app.command.InputText";
	private var _input_text:TextField;
	private var _kill_focus_time : Number;
	public function InputText(input_text:TextField) {
		super();
		_input_text = input_text;
		_input_text.onChanged = Delegate.create(this,onTextChanged);
		_input_text.onKillFocus = Delegate.create(this,onTextKillFocus);
		Key.addListener(this);
		setFocus();
	}
	
	/**
	 * 清除数据
	 */
	public function clear():Void{
		
	}
	
	/**
	 * 文本发生改变
	 */
	private function onTextChanged() : Void {
		this.dispatchEvent(new Event("onChanged"));
	}
	
	private function onKeyDown():Void{
		if(Key.getCode() == Key.ENTER && _input_text.is){
			this.dispatchEvent(new Event("onEnter",_input_text.text));
			trace(_input_text.text);
		}
	}
	private function onTextKillFocus() : Void {
		trace(_input_text.text);
		clearInterval(_kill_focus_time);
		_kill_focus_time = setInterval(this,"setFocus",50);
	}
	
	private function setFocus():Void{
		clearInterval(_kill_focus_time);
		Selection.setFocus(_input_text);
		Selection.setSelection(_input_text.text.length, _input_text.text.length);
	}
}