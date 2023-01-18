import net.manaca.lang.BObject;
import net.manaca.ui.UIObject;
import net.manaca.util.Delegate;
import net.manaca.io.file.upload.FileUpLoad;
import net.manaca.io.file.upload.SimpleFileType;
import net.manaca.io.file.upload.FileTypes;
import net.manaca.ui.controls.Loader;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-29
 */
class net.manaca.app.UpLoadPic extends UIObject {
	private var className : String = "net.manaca.app.UpLoadPic";
	private var _but:Button;
	private var _pic_list:MovieClip;

	private var _upLoad : FileUpLoad;
	public function UpLoadPic() {
		super();
		_upLoad = new FileUpLoad();
		_upLoad.addEventListener("onSelect",Delegate.create(this,onSelect));
	}
	/** 加载完成执行 */
	public function onLoad():Void{
		super.onLoad();
		
		_but.onRelease = Delegate.create(this,onButRelease);
	}
	private function onButRelease() : Void {
		var _file_type:FileTypes = new SimpleFileType();
		_file_type.addType("*.jpg; *.jpeg; *.gif; *.png","Images (*.jpg, *.jpeg, *.gif, *.png)");
		_upLoad.add(_file_type);
	}

	private function onSelect(o) : Void {
		var a:Array = o.value;
		_upLoad.upload("dfgdfg");
		//_upLoad.upload("dfgdg");
//		for (var i : Number = 0; i < a.length; i++) {
//			var _loader:Loader = new Loader(_pic_list,"Loader"+i);
//			_loader.setLocation(130*(i%3)+10,Math.floor(i/3)*100+5);
//			_loader.load("D:/My Pictures/素材集/美女/"+a[i].name);
//			//for(var j in a[i]) trace('key: ' + j + ', value: ' + a[i][j]);
//		}
	}

}