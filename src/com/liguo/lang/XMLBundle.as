

/**
 * Un XMLBundle sert à charger et stocker des ressource multilingues à partir d'un fichier XML
 * Le format du fichier est le suivant :
 *
 * <labels>
 *   <cle>valeur</cle>
 *   <cle2>valeur2</cle2>
 *   <cle3><![CDATA[valeur3]]></cle3>
 * </labels>
 */	

import mx.utils.*;
import com.liguo.lang.*;
	
class com.liguo.lang.XMLBundle implements RessourceBundle {
		

	public static var className:String = "XMLBundle";
	public static var classPackage:String = "com.liguo.lang";
	public static var version:String = "0.1.0";
	public static var author:String = "Nicolas Désy (liguorien)";
	public static var link:String = "http://www.liguorien.com";


	private var _doc:XML;
	private var _labels:Object;
	private var _name:String;
	private var _broadcaster:Object;
	
	/**
	 *@constructor
	 *
	 *@param name:String le nom du bundle
	 *Par exemple, si le nom du est "ressources/labels"
	 *il faudra créer les fichiers suivant sur le serveur :
	 *
	 * ressources/labels_fr.xml
	 * ressources/labels_en.xml
	 * ressources/labels_es.xml
	 * etc...
	 */
	public function XMLBundle (name:String){
		_name = name;
		AsBroadcaster.initialize(_broadcaster = {});
	}
	
	/**
	 *Méthode qui sert à récupérer une ressource à partir d'une clé
	 *@param key:String La clé associé à la ressource 
	 *@return La ressource en question 
	 */		
	public function getRessource (key:String){
		return _labels[key];
	}
	
	
	/**
	 *Méthode qui retourne un Array contenant les clés de toutes les ressources présente dans ce bundle
	 *@return un Array de String
	 */
	public function getKeys () : Array {
		var keys:Array = [];
		for(var i in _labels){
			keys.push(i);
		}
		return keys;
	}
		
	
	/**
	 *Démarre le chargement des ressources en fonction de la langue envoyé en paramêtre 
	 *@param lang La langue actuelle (en, fr, es, etc...)
	 */
	public function load (lang:String) : Void{
		_doc = new XML();
		_doc.ignoreWhite = true;
		_doc.onLoad = Delegate.create(this, _onLoad);
		_doc.load(_name + "_" + lang + ".xml");
	}
	
		
	/**
	 *Ajoute un écouteur au bundle
	 */
	public function addBundleListener(listener:BundleListener):Void{
		_broadcaster.addListener(listener);
	}
		
		
	/**
	 *callback de l'événement 'onLoad' du document XML
	 */
	private function _onLoad () : Void {
		_labels = {};
			
		var nodes:Array = _doc.firstChild.childNodes;
		var i:Number = nodes.length;
		
		while(--i > -1)	{
			var node:XMLNode = nodes[i];
			_labels[node.nodeName] = node.firstChild.nodeValue;
		}
		
		_broadcaster.broadcastMessage("onLoadComplete",this);		
	}
}

