import net.manaca.ui.mask.app.IMaskApp;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.ui.mask.app.AbstractMaskApp;

/**
 * 百页窗
 * @author Wersling
 * @version 1.0, 2005-12-7
 */
class net.manaca.ui.mask.app.ShutterApp extends AbstractMaskApp implements IMaskApp{
	private var className : String = "net.manaca.ui.mask.app.ShutterApp";
	/**
	 * 构造函数
	 * @param 无
	 */
	public function ShutterApp(matrix:Array,mc:MovieClip) {
		super(matrix,mc);
		VisibleNum = 0;
	}
	private function App():Void{
		for (var i = 0; i<matrix[VisibleNum].length; i++) {
			maskHoder[matrix[VisibleNum][i]].play();
		}
		if (VisibleNum >= matrix.length) {
			clearInterval(_Time);
		} else {
			VisibleNum++;
		}
	}
}