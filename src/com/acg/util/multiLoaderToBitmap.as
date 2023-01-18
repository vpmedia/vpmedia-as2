
import flash.display.BitmapData;
import mx.transitions.Tween;
import mx.transitions.easing.*;
import mx.events.EventDispatcher;
import com.acg.util.Delegate;

/**
* 멀티로더 to Bitmap 클래스 ver 0.92
* @author 홍준수
* @date: 2007.08.17
*/

class com.acg.util.multiLoaderToBitmap extends EventDispatcher
{
	public static var LOAD_START:String = "onLoadStart";
	public static var LOAD_PROGRESS:String = "onLoadProgress";
	
	
	/**
	* 로딩이 완료되었을떄 호출합니다.
	*/
	
	public static var LOAD_COMPLETE:String = "onLoadComplete";
	public static var LOAD_ERROR:String = "onLoadError";
	
	
	private static var dummyCounter:Number = 0;
	private var container:MovieClip;
	private var loadUrl:Array;
	private var loader:MovieClipLoader;
	private var loadingCount:Number=0;
	private var totalLoadingCount:Number;
	private var returnArray:Array;
	private var totalByte:Number = 0;
	private var dummyClip:MovieClip;
	
	/**
	* 멀티로더 클래스 생성자<br>
	* 이미지를 읽어와서 비트맵으로 생성해줍니다.
	* 
	* @param loadUrl 로딩할 정보를 받아올 Array
	*/
	
	public function multiLoaderToBitmap( loadUrl:Array )
	{
		dummyCounter ++;
		this.loadUrl = loadUrl;
		this.totalLoadingCount = loadUrl.length;
		
		loader = new MovieClipLoader();
		loader.addListener(this);
		
		dummyClip = _root.createEmptyMovieClip ("dummy"+dummyCounter , _root.getNextHighestDepth() );
		dummyClip._visible = false;
	//	trace("***************************************************************"+dummyCounter);
		
		
		loadStart();
		
		dispatchEvent({type:multiLoaderToBitmap.LOAD_START , mc:container});
		
	}
	
	/**
	* 비트맵을 메모리에서 삭제해줍니다. 
	*/
	
	public function dispose()
	{
		for (var i in this)
		{
			var ddk = this[i];
			if (ddk instanceof BitmapData)
			{
				ddk.dispose();
			}
		}
	}
	
	/**
	* 지정한 무비클립에 비트맵을 어태치시켜줍니다.
	* 
	* @param	mc		타겟 무비클립
	* @param	num		어태치 시켜줄 비트맵 id
	* @param	depth	어태치 시킬 depth
	*/
	
	public function setBitmapToMc ( mc:MovieClip , num:Number , depth:Number )
	{
		if ( !depth )
		{
			depth = mc.getNextHighestDepth();
		}
		
		mc.attachBitmap ( this["bitmap"+num] , depth , "auto" , true );
	}
	
	/**
	* 이미지 로딩을 시작합니다.
	*/
	
	private function loadStart()
	{
		for (var i:Number = 1 ; i<=totalLoadingCount ; i++) {
			
			var ddk:MovieClip = dummyClip.createEmptyMovieClip("___dum" + i , i + 10 );
			ddk._visible = false;
			loader.loadClip(loadUrl[i-1] , ddk);
		}
	}
	
	
	/**
	* 로딩 과정을 처리합니다.
	* @param	mc	타겟 무비클립
	*/
	
	private function onLoadInit(mc:MovieClip)
	{
		
		totalByte += mc.getBytesTotal();
		
		if ( totalLoadingCount > 1 ) 
		{
			mc._visible=false;
		}
		
		loadingCount++;
		var per:Number = (loadingCount/totalLoadingCount) * 100;
		
	//	trace("로딩완료  :  "+ mc );
		
		var currentbitmapNumber:Number = Number( mc._name.substr ( 6 ) ); // 로딩된 이미지의 인덱스를 알아냅니다.
		this["bitmap"+ currentbitmapNumber] = new BitmapData ( mc._width , mc._height , true , 0x000000 );
		this["bitmap"+ currentbitmapNumber].draw (mc);
		mc.removeMovieClip();
		
		dispatchEvent({type:multiLoaderToBitmap.LOAD_PROGRESS , num:loadingCount , percent:per});
		
		/**
		* 로딩이 전체 완료되었을 경우
		*/
		
		if (loadingCount==totalLoadingCount) 
		{
			dummyClip.removeMovieClip();
			trace("전체바이트수=="+totalByte +"--로딩완료" );
			dispatchEvent( { type:multiLoaderToBitmap.LOAD_COMPLETE } )
		}
		
	}
	
}
	