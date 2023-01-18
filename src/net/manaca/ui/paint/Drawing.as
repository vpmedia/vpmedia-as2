/**
 * 定义一个绘制对象所必须的方式
 * @author Wersling
 * @version 1.0, 2006-4-19
 */
interface net.manaca.ui.paint.Drawing {
	/**
	 * 开始绘制
	 */
	public function startDraw(x:Number,y:Number,mcName:String):Array;
	/**
	 * 绘制
	 */
	public function draw(x:Number,y:Number):Array;
	/**
	 * 结束绘制
	 */
	public function endDraw(x : Number, y : Number):Array;
	/**
	 * 返回记录
	 */
	public function getRecord():Array;
}