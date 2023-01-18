

/**
 *Implémentation de base de l'interface com.liguo.core.Controller 
 */ 
 
import com.liguo.core.*;
 
class com.liguo.core.SimpleController implements Controller {
	
	public static var className:String = "SimpleController";
	public static var classPackage:String = "com.liguo.core";
	public static var version:String = "1.0.0";
	public static var author:String = "liguorien";
	public static var link:String = "http://www.liguorien.com";
	
	
	private var _session:Session;
	private var _actions:Object;
	private var _views:Object;
	private var _forwards:Object;

	/**
	 *@constructor
	 */
	public function SimpleController () {			
		_actions = new Object();
		_views = new Object();		
		_forwards = new Object();		
		_session = new SimpleSession();
		_session.restore();	
	}

			
	/**
	 *Méthode invoqué lorsque l'on exécute une action 
	 *@param url Le nom de l'action
	 *@param param Les paramêtres à envoyer a l'action
	 *
	 *Si les paramêtres ne sont que des String, il est possible de
	 *les envoyer dans le nom de l'Action sous un format d'URL standard 
         *(il n'y a aucun support pour l'encodage d'url par contre)
	 *
	 * ex : showSection?id=25&lang=fr
	 *
	 */
	public function execute (url:String, params) : Void {		
		var request:Request = new SimpleRequest(url, params);					
		getAction(request.getAction()).execute(request);
	}	
		
	
       /**
	*Méthode qui est invoqué par l'Action lorsqu'elle a fini d'exécuter sa tâche	
	*@param response Contient le data que l'action doit retourner a la view
	*/
	public function notify (res:Response) : Void {			
		var fo:Forward = _forwards[res.getAction()][res.getForward()];
		if(!fo){
			throw new ForwardNotFoundException(res.getAction(), res.getForward());
		}else{
			fo.doFoward(res);	
		}				
	}


	/**
	 *Recupere la session de l'usager	
	 *@return La session
	 */
	public function getSession () : Session {			
		 return _session;	
	}
	
	
	/**
	 *Ajoute un action dans le mapping d'action du controller
	 *@param mapping Le mapping de l'Action
	 *@param action L'action
	 */
	public function addAction (mapping:String, action:Action) : Void {			
		_actions[mapping] = action;		
	}
	
		
	/**
	 *Ajoute un forward dans la config du controlleur
	 *Le Forward sert à faire le lien entre l'Action et la View
	 *@param forward:Forward Un objet qui implemente l'interface com.liguo.core.Forward
	 */
	public function addForward (forward:Forward) : Void {
		var action:String = forward.getActionMapping();
		if(!_forwards[action])_forwards[action] = {};
		_forwards[action][forward.getName()] = forward;
	}	
	
	
	/**
	 *Ajoute une view dans le mapping de view du controller
	 *@param mapping Le mapping de la View
	 *@param view Un objet qui implemente l'interface com.liguo.core.View
	 */
	public function addView (mapping:String, view:View) : Void {		
		_views[mapping] = view;		
	}	
	
	
	/**
	 *Sert à récupèrer une référence de l'instance d'une Action 
	 *@param mapping Le mapping de l'Action
	 *@return une référence de l'Action
	 */
	public function getAction (mapping:String) : Action {
		var action:Action = _actions[mapping];
		if(!action){
			throw new ActionNotFoundException(mapping);			
		}
		return action;	
	}
	
	
	/**
	 *Sert à récupèrer une référence de l'instance d'une View 
	 *@param mapping Le mapping de la View
	 *@return une référence de la View
	 */
	public function getView (mapping:String) : View {
		var view:View = _views[mapping];
		if(!view){
			throw new ViewNotFoundException(mapping);			
		}
		return view;
	}	
}
