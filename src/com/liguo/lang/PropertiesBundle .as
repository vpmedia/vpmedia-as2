

/**
 * Un PropertiesBundle sert � charger et stocker des ressource multilingue � partir d'un fichier de propri�t�
 * Le format du fichier est le suivant :
 *
 * #commentaire
 * cle=valeur
 * cle2=valeur2 
 */	
 
import mx.utils.*;
import com.liguo.lang.*;

class com.liguo.lang.PropertiesBundle implements RessourceBundle {


	public static var className:String = "PropertiesBundle ";
	public static var classPackage:String = "com.liguo.lang";
	public static var version:String = "0.1.0";
	public static var author:String = "Nicolas D�sy (liguorien)";
	public static var link:String = "http://www.liguorien.com";


	private var _loader:LoadVars;
	private var _properties:Object;
	private var _name:String;
	private var _broadcaster:Object;
	
	
	/**
	 *@constructor
	 *
	 *@param name:String le nom du bundle
	 *Par exemple, si le nom du est "ressources/labels"
	 *il faudra cr�er les fichiers suivant sur le serveur :
	 *
	 * ressources/labels_fr.properties
	 * ressources/labels_en.properties
	 * ressources/labels_es.properties
	 * etc...
	 */
	public function PropertiesBundle (name:String){
		_name = name;
		AsBroadcaster.initialize(_broadcaster = {});
	}
	
	
	/**
	 *M�thode qui sert � r�cup�rer une ressource � partir d'une cl�
	 *@param key:String La cl� associ� � la ressource 
	 *@return La ressource en question 
	 */		
	public function getRessource (key:String){
		return _properties[key];
	}
	
	

	/**
	 *M�thode qui retourne un Array contenant les cl�s de toutes les ressources pr�sente dans ce bundle
	 *@return un Array de String
	 */
	public function getKeys () : Array {
		var keys:Array = [];
		for(var i in _properties){
			keys.push(i);
		}
		return keys;
	}
		
	
	/**
	 *D�marre le chargement des ressources en fonction de la langue envoy� en param�tre 
	 *@param lang La langue actuelle (en, fr, es, etc...)
	 */
	public function load (lang:String) : Void{
		_loader = new LoadVars();		
		_loader.onData = Delegate.create(this, _onLoad);
		_loader.load(_name + "_" + lang + ".properties");
	}
	
		
	/**
	 *Ajoute un �couteur au bundle
	 */
	public function addBundleListener(listener:BundleListener):Void{
		_broadcaster.addListener(listener);
	}
		
		
	/**
	 *callback de l'�v�nement 'onData' du LoadVars
	 */
	private function _onLoad (data:String) : Void {
		_properties = {};
		
		var entries:Array = data.split("\r\n");
		var i:Number = entries.length;
		
		while(--i > -1){       
		
			var entry:String = entries[i];
			
			if (entry.charAt(0) != "#"){        		
				
				var index:Number = entry.indexOf("=");
				var key:String = entry.slice(0, index);
				var value:String = entry.slice(index+1, entry.length);
				
				if (key.length > 0 && value.length > 0){
					_properties[key] = value;
				}
			}
		}      
		
		_broadcaster.broadcastMessage("onLoadComplete",this);		
	}
}

