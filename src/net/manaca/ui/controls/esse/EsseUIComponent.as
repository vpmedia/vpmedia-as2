import net.manaca.ui.UIObject;
import net.manaca.ui.controls.UIComponent;
import net.manaca.util.MovieClipUtil;
import net.manaca.lang.exception.IllegalStateException;
import net.manaca.util.Delegate;
import net.manaca.lang.event.Event;

/**
 * 实际存在可以在IDE中编辑的组件
 * @author Wersling
 * @version 1.0, 2006-5-28
 */
class net.manaca.ui.controls.esse.EsseUIComponent extends UIObject {
	private var className : String = "net.manaca.ui.controls.esse.EsseUIComponent";
	//#include "ComponentVersion.as"
	private var _componentName:String;
	private var _component:UIComponent;
	private var _createFun:Function;
	public function EsseUIComponent() {
		super();
		constructObject();
	}
	private function constructObject() : Void {
		init();
		size();
	}
	private function init():Void{
		super.init();
		if(_createFun == undefined ) throw new IllegalStateException("在初始化组件时，子类没有定义构造方法",this,arguments);
		if(_componentName == undefined ) throw new IllegalStateException("在初始化组件时，子类没有定义组件名称",this,arguments);
		_component = new _createFun(this,_componentName);
		MovieClipUtil.remove(this["__tamping"]);
	}
	/**
	 * 设置组件大小
	 */
	public function setSize(w:Number, h:Number, noEvent:Boolean):Void
	{
		__width = int(w);
		__height = int(h);
		size();
	}
	/**
	 * 更新大小
	 */
	private function size():Void {
		super.size();
		this._xscale =this._yscale = 100;
        _component.setSize(__width,__height);
    }
    
	private function addListener(type:String):Void{
		_component.addEventListener(type,Delegate.create(this,onDispatchEvent));
	}
	private function onDispatchEvent(e:Event) : Void {
		this.dispatchEvent(e);
	}
	/**
	 * 设置组件主题
	 */
	public function setThemes(t):Void{
		_component.setThemes(t);
	}
	/**
	 * 设置全局主题
	 */
	public function setGlobalThemes(t):Void{
		net.manaca.ui.controls.themes.ThemesManager.setDefault(t);
	}
	
	/**
	 * 更新组件，一般在对组件进行了间接的操作时需要执行此操作
	 * @summary 更新组件
	 */
	public function UpdateSkin():Void{
		_component.repaintAll();
	}
}