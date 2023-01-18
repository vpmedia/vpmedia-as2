import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.skin.INumericStepperSkin;
import net.manaca.ui.controls.skin.SkinFactory;
import net.manaca.ui.awt.Dimension;
import net.manaca.ui.controls.TextInput;
import net.manaca.lang.event.ButtonEvent;
import net.manaca.util.Delegate;
import net.manaca.ui.controls.skin.mnc.NumericStepperSkin;

/**
 * NumericStepper 组件允许用户逐个通过一组经过排序的数字。
 * 该组件由显示在小上下箭头按钮旁边的文本框中的数字组成。
 * 用户按下按钮时，数字将根据 stepSize 参数中指定的单位递增或递减，
 * 直到用户释放按钮或达到最大或最小值为止。NumericStepper 组件的文本框
 * 中的文本也是可编辑的。
 * @author Wersling
 * @version 1.0, 2006-5-19
 */
class net.manaca.ui.controls.NumericStepper extends UIComponent {
	private var className : String = "net.manaca.ui.controls.NumericStepper";
	private var _componentName:String = "NumericStepper";
	private var _skin:INumericStepperSkin;
	private var _up_but:net.manaca.ui.controls.Button;
	private var _down_but:net.manaca.ui.controls.Button;
	private var _input_text:TextInput;
	private var _maximum : Number = 100;
	private var _minimum : Number = 0;
	private var _stepSize : Number = 1;
	private var _value : Number = 0;
	/**
	 * 构造一个NumericStepper
	 * @param target : MovieClip - 构造位置
	 * @param new_name : String - 名称
	 * @param max 允许最大值 
	 * @param min 允许最小值
	 * @param step 每次单击的变化单位
	 */
	public function NumericStepper(target : MovieClip, new_name : String,max:Number,min:Number,step:Number) {
		super(target, new_name);
//		_skin = SkinFactory.getInstance().getDefault().createNumericStepperSkin();
		_skin = new NumericStepperSkin();
		_preferredSize = new Dimension(100,18);
		
		if(max != undefined) maximum = max;
		if(min != undefined) _minimum = min;
		if(step != undefined) stepSize = step;
		
		this.paintAll();
		
		init();
	}
	/** 构建按钮 */
	private function init():Void{
		_up_but = _skin.getUpButton();
		_down_but = _skin.getDownButton();
		_input_text = _skin.getTextInput();
		
		_input_text.text = String(_value);
		var t:TextFormat = _input_text.getTextFormat();
		t.align = "center";
		_input_text.setTextFormat(t);
		
		_input_text.addEventListener(ButtonEvent.ENTER,Delegate.create(this,onInputEnter));
		_up_but.addEventListener(ButtonEvent.PRESS,Delegate.create(this,onUpButton));
		_down_but.addEventListener(ButtonEvent.PRESS,Delegate.create(this,onDownButton));
		
	}
	private function onUpButton() : Void {
		value = nextValue;
	}

	private function onDownButton() : Void {
		value = previousValue;
	}
	private function onInputEnter(e:ButtonEvent) : Void {
		var v:Number = Number(e.value);
		v = Math.min(maximum,v);
		v = Math.max(minimum,v);
		value = v;
	}
	/**
	 * 获取和设置最大范围值的数字
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set maximum(__value:Number) :Void
	{
		_maximum = __value;
		if(value > _maximum) value = _maximum;
	}
	public function get maximum() :Number
	{
		return _maximum;
	}
	
	/**
	 * 获取和设置最小范围值的数字
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set minimum(__value:Number) :Void
	{
		_minimum = __value;
		if(value < _minimum) value = _minimum;
	}
	public function get minimum() :Number
	{
		return _minimum;
	}
	
	/**
	 * 获取下一个连续值的数字。该属性为只读
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function get nextValue() :Number
	{
		return (value + stepSize) < maximum ? value + stepSize : maximum;
	}
	/**
	 * 获取前一个连续值的数字。该属性为只读
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function get previousValue() :Number
	{
		return (value - stepSize) > minimum ? value - stepSize : minimum;
	}
	
	/**
	 * 获取和设置每次单击的变化单位
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set stepSize(__value:Number) :Void
	{
		_stepSize = __value;
	}
	public function get stepSize() :Number
	{
		return _stepSize;
	}
	
	/**
	 * 获取和设置
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function set value(__value:Number) :Void
	{
		if(_value != __value){
			if(__value >= minimum && __value <= maximum){
				_value = __value;
				_input_text.text = String(_value);
				this.dispatchEvent(new ButtonEvent(ButtonEvent.CHANGE,_value));
			}
		}
	}
	public function get value() :Number
	{
		return _value;
	}


}