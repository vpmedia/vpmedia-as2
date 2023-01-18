import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.skin.IRadioButtonSkin;
import net.manaca.ui.awt.Dimension;
import net.manaca.ui.controls.radioButtonClasses.RadioButtonGroup;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.ui.controls.skin.mnc.RadioButtonSkin;
import net.manaca.ui.controls.SimpleButton;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-27
 */
class net.manaca.ui.controls.RadioButton extends SimpleButton {
	private var className : String = "net.manaca.ui.controls.RadioButton";
	private var _componentName = "RadioButton";
	private var _skin:IRadioButtonSkin;
	private var _selected : Boolean  = false;
	private var _toggle : Boolean  = true;
	private var _data : Object;
	private var _groupName : String;
	private var _selection : Object;
	private var _group:RadioButtonGroup;
	/**
	 * 构造一个RadioButton
	 * @param target : MovieClip - 目标位置
	 * @param new_name : String 组件名称
	 * @param _groupName:String - 组名，用于确定那些RadioButton为一组
	 * @throws IllegalArgumentException 在缺少组名时抛出
	 */
	public function RadioButton(target : MovieClip, new_name : String,group:RadioButtonGroup) {
		super(target, new_name);
		_skin = new RadioButtonSkin();
		_preferredSize = new Dimension(100,22);
		
		if(group != undefined) {
			this._group = group;
			_group.addRadio(this);
		}else{
			throw new IllegalArgumentException("在构建RadioButton组件时，缺少必要参数：groupe",this,arguments);
		}
		
		paintAll();
		toggle = _toggle;
		selected = _selected;
		_labelHolder = _skin.getTextHolder();
		this.label = "RadioButton";
	}

	/**
	 * 获取和设置RadioButton 实例关联的数据
	 * @param  value:Object - 
	 * @return Object 
	 */
	public function set data(value:Object) :Void{
		_data = value;
	}
	public function get data() :Object{
		return _data;
	}
	
	/**
	 * 获取单选按钮实例或单选按钮组的 RadioButtonGroup
	 * @param  value:String - 
	 * @return String 
	 */
	public function get group() :RadioButtonGroup{
		return _group;
	}
	
	/**
	 * 获取和设置
	 * @param  value:Boolean - 
	 * @return Boolean 
	 */
	public function set selected(value:Boolean) :Void{
		_selected = value;
		if(toggle){
			if(_selected){
				_skin.setSelected(true);
				_group.setButton(this);
			}else{
				_skin.setSelected(false);
			}
		}
	}
	public function get selected() :Boolean{
		if(!toggle) return false;
		return _selected;
	}
	/**
	 * 设置是否显示
	 */
	private function setSelected(value:Boolean):Void{
		_selected = value;
		_skin.setSelected(_selected);
		
	}
	
	private function onRelease():Void{
		selected = true;
		_skin.onOver();
	}
}