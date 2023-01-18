import net.manaca.lang.BObject;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.ui.controls.UIComponent;

/**
 * 组件皮肤
 * @author Wersling
 * @version 1.0, 2006-5-11
 */
class net.manaca.ui.controls.skin.Skin extends BObject{
	private var className : String = "net.manaca.ui.controls.skin.Skin";
	private var _element_list:Object;
	private var _displayObject : MovieClip;
	private var _component : UIComponent;
	static private var _DepthManager:Object;
	private function Skin() {
		super();
	}
	
	static public function getDepth(mcName:String):Number{
		if(_DepthManager == undefined){
			_DepthManager = new Object();
			_DepthManager["Label"] = 500;
			_DepthManager["Icon"] = 501;
			_DepthManager["ControlBackground"] = 5;
			_DepthManager["ControlBorder"] = 10;
			
			_DepthManager["SelectedSkin"] = 25;
			_DepthManager["ControlHighLight"] = 20;
			_DepthManager["ControlLight"] = 30;
			_DepthManager["ControlInsideLight"] = 40;
			_DepthManager["Control"] = 50;
			
			_DepthManager["WindowBorder"] = 10;
			_DepthManager["WindowHighLightBorder"] = 20;
			_DepthManager["WindowBack"] = 30;
			_DepthManager["WindowTop"] = 60;
			_DepthManager["WindowBottom"] = 61;
			_DepthManager["WindowInsertBox"] = 70;
			_DepthManager["WindowInsertBox1"] = 71;
			_DepthManager["WindowInsertBox2"] = 72;
			
		}
		return _DepthManager[mcName];
	}
	/**
	 * 获取指定的元素
	 * @param name 元素名称
	 */
	public function getElement(name : String) : MovieClip {
		return _displayObject[name];
	}

	/**
	 * 设置显示皮肤的对象
	 */
	public function setDisplayObject(component : UIComponent) : Void {
		_element_list= new Object();
		if(component !=undefined) {
			_component = component;
			_displayObject = component.getDisplayObject();
		}else{
			throw new IllegalArgumentException("缺少必要参数",this,arguments);
		}
	}
	
	
	private function createEmptyMc(mcName:String):MovieClip{
		if(_displayObject[mcName] == undefined){
			_displayObject[mcName] = _displayObject.createEmptyMovieClip(mcName,getDepth(mcName));
			_displayObject[mcName].focusEnabled = false;
			//_displayObject[mcName].tabChildren = false;
			_displayObject[mcName].tabEnabled = false;
		}else{
			_displayObject[mcName].clear();
		}
		return _displayObject[mcName];
	}
	/**
	 * 指定深度
	 */
	private function createEmptyMcByDepth(mcName:String,depth:Number):MovieClip{
		if(_displayObject[mcName] == undefined){
			_displayObject[mcName] = _displayObject.createEmptyMovieClip(mcName,depth);
			_displayObject[mcName].focusEnabled = false;
			//_displayObject[mcName].tabChildren = false;
			_displayObject[mcName].tabEnabled = false;
		}else{
			_displayObject[mcName].clear();
		}
		return _displayObject[mcName];
	}
}