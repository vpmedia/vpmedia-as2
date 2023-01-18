import net.manaca.ui.awt.Dimension;
import net.manaca.ui.controls.UIComponent;
import net.manaca.lang.event.ButtonEvent;
import net.manaca.ui.controls.skin.IButtonSkin;
import net.manaca.ui.controls.skin.mnc.ButtonSkin;
import net.manaca.ui.controls.SimpleButton;
/**
 * 当用户在按钮上单击鼠标
 */
[Event("press")]

/**
 * 按钮
 * Button 类的属性使您可以在运行时执行以下操作：给按钮添加图标、创建文本标签以及指示按钮用作普通按钮还是切换开关
 * @author Wersling
 * @version 1.0, 2006-4-5
 */
class net.manaca.ui.controls.Button extends SimpleButton {
	private var className : String = "net.manaca.ui.controls.Button";
	private var _componentName:String = "Button";
	private var _skin:IButtonSkin;
	private var _icontHolder:MovieClip;
	private var _icon:String;
	private var _selected : Boolean = false;
	private var _toggle : Boolean = false;
	private var _continuous : Boolean=false;
	private var _angle : Array = [1,1,1,1];
	private var _initial:Number;
	private var _refurbish:Number;
	/**
	 * 构造一个Button
	 * @param target 寄主
	 * @param new_name 元件名称
	 */
	public function Button(target:MovieClip,new_name:String) {
		super(target,new_name);
		_skin = new ButtonSkin();
		_preferredSize = new Dimension(100,22);
		
		paintAll();
		
		_labelHolder = _skin.getTextHolder();
		_icontHolder = _skin.getIconHolder();
		toggle = _toggle;
		selected = _selected;
		//this.label = "Button";
	}
	/**
	 * 获取可以绘制ICON的平台
	 * @return MovieClip
	 */
	public function getIconPanel():MovieClip{
		return _icontHolder;
	}
	
	/**
	 * 指定按钮实例的图标
	 * @param icon:String
	 * @return String
	 */
	public function set icon(icon:String):Void{
		var _ic:MovieClip = _icontHolder;
		_icon = icon;
		var _result = true;
		if(icon){
			var _result = _ic.attachMovie(_icon,"_b_icon",_ic.getNextHighestDepth());
			if(_result == undefined) _result = false;
		}else{
			_result = false;
		}
		
		if(!_result){
			for(var i in _ic){
				_ic[i].removeMovieClip();
			}
		}
		_skin.updateChildComponent();
	}
	public function get icon():String{
		return _icon;
	}
	
	/**
	 * 获取和设置按钮四角的弧度，默认值为[1,1,1,1]
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
	 * 获取和设置是否连续不断的抛出 PRESS 事件，默认 false
	 * @param  value:Boolean - 
	 * @return Boolean 
	 */
	public function set continuous(value:Boolean) :Void{
		_continuous = value;
	}
	public function get continuous() :Boolean{
		return _continuous;
	}
	private function onPress():Void{
		super.onPress();
		this.dispatchEvent(new ButtonEvent(ButtonEvent.PRESS));
		clearInterval(_initial);
		clearInterval(_refurbish);
		if(_continuous) _initial = setInterval(this,"refurbish",500);
	}
	private function refurbish():Void{
		clearInterval(_refurbish);
		_refurbish = setInterval(this,"pop",25);
	}
	private function pop():Void{
		this.dispatchEvent(new ButtonEvent(ButtonEvent.PRESS));
	}
	private function onRelease():Void{
		clearInterval(_initial);
		clearInterval(_refurbish);
		selected = !selected;
		
		super.onRelease();
	}
	private function onReleaseOutside():Void{
		clearInterval(_initial);
		clearInterval(_refurbish);
		
		super.onReleaseOutside();
	}
}