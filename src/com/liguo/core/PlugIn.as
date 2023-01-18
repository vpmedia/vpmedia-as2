
/**
 *Interface repr�sentant un PlugIn de l'application
 *les PlugIn servent � initialiser le context de l'application au d�marrage
 *  
 * les propri�t�s du fichier de configuration seront envoy�
 * via le setAttribute(key,value) de l'interface Context 
 */

import com.liguo.core.*;

interface com.liguo.core.PlugIn extends Context {
	
	
	/**
	 *M�thode invoqu� par le digester lors de l'initialisation de l'application
	 */
	public function init () : Void;
}
