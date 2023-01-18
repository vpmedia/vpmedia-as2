import net.manaca.lang.BObject;
import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Rectangle;
import flash.geom.Matrix;

/**
 * 生成指定元素的指定大小的打印数据，目前，这个对象只是正对一个固定的图片生成格式
 * 进行编写，如果要支持其他的程序方式，则需要做相应的调整。
 * @author Wersling
 * @version 1.0, 2006-4-22
 */
class net.manaca.ui.print.PrintScreen extends BObject {
	private var className : String = "net.manaca.ui.print.PrintScreen";
	private var _target:MovieClip;
	private var bmp : BitmapData;
	private var record : Object;
	private var _time_out : Number;
	/**
	 * 构造一个打印对象s
	 */
	public function PrintScreen() {
		super();
	}
	/**
	 * 开始打印
	 * @param target 打印目标
	 * @param x 目标 x
	 * @param y 目标 y
	 * @param w 打印宽度
	 * @param h 打印高度
	 */
	public function print(target:MovieClip,x:Number, y:Number, w:Number, h:Number):Void{
		this.dispatchEvent({type:"onStart",value:target});
		_target = target;
		if(x == undefined) x = 0;
		if(y == undefined) y = 0;
		if(w == undefined) w = _target._width;
		if(h == undefined) h = _target._height;
		bmp = new BitmapData(w,h,false);
		record = new LoadVars();
		record.width  = w;
		record.height = h;
		record.cols   = 0;
		record.rows   = 0;
		bmp.draw(_target,new Matrix(), new ColorTransform(), 1, new Rectangle(x, y, w, h));
		_time_out = setInterval(this,"copysource", 5);
	}

	private function copysource():Void{
		var pixel:Number;
		var str_pixel:String;
		record["px" + record.rows] = new Array();
		for(var a = 0; a < bmp.width; a++){
			pixel     = bmp.getPixel(a, record.rows);
			str_pixel = pixel.toString(16);
			if(pixel == 0xFFFFFF) str_pixel = "";	// 如果为白色则为空
			record["px" + record.rows].push(str_pixel);
		}
		this.dispatchEvent({type:"onProgress",value:int(record.rows/bmp.height)*100});
		record.rows += 1;
		if(record.rows >= bmp.height){
			clearInterval(_time_out);
			this.dispatchEvent({type:"onComplete",record:record});
			bmp.dispose();
		}
	}
	
}