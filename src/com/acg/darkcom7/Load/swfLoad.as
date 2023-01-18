
/**
* @author 나민욱
* @version 1.0
*/
import mx.events.EventDispatcher;
import mx.utils.Delegate

class com.acg.darkcom7.Load.swfLoad extends EventDispatcher
{
	
	private var container_mc : MovieClip
	
	private var mcLoader : MovieClipLoader
	private var target_mc : MovieClip

	private var loadRefer : MovieClip
	private var loadFunc : Function
	
	public static var LOAD_COMPLETE:String = "onLoadComplete";

	public static var LOAD_ERROR:String = "onLoadError";
	public static var LOAD_PROGRESS : String = "onLoadProgress"

	
	/**
	* 
	* @param	target   로드할 대상
	*/
	
	public function swfLoad ( target : MovieClip)
	{
		
		this.target_mc = target
		this.mcLoader = new MovieClipLoader ();
		this.mcLoader.addListener (this);
		
		EventDispatcher.initialize(this)

	}

	
	private function onLoadStart(target:MovieClip)
	{
		 target_mc.unloadClip(target);
	}
	
	/**
	* 
	* @param	target
	* @param	bytesLoaded
	* @param	bytesTotal
	*/
	private  function onLoadProgress (target : MovieClip, bytesLoaded : Number, bytesTotal : Number) : Void
	{

		
		var per : Number = int((bytesLoaded/bytesTotal)*100)
		dispatchEvent({type:LOAD_PROGRESS , target :target , load_per:per})
	};
	/**
	* 
	* @param	refer		this레퍼런스
	* @param	fun		호출함수 
	*/
	
	private function addLoad (refer : MovieClip, fun : Function)
	{
		this.loadRefer = refer
		this.loadFunc = fun
	}
	/**
	* 
	* @param	target
	*/
	private function onLoadInit (target : MovieClip) : Void
	{
        dispatchEvent({type:LOAD_COMPLETE , target :target})

	}
	
	private function onLoadError()
	{
		trace("로드에러")
		 dispatchEvent({type:LOAD_ERROR})
	}
	
	/**
	* 
	* @param	obj		오브젝트 모두 지우기
	*/
	private function allclear (obj)
	{
		for (var p in obj)
		{
			//trace(p +  "::지울놈들::" + obj[p])
			delete obj [p];
			obj [p].removeMovieClip ();
			if (obj [p])
			{
				this.allclear (obj [p]);
			}
		}
	}
	/**
	* 
	* @param	URL		로드 경로 
	*/
	public function loadImage (URL : String) : Void
	{
		mcLoader.loadClip (URL, target_mc)
	}
	/**
	* 모두 지우기 
	*/
	public function destroy () : Void
	{
		
		trace("지우기")
		mcLoader.removeListener (this);
		container_mc.removeMovieClip ();
		this.allclear (this);	
	}
	/**
	* 플레이 함수 
	*/
	public function playFunc ()
	{
		target_mc.play ()
	}
}
