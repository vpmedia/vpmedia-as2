import net.manaca.lang.BObject;
import net.manaca.lang.event.ButtonEvent;

/**
 *  RadioButton 组件控制对象
 * @author Wersling
 * @version 1.0, 2006-5-27
 */
class net.manaca.ui.controls.radioButtonClasses.RadioButtonGroup extends BObject {
	private var className : String = "net.manaca.ui.controls.radioButtonClasses.RadioButtonGroup";
	private var groupList : Array ;
	private var _now_obj:Object;
	public function RadioButtonGroup(){
		super();
		groupList = new Array();
	}
	/** 添加RadioButton */
	public function addRadio(obj:Object):Void
	{
		groupList.push(obj);
		setButton(obj);
	}
	/** 处理数据 */
	public function setButton(obj:Object){
		if (obj.selected){
			var i = groupList.length;
			var __GroupName:String = obj.groupName;
			while(--i-(-1)){
				if (groupList[i] != obj){
					groupList[i].setSelected(false);
				}
			}
			_now_obj = obj;
			this.dispatchEvent(new ButtonEvent(ButtonEvent.CLICK,_now_obj.data,_now_obj));
		}
		
	}

	private function setSelection(data:Object){
		var i = groupList.length;
		while(--i-(-1)){
			if (groupList[i].data == data){
				if(_now_obj != groupList[i]){
					groupList[i].setSelected(true);
					setButton(groupList[i]);
				}
			}
		}
	}
	
	/**
	 * 获取和设置被选择的值
	 * @param  value:Object - 
	 * @return Object 
	 */
	public function set selection(value:Object) :Void{
		this.setSelection(value);
	}
	public function get selection() :Object{
		return  this._now_obj.data;
	}
}