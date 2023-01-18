import eu.orangeflash.lib.simplecomponents.imageclasses.IPreloader;
class eu.orangeflash.lib.simplecomponents.imageclasses.Preloader
extends MovieClip
implements IPreloader {
	public static var PERCENT:String = "percent";
	public static var TOTAL_LOADED:String = "total_loaded";
	
	private var progress:TextField;
	private var type:String;
	
	public functin Preloader(type:String):Void {
		setType(type)
		//
		createTextField("progress",1,0,0,0,0);
		progress.autoSize=true;
	}
	
	public function setProgress(total:String,loaded:String):Void {
		if(type == PERCENT) {
			var pc:Number = (total/loaded)*100;
			progress.text = pc+"%";
		}else{
			progress.text = loaded+"/"+total;
		}
	}
	
	private function setType(type:String):Void {
		if(type == PERCENT || type == TOTAL_LOADED) {
			this.type = type;
		}else{
			this.type = PERCENT;
		}
	}
}