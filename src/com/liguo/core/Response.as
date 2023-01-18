
/**
 *Le rôle d'une Response est de transmettre à une View les données reçu d'une Action
 */ 

import com.liguo.core.*;

interface com.liguo.core.Response extends Context {
	
	/**
	 *Récupère la session du controlleur
	 *@return une référence à la session du controlleur
	 */
	public function getSession () : Session;
	
	
	/**
	 *Retourne le forward
	 */
	public function getForward (): String;
	
	
	/**
	 *Assigne le forward
	 */
	public function setForward (f:String) : Void;
	
	
	/**
	 *retourne le mapping de l'Action qui est à l'origine de cette Response
	 */
	public function getAction () : String;
	
}
