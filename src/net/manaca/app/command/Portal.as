import net.manaca.lang.BObject;
import net.manaca.app.command.Command;

/**
 * 程序入口
 * @author Wersling
 * @version 1.0, 2005-12-3
 * @author
 */
class net.manaca.app.command.Portal extends BObject {
	private var className : String = "net.manaca.app.command.Portal";
	private static var _Portal : Portal;
	private var _target:MovieClip;
	public static function main(mc:MovieClip):Void{
		if (_Portal == undefined){
			_Portal = new Portal(mc);
		}else{
			Tracer.warn("应用已存在，不能重复建立！");
		}
	}
	/**
	 * 构造函数
	 * @param mc:MovieClip - 构造目标位置，一般为_root
	 */
	public function Portal(mc:MovieClip){
		if(mc == undefined){
			 Tracer.error("缺少必要参数!");
			 return ;
		}
		_target = mc;
		init();
	}
	
	private function init():Void{
		//Mouse.hide();
		new Command(_target);
	}
}