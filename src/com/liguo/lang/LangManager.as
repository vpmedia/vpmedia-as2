

/**
 *Cette classe sert � g�rer les labels multilingue et � stock� la langue du client dans un SharedObject
 */
 
import mx.events.*;
import com.liguo.lang.*;

class com.liguo.lang.LangManager implements BundleListener {
		

	public static var className:String = "LangManager";
	public static var classPackage:String = "com.liguo.lang";
	public static var version:String = "0.1.0";
	public static var author:String = "Nicolas D�sy (liguorien)";
	public static var link:String = "http://www.liguorien.com";



	/**
	 * nom du SharedObject utilis� pour stocker la langue
	 */	
	private static var SO_NAME:String = "config";	
	
	/**
	 *langue courante
	 */
	private var _lang:String; 
	
	/**
	 *contient les RessourceBundle
	 */
	private var _bundles:Array; 
	
	/**
	 *Map qui associe l'index d'un bundle avec un nom
	 */
	private var _bundleMapping:Object;
	
	/**
	 *d�termine s'il y a un loading en cours 
	 */
	private var _isLoading:Boolean;
	
	/**
	 *d�termine le nombre de bundle charg�
	 */
	private var _nbBundleLoaded:Number;
	
	/**
	 *utilis� pour lancer les �v�nement
	 */
	private var _dispatcher:EventDispatcher;
	
	
	/**
	 *@constructor
	 */
	private function LangManager() {
						
		var so:SharedObject = SharedObject.getLocal(SO_NAME);
		
		//s'il n'y a pas encore de lang dans la config, on prend celui de l'OS
		if(so.data.lang == undefined) {
			so.data.lang = System.capabilities.language;
			so.flush();
			so.close();
		}		
				
		_lang = so.data.lang;		
		_bundles = [];
		_bundleMapping = {};
		_isLoading = false;
		_dispatcher = new EventDispatcher();		
	}
		
	
	/**
	 *Ajoute un RessourceBundle 
	 *@param bundle Un object qui impl�mente l'interface com.liguo.lang.RessourceBundle
	 *@param name Le nom du bundle (optionnel)
	 */
	public function addBundle (bundle:RessourceBundle, name:String) : Void{
		if(!_isLoading){
			if(name){
				_bundleMapping[name] = _bundles.length;
			}
			bundle.addBundleListener(this);
			_bundles.push(bundle);			
		}else{
			throw new Error("[ERROR] LangManager.addBundle("+bundle+") : You can't add a RessourceBundle while loading...");
		}
	}
	
	
	/**
	 *R�cup�re un RessourceBundle � partir de son nom
	 *@param name:String Le nom du bundle
	 */
	public function getBundle (name:String) : RessourceBundle {
		return _bundles[_bundleMapping[name]];
	}
	
	
	/**
	 *Cette m�thode sert � modifier la langue courante
	 *@pram lang:String L'identifiant de la langue (en, fr, es, etc...)
	 */
	public function setLang (lang:String) : Void {
		var so:SharedObject = SharedObject.getLocal(SO_NAME);				
		so.data.lang = _lang = lang;
		so.flush();
		so.close();				
	}
	
	
	/**
	 *@return L'identifiant de la langue courante (en, fr, es, etc...)
	 */
	public function getCurrentLang () : String	{
		return _lang;
	}
	
	
	/**
	 *@return L'identifiant de la langue de l'OS (en, fr, es, etc...)
	 */
	public function getSystemLang () : String {
		return System.capabilities.language;
	}
	
	
	/**
	 * d�marre la s�quence de chargement des ressources
	 */
	public function startLoading () : Void {			
		if(!_isLoading){						
			_isLoading = true;
			_nbBundleLoaded = 0;			
			_handleNextBundle();			
		}else{
			throw new Error("[ERROR] LangManager.startLoading() : The LangManager is already loading ressource...");
		}		
	}
		
	
	/**
	 *Invoqu� lorsque le chargement d'un bundle est termin�
	 *@param bundle Une r�f�rence au bundle en question
	 */
	public function onLoadComplete (bundle:RessourceBundle) : Void {			
		_dispatcher.dispatchEvent({type:"onBundleLoaded",target:this, bundle:bundle});			
		_nbBundleLoaded++;		
		_handleNextBundle();
	}
		
		
	/**
	 *D�termine s'il y a encore des bundle � charger, si non, on lance l'�v�nement onLoadCompleted
	 */
	private function _handleNextBundle () : Void {		
		if(_nbBundleLoaded == _bundles.length){
			_dispatcher.dispatchEvent({type:"onLoadComplete",target:this});
			_isLoading = false;
		}else{
			_bundles[_nbBundleLoaded].load(_lang);
		}
	}
			
	
	/**
	 * Cette m�thode sert � r�cup�rer 
	 */
	public function getLabel (key:String) : String	{
		var i:Number = _bundles.length;
		while(--i > -1){
			var label:String = _bundles[i].getRessource(key);
			if(label != null){
				return label;
			}
		}		
		return null;		
	}	

		
	/**
	 *ajoute un �couteur
	 */
	public function addEventListener (event:String, listener) : Void {
		_dispatcher.addEventListener(event,listener);
	}
	
	
	/**
	 *supprime un �couteur
	 */
	public function removeEventListener (event:String, listener) : Void {
		_dispatcher.removeEventListener(event,listener);
	}	
	
	
	/**
	 * Singleton
	 */
	private static var _o:LangManager;
	public static function getInstance () : LangManager {
		return _o ? _o : (_o = new LangManager());
	}
}

