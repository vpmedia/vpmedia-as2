

import com.liguo.core.*;

/**
 *Interface que tout les actions de l'application doivent implémenter
 */
interface com.liguo.core.Action {
	
	/**
	 *Méthode invoqué par le controlleur 
	 *@param request contient tous les paramêtres qui doit être passé à l'action pour exécuter sa logique
	 *  
	 *Le callback vers le controlleur se fait à l'aide de la classe Config
	 *Il faut lui envoyer une Response que l'on récupère de la Request envoyé en paramètre. 
	 * exemple :
	 * var response:Response = request.getResponse("success");
	 * response.setAttribute("data", someData);
	 * Config.notify(response); 
	 */
	public function execute (request:Request) : Void;
}
