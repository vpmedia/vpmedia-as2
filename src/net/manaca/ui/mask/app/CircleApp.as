import net.manaca.ui.mask.app.IMaskApp;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.ui.mask.app.AbstractMaskApp;

/**
 * 环绕
 * @author Wersling
 * @version 1.0, 2005-12-7
 */
class net.manaca.ui.mask.app.CircleApp extends AbstractMaskApp implements IMaskApp{
	private var className : String = "net.manaca.ui.mask.app.CircleApp";
	private var _Arr:Array;
	/**
	 * 构造函数
	 * @param 无
	 */
	public function CircleApp(matrix:Array,mc:MovieClip) {
		super(matrix,mc);
		_Arr = new Array();
		var w:Number = matrix[1].length;
		var h:Number = matrix.length;
		var s:Number = w>h?w:h;
		for (var i : Number = 0; i < s; i=i+2) {
			var a:Array = getCircle(matrix,matrix[1].length-i,matrix.length-i);
			_Arr = _Arr.concat(a);
		}
		if(random(2)) _Arr.reverse();
	}
	private function App():Void{
		maskHoder[_Arr[VisibleNum]].play();
		if (VisibleNum>=_Arr.length) {
			clearInterval(_Time);
		} else {
			VisibleNum++;
		}
	}
	/**
	 * 返回一个外围的圆
	 * @param m 距阵
	 * @param w 距阵宽度
	 * @param h 距阵高度
	 */
	private function getCircle(m:Array,w:Number,h:Number):Array{
		var mh:Number = m.length;
		var mw:Number = m[1].length;
		var _a:Array = new Array();
		//→
		var y:Number = (mh-h)/2;
		for (var i : Number = 0; i < w ; i++) {
			_a.push(m[y][i+(mw-w)/2]);
			//var xxx = i+(mw-w)/2;
			//trace(y+":"+xxx);
		}
		//↓
		y = (mw-w)/2+w-1;
		for (var i : Number = 0; i < h-2; i++) {
			_a.push(m[i+(mh-h)/2+1][y]);
			//var t = i+(mh-h)/2+1;
			//trace(t+":"+y);
		}
		//←
		y = (mh-h)/2 + h-1;
		for (var i : Number = w; i >0 ; i--) {
			_a.push(m[y][i+(mw-w)/2-1]);
			//var t = i+(mw-w)/2-1;
			//trace(y+":"+t);
		}
		//↑
		y = (mw-w)/2;
		for (var i : Number = h-2; i >0 ; i--) {
			_a.push(m[i+(mh-h)/2][y]);
			//var t = i+(mh-h)/2;
			//trace(t+":"+y);
		}
		return _a;
	}
}