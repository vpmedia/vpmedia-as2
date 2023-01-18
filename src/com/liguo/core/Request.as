
/**
 *Le rôle d'une Request est de faire le lien entre le controlleur et une Action.
 *Elle contient les attributs nécessaire pour traiter les données avec le serveur.
 */ 

import com.liguo.core.*;

interface com.liguo.core.Request extends Context {
		
	/**
	 *Rècupère la session du controlleur
	 *@return Retourne une référence à la session du controlleur
	 */
	public function getSession () : Session;
	
	
	/**
	 *Retourne le mapping de l'action que le controlleur doit exécuter	 
	 *@return le mapping de l'action
	 */	
	public function getAction () : String;
	
	
	/**
	 *Retourne la réponse qui doit par la suite être notifié au controlleur	 
	 *@param forward Le mapping du Forward qui sera utilisé pour renvoyer le data à la bonne View
	 *@return la Response
	 */
	public function getResponse (forward:String) : Response;
}
