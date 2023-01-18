import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.skin.SkinFactory;
import net.manaca.ui.awt.Dimension;
import net.manaca.util.Delegate;
import net.manaca.lang.event.Event;
import net.manaca.ui.controls.skin.mnc.LabelSkin;
import net.manaca.ui.controls.skin.ILabelSkin;

/**
 * Label 类的属性允许您在运行时为标签指定文本，指明文本是否可采用 HTML 格式，以及标签是否自动调整大小以适应文本。
 * @author Wersling
 * @version 1.0, 2006-5-17
 */
class net.manaca.ui.controls.Label extends UIComponent {
	private var className : String = "net.manaca.ui.controls.Label";
	private var _skin:ILabelSkin;
	private var _label:TextField;
	private var _html : Boolean;
	private var _autoSize : String;
	private var _text : String;
	public function Label(target : MovieClip, new_name : String) {
		super(target, new_name);
//		_skin = SkinFactory.getInstance().getDefault().createLabelSkin();
		_skin = new LabelSkin();
		_preferredSize = new Dimension(100,22);
		
		this.paint();
		
		_label = _skin.getTextHoder();
		html = false;
		_label.wordWrap = false;
		_label.multiline = false;
		_label.selectable = false;
		autoSize = "none";
		text = "Label";
	}
	
	/**
	 * 获取 TextField 对象
	 */
	public function getTextField():TextField{
		return _label;
	}
	
	/**
	 * 获取和设置标签上的文本
	 * @param  value:String - 
	 * @return String 
	 */
	public function set text(value:String) :Void{
		_text = value;
		if(html){ 
			_label.htmlText = _text;
		}else{
			_label.text = _text;
		}
		_skin.updateTextFormat();
	}
	public function get text() :String{
		return _text;
	}
	
	/**
	 * 获取和设置一个字符串，指示如何调整标签大小和对齐标签以适合其 text 属性的值。有四种可能的值："none"、"left"、"center" 和 "right"。默认值为 "none"。
	 * @param  value:String - 
	 * @return String 
	 */
	public function set autoSize(value:String) :Void{
		_autoSize = value;
		_label.autoSize = value;
	}
	public function get autoSize() :String{
		return _autoSize;
	}
	
	/**
	 * 获取和设置是否支持HTML，默认 false
	 * @param  value:Boolean - 
	 * @return Boolean 
	 */
	public function set html(value:Boolean) :Void{
		_html = value;
		_label.html = value;
	}
	public function get html() :Boolean{
		return _html;
	}
	

}