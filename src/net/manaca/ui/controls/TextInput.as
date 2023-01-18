import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.skin.ITextInputSkin;
import net.manaca.ui.controls.skin.SkinFactory;
import net.manaca.ui.awt.Dimension;
import TextField.StyleSheet;
import net.manaca.lang.event.Event;
import net.manaca.util.Delegate;
import net.manaca.ui.controls.skin.mnc.TextInputSkin;
/** 当 TextInput 字段更改时广播 */
[Event("change")]
/** 当按下 Enter 键时广播 */
[Event("enter")]
/**
 * 可输入的文本
 * @author Wersling
 * @version 1.0, 2006-5-19
 * @Event 
 * 	<li>Event.CHANGE</li>
 * 	<li>Event.ENTER</li>
 */
class net.manaca.ui.controls.TextInput extends UIComponent {
	private var className : String = "net.manaca.ui.controls.TextInput";
	private var _componentName:String  = "TextInput";
	private var _skin:ITextInputSkin;
	private var _label:TextField;
	private var _editable : Boolean = true;

	private var _angle : Array = [0,0,0,0];
	public function TextInput(target:MovieClip,new_name:String) {
		super(target,new_name);
//		_skin = SkinFactory.getInstance().getDefault().createTextInputSkin();
		_skin = new TextInputSkin();
		_preferredSize = new Dimension(100,20);
		this.paintAll();
		_label = _skin.getTextField();
		editable = _editable;
		
		_label.onChanged = Delegate.create(this,onTextChanged);
		_label.onSetFocus  = Delegate.create(this,onSetFocus);
		Key.addListener(_label);
		//焦点处理
		_label.onKillFocus = Delegate.create(this,onKillFocus);
		_label.onSetFocus = Delegate.create(this,onSetFocus);
		_label.onKeyUp = Delegate.create(this,onLabelKeyUp);
		
	}
	/**
	 * 获取和设置按钮四角的弧度，默认值为[0,0,0,0]
	 * @param  value  参数类型：Array 
	 * @return 返回值类型：Array 
	 */
	public function set angle(value:Array) :Void{
		_angle = value;
		this.repaint();
	}
	public function get angle() :Array{
		return _angle;
	}
	
	/**
	 * 获取和设置该字段是 (true) 否 (false) 可编辑
	 * @param  value:Boolean - 
	 * @return Boolean 
	 */
	public function set editable(value:Boolean) :Void
	{
		_editable = value;
		_label.type = (_editable) ? "input" :  "dynamic";
	}
	public function get editable() :Boolean
	{
		return _editable;
	}
	
	/**
	 * 获取和设置文本在字段中的水平位置。默认值为 0。
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set hPosition(value:Number) :Void
	{
		_label.hscroll = value;
	}
	public function get hPosition() :Number
	{
		return _label.hscroll;
	}
	/**
	 * 获取文本区域中的字符数
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function get length() :Number
	{
		return _label.length;
	}
	
	/**
	 * 获取和设置文本区域最多可以容纳的字符数，默认为 null
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set maxChars(value:Number) :Void
	{
		_label.maxChars = value;
	}
	public function get maxChars() :Number
	{
		return _label.maxChars;
	}
		
	/**
	 * 获取和设置指示字段是 (true) 否 (false) 为密码字段，默认为 false
	 * @param  value:Boolean - 
	 * @return Boolean 
	 */
	public function set password(value:Boolean) :Void
	{
		_label.password = value;
	}
	public function get password() :Boolean
	{
		return _label.password;
	}
	
	/**
	 * 获取和设置用户可在文本区域中输入的字符集，默认为 null
	 * @param  value:String - 
	 * @return String 
	 */
	public function set restrict(value:String) :Void
	{
		_label.restrict = value;
	}
	public function get restrict() :String
	{
		return _label.restrict;
	}
	
	/**
	 * 获取和设置文本内容
	 * @param  value:String - 
	 * @return String 
	 */
	public function set text(value:String) :Void
	{
		_label.text = value;
		_label.setTextFormat(this.getTextFormat());
		this.dispatchEvent(new Event(Event.CHANGE,value));
	}
	public function get text() :String
	{
		return _label.text;
	}
	
	private function onTextChanged() : Void {
		this.dispatchEvent(new Event(Event.CHANGE,text));
	}
	
	private function onLabelKeyUp ():Void{
		if(isFocus()){
			switch (Key.getCode()) {
			    case Key.ENTER :
			   	this.dispatchEvent(new Event(Event.ENTER,text));
			    break;
			}
		}
	}
}