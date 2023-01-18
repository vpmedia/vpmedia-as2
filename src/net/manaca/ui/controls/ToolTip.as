import net.manaca.ui.textField.TextDisplay;
import net.manaca.util.StringUtil;
import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.skin.mnc.ToolTipSkin;

/**
 * ToolTip 用于显示ToolTipManager抛出的提示显示信息
 * @author Wersling
 * @version 1.0, 2006-4-30
 */
class net.manaca.ui.controls.ToolTip extends UIComponent {
	private var className : String = "net.manaca.ui.controls.ToolTip";
	private var _textField:TextField;
	private var _componentName : String = "ToolTip";
	private var _tf : TextFormat;

	private var _stat_text : Object;
	private var _end_text : String;
	public function ToolTip(target : MovieClip, new_name : String) {
		super(target, new_name);
		_skin =new  ToolTipSkin();
		
		_textField = _domain.createTextField("ToolTip_textField",120,0,0,12,10);
		_textField.autoSize = true;
		_tf = TextDisplay.getFormat();
		_stat_text = "<font face='"+_tf.font+"' color='"+StringUtil.colorToHtml(getThemes().control_text_color)+"' >";
		_end_text = "</font>";
		this.paint();
		this.setVisible(false);
	}
	
	/**
	 * 显示要提示的文本
	 */
	public function showCaption(caption:String):Void{
		TextDisplay.Instance.setHtmlText(_textField,_stat_text+caption+_end_text);
		this.setVisible(true);
		
		rectify();
		setSize(_textField._width,_textField._height);
	}
		
	public function hide():Void{
		_textField.text = "";
		this.setVisible(false);
	}
	
	//调整位置
	private function rectify():Void{
		var x:Number = int(_root._xmouse)+20;
		var y:Number = int(_root._ymouse)+20;
		var sw:Number = Stage.width;
		var sh:Number = Stage.height;
		if(x+_textField._width > sw) x = sw-_textField._width-5;
		if(y+_textField._height > sh) y = sh-_textField._height-5;
		this.setLocation(x,y);
		
	}
}