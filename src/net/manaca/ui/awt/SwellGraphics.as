import net.manaca.ui.awt.Graphics;

/**
 * 增强的绘制对象，主要是基于Flash8的beginGradientFill方法和lineGradientStyle来实现的
 * @author Wersling
 * @version 1.0, 2006-4-7
 */
class net.manaca.ui.awt.SwellGraphics extends Graphics {
	private var className : String = "net.manaca.ui.awt.SwellGraphics";
	
	/**
	 * 构造一个增强的绘制对象
	 */
	public function SwellGraphics(target_mc:MovieClip) {
		super(target_mc);
	}
	
}