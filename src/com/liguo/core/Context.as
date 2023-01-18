
/**
 *Interface repr�sentant un context g�n�rique pouvant
 * stocker des attributs par cl�/valeur
 */ 
interface com.liguo.core.Context {
	
	/**
	 *Ajoute un attribut dans ce context
	 *@param key La cl� de l'attribut
	 *@param La valeur de l'attribut
	 */
	public function setAttribute (key:String, value) : Void;
		
		
	/**
	 *Ajoute plusieurs attributs dans ce context.
	 *@param obj Un object contenant les attributs
	 */
	public function setAttributes (obj) : Void;
	
	
	/**
	 *R�cup�re un attribut qui est dans ce context.
	 *@param key La cl� de l'attribut	 
	 *@return La valeur de l'attribut (null si l'attribut est absent)
	 */
	public function getAttribute (key:String);
	
	
	/**	 
	 *@return un objet contenant tout les attibuts	
	 */
	public function getAttributes () : Object;
	
	
	/**
	 *Supprime un attribut qui est dans ce context.
	 *@param key La cl� de l'attribut	 
	 */
	public function remove (key:String) : Void;	
	
	
	/**
	 *Supprime tous les attributs du context.	
	 */
	public function removeAll () : Void;
	
	
	/**
	 *R�cup�re la liste de cl� des attributs du context
	 *@return Un Array contenant le nom des cl�s
	 */
	public function getAttributesNames () : Array;
	
}