import net.manaca.ui.UIObject;
import mx.utils.Delegate;
import net.manaca.controls.AbstractListLouse;
/**
 * 
 * @author Wersling
 * @version 1.0, 2006-3-14
 */
class net.manaca.controls.List extends UIObject{
	private var className : String = "net.manaca.controls.List";
	private var up:Button;
	private var down:Button;
	private var SBut:Button;

	private var __w : Number;
	private var __h : Number;
	//可移动区域长度
	private var _theight:Number;
	//需要观察的对象
	private var _Observer:AbstractListLouse;
	public function List() {
		super();
	}
	/** 加载完成执行 */
	public function onLoad():Void{
		super.onLoad();
		init();
	}
	
	public function init():Void{
		__w = this._width;
		__h = this._height;
		this._xscale = this._yscale = 100;
		down._y = __h-down._height;
		SBut._height = 14;
		SBut._visible = false;
		_theight = __h - down._height*2;
	}
		
	public function setObserver(mc:AbstractListLouse):Void{
		_Observer = mc;
		_Observer.watch(_Observer.getAttributeName(),Delegate.create(this,inspect),this);
		inspect();
	}
	
	/**
	 * 检查
	 */
	private function inspect():Void{
		var _sh:Number = _Observer._height;
		if(_sh > __h){
			SBut._visible = true;
			SBut._height = _theight*(__h/_sh);
			SBut._y = 14;
		}else{
			SBut._visible = false;
		}
	}
	
}