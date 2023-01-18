import net.manaca.ui.mask.app.IMaskApp;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.ui.mask.app.AbstractMaskApp;

/**
 * 斜扫
 * @author Wersling
 * @version 1.0, 2005-12-7
 */
class net.manaca.ui.mask.app.ObliqueApp extends AbstractMaskApp implements IMaskApp{
	private var className : String = "net.manaca.ui.mask.app.ObliqueApp";
	/**
	 * 构造函数
	 * @param 无
	 */
	public function ObliqueApp(matrix:Array,mc:MovieClip) {
		super(matrix,mc);
		VisibleNum = 1;
	}
	private function App():Void{
		for (var i = 0; i<VisibleNum; i++) {
			maskHoder[matrix[i][VisibleNum-i-1]].play();
		}
		if (VisibleNum>=matrix.length + matrix[1].length-1) {
			clearInterval(_Time);
		} else {
			VisibleNum++;
		}
	}
}