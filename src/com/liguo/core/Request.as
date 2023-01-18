
/**
 *Le r�le d'une Request est de faire le lien entre le controlleur et une Action.
 *Elle contient les attributs n�cessaire pour traiter les donn�es avec le serveur.
 */ 

import com.liguo.core.*;

interface com.liguo.core.Request extends Context {
		
	/**
	 *R�cup�re la session du controlleur
	 *@return Retourne une r�f�rence � la session du controlleur
	 */
	public function getSession () : Session;
	
	
	/**
	 *Retourne le mapping de l'action que le controlleur doit ex�cuter	 
	 *@return le mapping de l'action
	 */	
	public function getAction () : String;
	
	
	/**
	 *Retourne la r�ponse qui doit par la suite �tre notifi� au controlleur	 
	 *@param forward Le mapping du Forward qui sera utilis� pour renvoyer le data � la bonne View
	 *@return la Response
	 */
	public function getResponse (forward:String) : Response;
}
