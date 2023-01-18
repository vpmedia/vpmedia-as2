import net.manaca.ui.mask.app.IMaskApp;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.ui.mask.app.AbstractMaskApp;

/**
 * 纵向间隔
 * @author Wersling
 * @version 1.0, 2005-12-7
 */
class net.manaca.ui.mask.app.TransverseAlternationApp extends AbstractMaskApp implements IMaskApp{
	private var className : String = "net.manaca.ui.mask.app.TransverseAlternationApp";
	private var PortraitBop:Boolean;

	private var Type : Boolean;
	/**
	 * 构造函数
	 * @param type 间隔出现方式：true，顺序出现，false，S型出现。默认true
	 */
	public function TransverseAlternationApp(matrix:Array,mc:MovieClip,type:Boolean) {
		super(matrix,mc);
		if (type == undefined ) this.Type = false;
		this.Type = type;
		VisibleNum = Type ? matrix[0].length:0;
	}
	private function App():Void{
		for (var i = 0; i<matrix.length; i++) {
			if(PortraitBop && (i%2) == 0){
				maskHoder[matrix[i][VisibleNum]].play();
			}else if(!PortraitBop && (i%2) !== 0){
				maskHoder[matrix[i][VisibleNum]].play();
			}
		}
		if ((Type && VisibleNum <= 0) || (!Type && VisibleNum >= matrix.length)) {
			if(!PortraitBop){
				PortraitBop = true;
				VisibleNum = Type ? matrix[0].length:0;
			}else{
				clearInterval(_Time);
			}
		} else {
			VisibleNum += Type ? -1:1;
		}
	}
}