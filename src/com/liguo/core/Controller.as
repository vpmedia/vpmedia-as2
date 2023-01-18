

/**
 *Interface r�presentant le controlleur d'une application 
 */ 
 
import com.liguo.core.*;
 
interface com.liguo.core.Controller {
			
	/**
	 *M�thode invoqu� lorsque l'on ex�cute une action 
	 *@param url Le nom de l'action
	 *@param param Les param�tres � envoyer a l'action
	 *
	 *Si les param�tres ne sont que des String, il est possible de
	 *les envoyer dans le nom de l'Action sous un format d'URL standard 
         *(il n'y a aucun support pour l'encodage d'url par contre)
	 *
	 * ex : showSection?id=25&lang=fr
	 *
	 */
	public function execute (url:String, param) : Void;
			
	
	/**
	*M�thode qui est invoqu� par l'Action lorsqu'elle a fini d'ex�cuter sa t�che	
	*@param response Contient le data que l'action doit retourner a la view
	*/
	public function notify (response:Response) : Void;

	
	/**
	 *Recup�re la session de l'usager	
	 *@return La session
	 */
	public function getSession() : Session;
	
	
	/**
	 *Ajoute un action dans le mapping d'action du controller
	 *@param mapping Le mapping de l'Action
	 *@param action L'action
	 */
	public function addAction (mapping:String, action:Action) : Void;
	
	
	/**
	 *Ajoute un forward dans la config du controlleur
	 *Le Forward sert � faire le lien entre l'Action et la View
	 *@param forward:Forward Un objet qui implemente l'interface com.liguo.core.Forward
	 */
	public function addForward (forward:Forward) : Void;
	
	
	/**
	 *Ajoute une view dans le mapping de view du controller
	 *@param mapping Le mapping de la View
	 *@param view Un objet qui implemente l'interface com.liguo.core.View
	 */
	public function addView (mapping:String, view:View) : Void;	
	
	
	/**
	 *Sert � r�cup�rer une r�f�rence de l'instance d'une Action 
	 *@param mapping Le mapping de l'Action
	 *@return une r�f�rence de l'Action
	 */
	public function getAction (mapping:String) : Action;
	
	
	/**
	 *Sert � r�cup�rer une r�f�rence de l'instance d'une View 
	 *@param mapping Le mapping de la View
	 *@return une r�f�rence de la View
	 */
	public function getView (mapping:String) : View;	
}
