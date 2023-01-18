import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.ui.paint.Pencil;
/**
 * 重现画板
 * @author Wersling
 * @version 1.0, 2006-4-20
 */
class net.manaca.ui.print.PaintRecur {
	private var className : String = "net.manaca.ui.print.PaintRecur";

	private var _paint_mc : MovieClip;
	private var _obj:Object;
	/**
	 * 构造函数
	 * @param 无
	 */
	public function PaintRecur(mc:MovieClip) {
		super();
		if(mc != undefined){
			_paint_mc = mc;
		}else{
			throw new IllegalArgumentException("在构造一个铅笔绘画工具时缺少画板参数",this,arguments);
		}
		_obj = new Object();
	}
	
	/**
	 * 运行一个命令
	 */
	public function runRecur(command:String):Void{
		
		if(command.indexOf("Draw_Pancil@") != -1) {
			Draw_Pancil(command);
		}
		
	}
	
	/**
	 * 运行一组命令
	 */
	public function runRecurs(commands:Array):Void{
		for (var i : Number = 0; i < commands.length; i++) {
			var command:String = commands[i];
			if(command.indexOf("Draw_Pancil@") != -1) {
				Draw_Pancil(command);
			}
		}
		
	}
	
	/**
	 * 执行铅笔绘制命令
	 */
	private function Draw_Pancil(command:String):Void{
		if(_obj["Draw_Pancil"] != undefined){
			var dp:Pencil = _obj["Draw_Pancil"];
		}else{
			var dp:Pencil = new Pencil(_paint_mc);
			_obj["Draw_Pancil"] = dp;
		}
		var _arr:Array = command.split(",");
		if(command.indexOf("Draw_Pancil@init") != -1) {
			dp.setStyle(Number(_arr[1]),Number(_arr[2]),Number(_arr[3]));
		}
		if(command.indexOf("Draw_Pancil@start") != -1) {
			dp.startDraw(Number(_arr[1]),Number(_arr[2]),_arr[3]);
		}
		if(command.indexOf("Draw_Pancil@draw") != -1) {
			dp.draw(Number(_arr[1]),Number(_arr[2]));
		}
		if(command.indexOf("Draw_Pancil@end") != -1) {
			dp.endDraw();
			_obj["Draw_Pancil"] = undefined;
		}
	}
}