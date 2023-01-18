import net.manaca.lang.BObject;
import net.manaca.io.file.EnhancedMovieClipLoader;
import net.manaca.util.Delegate;

/**
 * 这个类主要用于加载需要动态加载背景的使用，可以添加多组需要加载背景的对象和路径来统一加载，从而减少
 * 对事件的重复复杂操作。
 * @author Wersling
 * @version 1.0, 2006-4-10
 */
class net.manaca.io.file.PicLoadList extends BObject {
	private var className : String = "net.manaca.io.file.PicLoadList";
	private var _loads:Array;
	private var _now_load_id:Number;
	private var _emc:EnhancedMovieClipLoader;
	/**
	 * 构造一个 PicLoadList
	 */
	public function PicLoadList() {
		super();
		_loads = new Array();
	}
	
	/**
	 * 添加一个下载项目
	 * @param target 需要加载图片的对象
	 * @param pic_path 图片路径
	 */
	public function addLoad(target:Object,pic_path:String):Boolean{
		if(target){
			 _loads.push({mc:target,path:pic_path});
			 return true;
		}
		return false;
	}
	
	/**
	 * 加载多个下载项目
	 * @param loads 多个对象的数组，格式为arr[0] = {mc:target,path:pic_path}
	 */
	public function addLoads(loads:Array):Void{
		_loads.concat(loads);
	}
	
	/**
	 * 开始执行加载
	 */
	public function start():Boolean{
		if(_loads.length < 1) return false;
		_now_load_id = 0;
		_emc = new EnhancedMovieClipLoader();
		_emc.addEventListener("onLoadComplete",Delegate.create(this,onLoadComplete));
		load(_now_load_id);
	}
	
	/**
	 * 加载指定对象图片
	 */
	private function load(id):Void{
		_emc.init(_loads[id].mc);
		_emc.load(_loads[id].path);
	}
	
	/**
	 * 加载完成
	 */
	private function onLoadComplete():Void{
		if(_loads.length-1 > _now_load_id){
			load(_now_load_id++);
		}else{
			this.dispatchEvent({type:"onComplete"});
		}
	}
}