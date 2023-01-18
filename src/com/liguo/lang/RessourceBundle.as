
/**
 * Un RessourceBundle sert à charger et stocker des ressource multilingue
 */	
import com.liguo.lang.*;

interface com.liguo.lang.RessourceBundle {
		
	/**
	 *Méthode qui sert à récupérer une ressource à partir d'une clé
	 *@param key:String La clé associé à la ressource 
	 *@return La ressource en question 
	 */		
	public function getRessource (key:String);
	
	
	/**
	 *Méthode qui retourne un Array contenant les clés de toutes les ressources présente dans ce bundle
	 *@return un Array de String
	 */
	public function getKeys () : Array;	
		
	
	/**
	 *Démarre le chargement des ressources en fonction de la langue envoyé en paramêtre 
	 *@param lang La langue actuelle (en, fr, es, etc...)
	 */
	public function load (lang:String) : Void;
	
	
	/**
	 *Ajoute un écouteur au bundle
	 */
	public function addBundleListener(listener:BundleListener):Void;
	
}
