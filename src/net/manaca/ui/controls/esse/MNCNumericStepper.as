import net.manaca.ui.controls.esse.EsseUIComponent;
import net.manaca.ui.controls.NumericStepper;
import net.manaca.lang.event.Event;
[IconFile("icon/NumericStepper.png")]
[Event("change")]
/**
 * NumericStepper 组件
 * @author Wersling
 * @version 1.0, 2006-5-28
 */
class net.manaca.ui.controls.esse.MNCNumericStepper extends EsseUIComponent {
	private var className : String = "net.manaca.ui.controls.esse.MNCNumericStepper";
	private var _componentName:String = "MNCNumericStepper";
	private var _component:NumericStepper;
	private var _createFun:Function = NumericStepper;

	private var _maximum : Number = 100;
	private var _minimum : Number = 0;
	private var _stepSize : Number = 1;
	private var _value : Number = 0;
	public function MNCNumericStepper() {
		super();
	}
	private function init():Void{
		super.init();
		value = _value;
		stepSize = _stepSize;
		maximum = _maximum;
		minimum = _minimum;
		this.addListener(Event.CHANGE);
	}
	
	/**
	 * 获取和设置最大范围值的数字，默认 100
	 * @param  value:Number - 
	 * @return Number 
	 */
	[Inspectable(name="maximum",type=Number,defaultValue=100 )]
	public function set maximum(value:Number) :Void{
		_maximum = value;
		_component.maximum = _maximum;
	}
	public function get maximum() :Number{
		return _maximum;
	}
	
	/**
	 * 获取和设置最小范围值的数字，默认 0
	 * @param  value:Number - 
	 * @return Number 
	 */
	[Inspectable(name="minimum",type=Number,defaultValue= 0)]
	public function set minimum(value:Number) :Void{
		_minimum = value;
		_component.minimum = _minimum;
	}
	public function get minimum() :Number{
		return _minimum;
	}
	
	/**
	 * 获取和设置每次单击的变化单位，默认 1
	 * @param  value:Number - 
	 * @return Number 
	 */
	[Inspectable(name="stepSize",type=Number,defaultValue=1 )]
	public function set stepSize(value:Number) :Void{
		_stepSize = value;
		_component.stepSize = _stepSize;
	}
	public function get stepSize() :Number{
		return _stepSize;
	}
	
	/**
	 * 获取和设置当前值，默认 0
	 * @param  value:Number - 
	 * @return Number 
	 */
	[Inspectable(name="value",type=Number,defaultValue= 0 )]
	public function set value(value:Number) :Void{
		_value = value;
		_component.value = _value;
	}
	public function get value() :Number{
		return _value;
	}
}