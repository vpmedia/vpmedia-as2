
import mx.transitions.Tween;
import mx.transitions.easing.*;
import mx.events.EventDispatcher;
import com.acg.util.Delegate;

/**
* 멀티로더 클래스 ver 0.92
* @author 홍준수
* @date: 2007.05.20
*/

class com.acg.util.multiLoader extends EventDispatcher
{
	public static var LOAD_START:String = "onLoadStart";
	public static var LOAD_PROGRESS:String = "onLoadProgress";
	public static var LOAD_COMPLETE:String = "onLoadComplete";
	public static var LOAD_ERROR:String = "onLoadError";
	
	private var container:MovieClip;
	private var loadUrl:Array;
	private var loader:MovieClipLoader;
	private var loadingCount:Number=0;
	private var totalLoadingCount:Number;
	private var returnArray:Array;
	private var totalByte:Number = 0;
	
	/**
	* 멀티로더 클래스
	* 
	* @param container 로딩한 무비클립을 담아둘 컨테이너
	* @param loadUrl 로딩할 정보를 받아올 Array
	* @return returnArray LOAD_COMPLETE 이벤트시 무비클립 정보를 어레이에 담아서 리턴합니다.
	*/
	
	public function multiLoader(container:MovieClip , loadUrl:Array)
	{
		this.container = container;
		this.loadUrl = loadUrl;
		this.totalLoadingCount = loadUrl.length;
		this.returnArray = new Array();
		
		loader = new MovieClipLoader();
		loader.addListener(this);
		
		loadStart();
		
		dispatchEvent({type:multiLoader.LOAD_START , mc:container});
	}
	
	private function loadStart()
	{
		for (var i=1;i<=totalLoadingCount;i++) {
			var ddk:MovieClip = container.createEmptyMovieClip("image"+i,i+10);
			returnArray.push(ddk);
			loader.loadClip(loadUrl[i-1] , ddk);
		}
	}
	
	
	private function onLoadInit(mc:MovieClip)
	{
		totalByte+= mc.getBytesTotal();
		if (totalLoadingCount>1) {
			mc._visible=false;
		}
		loadingCount++;
		var per = (loadingCount/totalLoadingCount) * 100;
		
		dispatchEvent({type:multiLoader.LOAD_PROGRESS , num:loadingCount , percent:per});
		
		if (loadingCount==totalLoadingCount) {
			trace("전체바이트수=="+totalByte);
			dispatchEvent({type:multiLoader.LOAD_COMPLETE , returnArray:returnArray , mc:container});
		}
	}
}
	