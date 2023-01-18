

/**
 *Le r�le d'un Forward est de faire le lien entre un Action et un View.
 */ 

import com.liguo.core.*;

interface com.liguo.core.Forward {
	
	
	/**
	 * assigne le nom du Forward. (success, error, etc...)
	 */
	public function setName (name:String) : Void;
	
	
	/**
	 * r�cup�re le nom du Forward
	 */
	public function getName () : String;
	
	
	/**
	 * Assigne le mapping de l'Action que le Forward utilisera
	 */
	public function setActionMapping (mapping:String) : Void;
	
	
	/**
	 * R�cup�re le mapping de l'Action que le Forward utilise
	 */
	public function getActionMapping () : String;
	
	
	/**
	 * Assigne le mapping de la View que le Forward utilisera
	 */
	public function setViewMapping (mapping:String) : Void;
	
	
	/**
	 * R�cup�re le mapping de la View que le Forward utilise
	 */
	public function getViewMapping () : String;
	
	
	/**
	 * Proc�de � l'ex�cution du Forward 
	 */
	public function doFoward (response:Response) : Void;
	
}
