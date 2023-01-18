
/**
 *Le r�le d'une Response est de transmettre � une View les donn�es re�u d'une Action
 */ 

import com.liguo.core.*;

interface com.liguo.core.Response extends Context {
	
	/**
	 *R�cup�re la session du controlleur
	 *@return une r�f�rence � la session du controlleur
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
	 *retourne le mapping de l'Action qui est � l'origine de cette Response
	 */
	public function getAction () : String;
	
}
