/**
 * 抽象Mask
 * @author Wersling
 * @version 1.0, 2005-12-7
 */
class net.manaca.ui.mask.AbstractMask {
	private var className : String = "net.manaca.ui.mask.AbstractMask";
	//存放Mask的元件
	private var maskHoder : MovieClip;
	/**
	 * 构造函数
	 * @param 无
	 */
	public function AbstractMask(mc:MovieClip) {
		maskHoder = mc;
	}
	
}