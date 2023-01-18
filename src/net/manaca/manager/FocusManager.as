import net.manaca.lang.BObject;
import net.manaca.ui.controls.UIComponent;

/**
 * 简单的焦点管理
 * @author Wersling
 * @version 1.0, 2006-5-16
 */
class net.manaca.manager.FocusManager {
	private var className : String = "net.manaca.manager.FocusManager";
	private static var instance : FocusManager;
	private var _nowFocusHoder:UIComponent;
	/**
	 * @return singleton instance of FocusManager
	 */
	public static function getInstance() : FocusManager {
		if (instance == null)
			instance = new FocusManager();
		return instance;
	}
	
	private function FocusManager() {
		super();
	}
	
	
	public function setFocus(arg0 : UIComponent) : Void {
		if(arg0 != _nowFocusHoder){
			_nowFocusHoder.onKillFocus(arg0);
			arg0.onSetFocus(_nowFocusHoder);
			_nowFocusHoder = arg0;
		}
	}
	
	public function getFocus():UIComponent{
		return _nowFocusHoder;
	}
}