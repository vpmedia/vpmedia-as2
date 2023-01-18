import net.manaca.ui.mask.app.IMaskApp;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.ui.mask.app.AbstractMaskApp;

/**
 * 横向间隔
 * @author Wersling
 * @version 1.0, 2005-12-7
 */
class net.manaca.ui.mask.app.PortraitAlternationApp extends AbstractMaskApp implements IMaskApp{
	private var className : String = "net.manaca.ui.mask.app.PortraitAlternationApp";
	private var PortraitBop:Boolean;
	/**
	 * 构造函数
	 * @param 无
	 */
	public function PortraitAlternationApp(matrix:Array,mc:MovieClip) {
		super(matrix,mc);
	}
	private function App():Void{
		for (var i = 0; i<matrix[VisibleNum].length; i++) {
			if(PortraitBop && (i%2) == 0){
				maskHoder[matrix[VisibleNum][i]].play();
			}else if(!PortraitBop && (i%2) !== 0){
				maskHoder[matrix[VisibleNum][i]].play();
			}
			
		}
		if (VisibleNum >= matrix.length) {
			if(!PortraitBop){
				PortraitBop = true;
				VisibleNum = 0;
			}else{
				clearInterval(_Time);
			}
		} else {
			VisibleNum++;
		}
	}
}