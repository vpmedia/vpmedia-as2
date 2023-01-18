
/**
 * Un RessourceBundle sert � charger et stocker des ressource multilingue
 */	
import com.liguo.lang.*;

interface com.liguo.lang.RessourceBundle {
		
	/**
	 *M�thode qui sert � r�cup�rer une ressource � partir d'une cl�
	 *@param key:String La cl� associ� � la ressource 
	 *@return La ressource en question 
	 */		
	public function getRessource (key:String);
	
	
	/**
	 *M�thode qui retourne un Array contenant les cl�s de toutes les ressources pr�sente dans ce bundle
	 *@return un Array de String
	 */
	public function getKeys () : Array;	
		
	
	/**
	 *D�marre le chargement des ressources en fonction de la langue envoy� en param�tre 
	 *@param lang La langue actuelle (en, fr, es, etc...)
	 */
	public function load (lang:String) : Void;
	
	
	/**
	 *Ajoute un �couteur au bundle
	 */
	public function addBundleListener(listener:BundleListener):Void;
	
}
