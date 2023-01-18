

import com.liguo.core.*;

/**
 *Interface que tout les actions de l'application doivent impl�menter
 */
interface com.liguo.core.Action {
	
	/**
	 *M�thode invoqu� par le controlleur 
	 *@param request contient tous les param�tres qui doit �tre pass� � l'action pour ex�cuter sa logique
	 *  
	 *Le callback vers le controlleur se fait � l'aide de la classe Config
	 *Il faut lui envoyer une Response que l'on r�cup�re de la Request envoy� en param�tre. 
	 * exemple :
	 * var response:Response = request.getResponse("success");
	 * response.setAttribute("data", someData);
	 * Config.notify(response); 
	 */
	public function execute (request:Request) : Void;
}
