
/**
* ...
* @author 나민욱
* @version 1.0
*/

import mx.events.EventDispatcher;
import mx.utils.Delegate
import com.acg.debug.debug;

import com.acg.darkcom7.Etc.ObjectRemove;

class com.acg.darkcom7.Load.ImgLoad extends EventDispatcher
{
	private var container_mc : MovieClip
	
	private var mcLoader : MovieClipLoader
	private var target_mc : MovieClip

	private var loadRefer : MovieClip
	private var loadFunc : Function
	
	public static var LOAD_COMPLETE:String = "onLoadComplete";
	public static var LOAD_PROGRESS:String = "onLoadProgress";
	public static var LOAD_ERROR:String = "onLoadError";
	
	/**
	* 
	* @param	target   로드할 대상
	*/
	
	public function ImgLoad ()
	{
		//trace("이미지 생성자 실행 ")
		
		this.mcLoader = new MovieClipLoader ();
		
		this.mcLoader.addListener (this);
		
	}
	
	/**
	* 
	* @param	URL		로드 경로 
	*/
	public function loadImage ( target : MovieClip , URL : String) : Void
	{
		this.target_mc = target;
		//debug.send(">>쿤이미지 경로  :"+URL)
		mcLoader.loadClip (URL, target_mc)
	}
	/**
	* 
	* @param	target
	* @param	bytesLoaded
	* @param	bytesTotal
	*/
	private  function onLoadProgress (target : MovieClip, bytesLoaded : Number, bytesTotal : Number) : Void
	{
		 dispatchEvent({type:LOAD_PROGRESS , target :target , bytesLoaded:bytesLoaded ,bytesTotal:bytesTotal })
	};
	
	/**
	* 
	* @param	target
	*/
	private function onLoadInit (target : MovieClip) : Void
	{
	
        dispatchEvent({type:LOAD_COMPLETE , target :target})

	}
	
	/**
	* 
	* @param	target
	*/
	private function onLoadError( target:MovieClip ):Void
	{
		dispatchEvent({type:LOAD_ERROR , target :target})
	}
	
	
	
	/**
	* 모두 지우기 
	*/
	public function destroy () : Void
	{
		mcLoader.removeListener (this);
		container_mc.removeMovieClip ();
		ObjectRemove.allclear (this);	
	}

}