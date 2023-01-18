import net.manaca.ui.UIObject;

/**
 * 可以缩放的筐
 * @author Wersling
 * @version 1.0, 2005-12-3
 */
class net.manaca.controls.ZoomCirde extends UIObject {
	private var className : String = "net.manaca.controls.ZoomCirde";
	private var t:MovieClip;
	private var b:MovieClip;
	private var l:MovieClip;
	private var r:MovieClip;
	/**
	 * 构造函数
	 * @param 无
	 */
	public function ZoomCirde() {
		super();
	}
	/**
	 * 设置大小
	 * @param w 宽度
	 * @param h 高度
	 */
	public function setSize(w:Number,h:Number):Void{
		t._width	= w;
		b._width	= w;
		l._height	= r._height	= h;
		b._y =  h-1;
		r._x = 	w-1;
	}
	/**
	 * 设置颜色
	 * @param tgb 要设置的颜色值
	 * TODO 存在bug，在第二次设置时无效
	 */
	public function setRGB(rgb:Number):Void{
		var a:Array = [t,b,l,r];
		for(var i in a) {
			var c:Color = new Color(a[i]);
			c.setRGB(rgb);
			c = null;
			delete c;
		}
	}
}