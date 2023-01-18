import net.manaca.ui.mask.AbstractMask;
import net.manaca.ui.mask.IMask;

/**
 * 基本的遮罩，他只负责将一个指定的外部元件加载近来作为遮罩
 * @author Wersling
 * @version 1.0, 2006-7-30
 */
dynamic class net.manaca.ui.mask.BasicMask extends AbstractMask implements IMask {
	private var className : String = "net.manaca.ui.mask.BasicMask";
	private var maskCell:MovieClip;
	public function BasicMask(mc : MovieClip) {
		super(mc);
	}
	
	public function crudeMask(width : Number, height : Number, fun : String) : Void {
		clear();
		maskCell = maskHoder.attachMovie(fun, "maskCell", maskHoder.getNextHighestDepth());
		//maskCell.play();
	}

	public function clear() : Void {
		maskCell.removeMovieClip();
	}

}