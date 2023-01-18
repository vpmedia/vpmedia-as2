
/**
 *Classe qui s'occupe de charger des librairies de classes en mémoire 
 */
 
import mx.utils.*;
import mx.events.*;
 
class com.liguo.core.ClassLoader {
	
	public static var className:String = "ClassLoader";
	public static var classPackage:String = "com.liguo.core";
	public static var version:String = "1.0.0";
	public static var author:String = "liguorien";
	public static var link:String = "http://www.liguorien.com";
	
	 	
	private var _loader:MovieClipLoader;	
	private var _libs:Array;
	private var _container:MovieClip;				
	
	private var dispatchEvent:Function;
 	public var addEventListener:Function;
 	public var removeEventListener:Function;
 	
 	private static var _initEvent = EventDispatcher.initialize(ClassLoader.prototype);
	
	
	/**
	 *@constructor
	 */
	public function ClassLoader (mc:MovieClip) {
		_container = mc;
		_libs = new Array();
		_loader = new MovieClipLoader();
		_loader["onLoadInit"] = Delegate.create(this,_onLoad);		
	}
	
		
	/**
	 *Ajoute une librairie à charger
	 *@param url L'url du SWF représentant la librairie 
	 */ 
	public function addLibrary (url:String) : Void {
		_libs.push(url);		
	}	
	
	
	/**
	 *Débute la séquence de chargement	
	 */ 
	public function startLoading () : Void {		
		_loadNextLib();
	}
	
	
	private function _onLoad (lib:MovieClip) : Void {		
		dispatchEvent({type:"onLibraryLoaded", target:this, library:lib});			
		_loadNextLib();
	}	
	
	private function _loadNextLib () : Void {			
		if(_libs.length > 0){						
			var depth:Number = _container.getNextHighestDepth();			
			_loader.loadClip(String(_libs.shift()), _container.createEmptyMovieClip("lib_"+depth,depth));			
		}else{					
			dispatchEvent({type:"onLoadComplete", target:this});
		}					
	}	
}
