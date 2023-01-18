//import net.manaca.ui.controls.skin.ISkinFactory;
//import net.manaca.ui.controls.skin.mm.MMSkinFactory;
/**
 * 此对象目前停用
 * @author Wersling
 * @version 1.0, 2006-5-15
 */
class net.manaca.ui.controls.skin.SkinFactory {
	private var className : String = "net.manaca.ui.controls.skin.SkinFactory";
	private static var instance : SkinFactory;
	//private var _skinFactory:ISkinFactory;
	/**
	 * @return singleton instance of SkinFactory
	 */
	public static function getInstance() : SkinFactory {
		if (instance == null)
			//instance = new SkinFactory();
		return instance;
	}
	
	private function SkinFactory1() {
		
	}
	
	/**
	 * 获取一个
	 */
//	public function getDefault():ISkinFactory{
//		//if(_skinFactory == undefined) _skinFactory = new MMSkinFactory();
//		return null;
//	}
//	
//	public function setDefault(skinFactory:ISkinFactory):Void{
////		_skinFactory = skinFactory;
//	}
}