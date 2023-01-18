import net.manaca.ui.mask.AbstractMask;
import net.manaca.ui.mask.IMask;
import net.manaca.ui.mask.MaskItem;
import net.manaca.util.MovieClipUtil;

/**
 * 只有单一元件的遮罩
 * @author Wersling
 * @version 1.0, 2006-1-6
 */
class net.manaca.ui.mask.SingleMask extends AbstractMask implements IMask {
	private var className : String = "net.manaca.ui.mask.SingleMask";
	//加载MC名称
	private var item : MaskItem;
	/**
	 * 构造函数
	 * @param mc 存放Mask元件
	 * @param itemName 一个遮罩单元
	 */
	public function SingleMask(mc : MovieClip,item:MaskItem) {
		super(mc);
		this.item = item;
	}
	
	/**
	 * 构建Mask
	 */
	public function crudeMask(width : Number, height : Number, fun : String) : Void {
		maskHoder.attachMovie(item.cellName, item.cellName, maskHoder.getNextHighestDepth());
		maskHoder[item.cellName].play();
	}
	
	/**
	 * 删除Mask
	 */
	public function clear() : Void {
		MovieClipUtil.remove(maskHoder[item.cellName]);
	}

}