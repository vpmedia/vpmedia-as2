import net.manaca.lang.BObject;
import net.manaca.lang.exception.IllegalArgumentException;

/**
 * 抽象Mask动作，负责基本操作
 * @author Wersling
 * @version 1.0, 2005-12-7
 */
class net.manaca.ui.mask.app.AbstractMaskApp extends BObject {
	private var className : String = "net.manaca.ui.mask.app.AbstractMaskApp";
	//矩阵
	private var matrix : Array;
	//Mask元素拥有者
	private var maskHoder : MovieClip;
	//一个记录数据者
	private var VisibleNum:Number;
	//时间控制
	private var _Time : Number;

	private var Pace : Number;
	/**
	 * 构造函数
	 * @param 无
	 */
	public function AbstractMaskApp(matrix:Array,mc:MovieClip) {
		if(!matrix) throw new IllegalArgumentException("在建立Mask动作时缺少矩阵列表",this,[matrix]);
		if(!mc) throw new IllegalArgumentException("在建立Mask动作时缺少Mask宿主",this,[mc]);
		this.matrix = matrix;
		maskHoder = mc;
		Pace = 24;
		VisibleNum = 0;
		
	}
	/**
	 * 开始执行
	 */
	public function start(pace:Number):Void{
		if(pace) Pace = pace;
		_Time = setInterval(this, "defer", 100);
	}
	private function defer():Void{
		clearInterval(_Time);
		_Time = setInterval(this, "App", Pace);
	}
}