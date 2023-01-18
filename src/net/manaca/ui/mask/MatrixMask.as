import net.manaca.ui.mask.AbstractMask;
import net.manaca.ui.mask.IMask;
import net.manaca.util.MovieClipUtil;
import net.manaca.ui.mask.app.IMaskApp;
import net.manaca.ui.mask.app.ObliqueApp;
import net.manaca.ui.mask.app.ShutterApp;
import net.manaca.ui.mask.app.PortraitAlternationApp;
import net.manaca.ui.mask.app.TransverseAlternationApp;
import net.manaca.ui.mask.app.CircleApp;
import net.manaca.ui.mask.MaskItem;
/**
 * 
 * @author Wersling
 * @version 1.0, 2005-12-7
 */
class net.manaca.ui.mask.MatrixMask extends AbstractMask implements IMask{
	private var className : String = "net.manaca.ui.mask.SquareMoveMask";
	//加载MC名称
	private var item : MaskItem;
	//--------------------------------
	//矩阵
	private var matrix:Array;
	private var _App:IMaskApp;
	//
	var VisibleNum:Number;
	var _Time:Number;

	private var _Pace : Number;
	/**
	 * 构造函数
	 * @param mc 存放Mask元件
	 * @param itemName 一个遮罩单元
	 */
	public function MatrixMask(mc:MovieClip,item:MaskItem) {
		super(mc);
		this.item = item;
		matrix = new Array();
	}
	/**
	 * 构建Mask
	 * @param width Mask宽度
	 * @param height Mask高度
	 * @param fun 出现方式，默认 obliqueApp
	 */
	public function crudeMask(width : Number, height : Number,fun:String) : Void {
		clear();
		//
		var W = Math.ceil (width / item.w);
		var H = Math.ceil (height / item.h);
		//建立Mask矩阵
		for (var i = 0; i<W; i++) {
			var b:Array = new Array();
			for (var j = 0; j<H; j++) {
				b[j] = "action_"+i+"|"+j;
				maskHoder.attachMovie(item.cellName, b[j], maskHoder.getNextHighestDepth());
				maskHoder[b[j]]._x = i*item.w;
				maskHoder[b[j]]._y = j*item.h;
				maskHoder[b[j]].stop();
				//trace("action_"+(i*10+j));
			}
			matrix[i] = b;
		}
		if(fun){
			this[fun]();
		}else{
			this["obliqueApp"]();
		}
	}
	/**
	 * 斜扫
	 */
	public function obliqueApp():Void{
		_App = new ObliqueApp(matrix,maskHoder);
		_App.start(Pace);
	}
	/**
	 * 百页窗
	 */
	public function shutterApp():Void{
		_App = new ShutterApp(matrix,maskHoder);
		_App.start(Pace);
	}
	/**
	 * 横向间隔
	 */
	public function portraitAlternationApp():Void{
		_App = new PortraitAlternationApp(matrix,maskHoder);
		_App.start(Pace);
	}
	/**
	 * 纵向交叉
	 */
	public function transverseAlternationApp():Void{
		_App = new TransverseAlternationApp(matrix,maskHoder,Boolean(random(2)));
		_App.start(Pace);
	}
	/**
	 * 环绕
	 */
	public function circleApp():Void{
		_App = new CircleApp(matrix,maskHoder);
		_App.start(Pace/2);
	}
	
	/**
	 * 删除Mask
	 */
	public function clear():Void{
		for (var i : Number = 0; i < matrix.length; i++) {
			for (var j : Number = 0; j < matrix[i].length; j++) {
				MovieClipUtil.remove(maskHoder[matrix[i][j]]);
			}
		}
		matrix = new Array();
	}
	/**
	 * 遮罩速度
	 * @param  value  参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function set Pace(value:Number) :Void
	{
		_Pace = value;
	}
	public function get Pace() :Number
	{
		return _Pace;
	}
}