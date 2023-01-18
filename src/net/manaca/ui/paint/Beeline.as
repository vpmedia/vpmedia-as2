import net.manaca.lang.BObject;
import net.manaca.ui.paint.Drawing;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.ui.paint.Record;
import net.manaca.ui.paint.BeelineRecord;

/**
 * 绘制直线
 * @author Wersling
 * @version 1.0, 2006-4-23
 */
class net.manaca.ui.paint.Beeline extends BObject implements Drawing {
	private var className : String = "net.manaca.ui.paint.Beeline";
	private var _paint_mc:MovieClip;
	private var _isdraw:Boolean;
	private var _record:Array;
	
	private var _Thickness : Number;
	private var _RGB : Number;
	private var __Alpha : Number;

	private var _now_Record : BeelineRecord;
	
	/**
	 * 构建一个绘制直线的对象
	 * @param 
	 */
	public function Beeline(mc:MovieClip) {
		super();
		if(mc != undefined){
			_paint_mc = mc;
		}else{
			throw new IllegalArgumentException("在构造一个铅笔绘画工具时缺少画板参数",this,arguments);
		}
		_isdraw = false;
		_record = new Array();
		Thickness = 0;
		RGB = 0x000000;
		Alpha = 100;
	}
	
	/**
	 * 设置绘制样式
	 * @param thickness:Number - 一个整数，以磅为单位指示线条的粗细；有效值为 0 到 255。如果未指定数值，或者该参数为 undefined，则不绘制线条。如果传递的值小于 0，则 Flash Player 使用 0。数值 0 表示极细的粗细；最大粗细为 255。如果传递的值大于 255，则 Flash 解释程序使用 255。
	 * @param rgb:Number - 线条的十六进制颜色值（例如，红色为 0xFF0000，蓝色为 0x0000FF，等等）。默认 0x000000（黑色）。
	 * @param alpha:Number - 一个整数，指示线条颜色的 Alpha 值；有效值为 0 到 100。如果未指示值，则 Flash 使用 100（纯色）。如果该值小于 0，则 Flash 使用 0。如果该值大于 100，则 Flash 使用 100。
	 * @param pixelHinting:Boolean - 在 Flash Player 8 中添加。一个布尔值，它指定是否提示笔触采用完整像素。此值同时影响曲线锚点的位置以及线条笔触大小本身。如果未指示值，则 Flash Player 不使用像素提示。
	 * @param noScale:String - 在 Flash Player 8 中添加。一个字符串，指定如何缩放笔触
	 * 			"normal" 始终缩放粗细（默认值）。 
				"none" 从不缩放粗细。 
				"vertical" 如果仅垂直缩放对象，则不缩放粗细。 
				"horizontal" 如果仅水平缩放对象，则不缩放粗细。
	 * @param capsStyle:String - 在 Flash Player 8 中添加。一个字符串，指定线条终点的端点类型。有效值为："round"、"square" 和 "none"。如果未指示值，则 Flash 使用圆角端点。
	 * @param miterLimit:Number - 在 Flash Player 8 中添加。一个数字，指示切断尖角的限制。有效值的范围是 1 到 255（超出该范围的值将舍入为 1 或 255）。此值只可用于 jointStyle 设置为 "miter" 的情况下。如果未指定值，Flash 将使用 3。
	 */
	public function setStyle(thickness:Number, rgb:Number, alpha:Number, pixelHinting:Boolean, noScale:String, capsStyle:String, jointStyle:String, miterLimit:Number):Void{
		Thickness = int(thickness);
		RGB = int(rgb);
		Alpha = int(alpha);
	}
	
	public function startDraw(x : Number, y : Number, mcName : String) : Array {
		_isdraw = true;
		if(mcName ==undefined) {
			var _mcName = "Beeline_"+Record.getId();
		}else{
			var _mcName = mcName;
		}
		_paint_mc.createEmptyMovieClip(_mcName,_paint_mc.getNextHighestDepth());
		_paint_mc[_mcName].lineStyle(Thickness, RGB, Alpha);
		_paint_mc[_mcName].moveTo(x,y);
		
		_now_Record = new BeelineRecord(_mcName,Thickness, RGB, Alpha);
		_record.push(_now_Record);
		return _now_Record.pushLine(x,y);
	}

	public function draw(x : Number, y : Number) : Array {
		if (_isdraw) {
			var o:Object = _now_Record.getRecord()[0];
			_paint_mc[_now_Record.getName()].clear();
			_paint_mc[_now_Record.getName()].lineStyle(Thickness, RGB, Alpha);
			_paint_mc[_now_Record.getName()].moveTo(o.x,o.y);
			_paint_mc[_now_Record.getName()].lineTo(x, y);
			return null;
		}
	}

	public function endDraw(x : Number, y : Number) : Array {
		_isdraw = false;
		var o:Object = _now_Record.getRecord()[0];
		_paint_mc[_now_Record.getName()].moveTo(o.x,o.y);
		_paint_mc[_now_Record.getName()].lineTo(x, y);
		return _now_Record.endRecord(x,y);
	}
	
	/**
	 * 获取笔画记录
	 * @return Array 一个笔画记录的数组
	 */
	public function getRecord() : Array {
		return _record;
	}
	
	/**
	 * 笔画粗细
	 * @param  value  参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function set Thickness(value:Number) :Void
	{
		_Thickness = value;
	}
	public function get Thickness() :Number
	{
		return _Thickness;
	}
	
	/**
	 * 线条颜色
	 * @param  value  参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function set RGB(value:Number) :Void
	{
		_RGB = value;
	}
	public function get RGB() :Number
	{
		return _RGB;
	}
	
	/**
	 * 透明度
	 * @param  value  参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function set Alpha(value:Number) :Void
	{
		__Alpha = value;
	}
	public function get Alpha() :Number
	{
		return __Alpha;
	}
	
	/**
	 * 是否在绘画
	 * @param  value  参数类型：Boolean 
	 * @return 返回值类型：Boolean 
	 */
	public function get isdraw() :Boolean
	{
		return _isdraw;
	}
}