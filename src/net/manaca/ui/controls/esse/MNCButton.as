import net.manaca.ui.controls.Button;
import net.manaca.lang.event.ButtonEvent;
import net.manaca.ui.controls.esse.EsseUIComponent;
import net.manaca.lang.event.Event;
[IconFile("icon/Button.png")]
/**
 * 在用户点击后并释放鼠标时
 */
[Event("release")]
/**
 * 在用户点击鼠标时，如果用户常按，此事件默认持续抛出
 */
[Event("press")]
/**
 * 按钮组件
 * @book-title sdfsf
 * @author Wersling
 * @version 1.0, 2006-5-28
 * @availability Flash Player 7
 * @search Button
 */
class net.manaca.ui.controls.esse.MNCButton extends EsseUIComponent {
	private var className : String = "net.manaca.ui.controls.esse.MNCButton";
	private var _componentName:String = "MNCButton";
	private var _component:Button;
	private var _createFun:Function = net.manaca.ui.controls.Button;
	//***************以上必须定义*********************
	private var _label : String = "Button";
	private var _icon : String;
	private var _selected : Boolean = false;
	private var _toggle : Boolean = false;
	private var _angle : Array = [1,1,1,1];
	public function MNCButton() {
		super();
	}
	private function init():Void{
		super.init();
		toggle = _toggle;
		selected = _selected;
		angle = _angle;
		label  =_label;
		icon = _icon;
		this.addListener(ButtonEvent.RELEASE);
		this.addListener(ButtonEvent.PRESS);
	}
	/**
	 * 获取可以绘制ICON的平台，通过在此元件上绘制需要的图案，
	 * 建立绘制后需要执行 UpdateSkin 方法
	 * @summary 获取可以绘制ICON的平台
	 */
	public function getIconPanel():MovieClip{
		return _component.getIconPanel();
	}
	/**
	 * 获取和设置按钮文本
	 * @param  value:String - 按钮文本
	 * @return String 
	 */
	[Inspectable(name="label",type=String,defaultValue="Button")]
	public function set label(value:String) :Void{
		_label = value;
		_component.label = _label;
	}
	public function get label() :String{
		return _label;
	}

	/**
	 * 获取和设置按钮图标
	 * @param  value:String - 按钮图标
	 * @return String 
	 */
	[Inspectable(name="icon",type=String)]
	public function set icon(value:String) :Void{
		_icon = value;
		_component.icon = _icon;
	}
	public function get icon() :String{
		return _icon;
	}
	
	/**
	 * 获取和设置是否可选择
	 * @param  value  参数类型：Boolean 
	 * @return 返回值类型：Boolean 
	 */
	[Inspectable(name="selected",type=Boolean,defaultValue=false)]
	public function set selected(value:Boolean) :Void
	{
		_selected = value;
		_component.selected  = _selected;
	}
	public function get selected() :Boolean{
		return _selected;
	}
	
	/**
	 * 是否可选择，默认 false
	 * @param  value  参数类型：Boolean 
	 * @return 返回值类型：Boolean 
	 */
	[Inspectable(name="toggle",type=Boolean,defaultValue=false)]
	public function set toggle(value:Boolean) :Void{
		_toggle = value;
		_component.toggle = _toggle;
	}
	public function get toggle() :Boolean{
		return _toggle;
	}

	/**
	 * 获取和设置按钮四角的弧度，默认 [1,1,1,1]
	 * @param  value  参数类型：Array 
	 * @return 返回值类型：Array 
	 */
	[Inspectable(name="angle",type=Array,defaultValue="1,1,1,1")]
	public function set angle(value:Array) :Void{
		_angle = value;
		_component.angle = _angle;
	}
	public function get angle() :Array{
		return _angle;
	}
}