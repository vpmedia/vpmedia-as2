
/**
 *Interface représentant un PlugIn de l'application
 *les PlugIn servent à initialiser le context de l'application au démarrage
 *  
 * les propriétés du fichier de configuration seront envoyé
 * via le setAttribute(key,value) de l'interface Context 
 */

import com.liguo.core.*;

interface com.liguo.core.PlugIn extends Context {
	
	
	/**
	 *Méthode invoqué par le digester lors de l'initialisation de l'application
	 */
	public function init () : Void;
}
