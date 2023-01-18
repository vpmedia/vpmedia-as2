import net.manaca.lang.BObject;
import net.manaca.app.command.InputText;

/**
 * 命令行输入器，可以通过此对象来查看XML数据
 * @author Wersling
 * @version 1.0, 2006-6-21
 */
class net.manaca.app.command.Command extends BObject {
	private var className : String = "net.manaca.app.command.Command";
	private var _target:MovieClip;
	private var _textView:TextField;
	private var _inputText:InputText;
	
	public function Command(mc:MovieClip) {
		super();
		_target = mc;
		_textView = mc._textView;
		_inputText = new InputText(mc._inputText);
		
	}
	
}