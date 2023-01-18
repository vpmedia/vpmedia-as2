
/**
 *Le rôle d'une Session est de stocker des données persistente
 */
import com.liguo.core.Context;

interface com.liguo.core.Session extends Context {
	
	/**
	 * rétabli la session comme elle était lors de sa dernière utilisation
	 */
	public function restore () : Void;
	
	
	/**
	 * sauvegarde la session afin de la réutiliser ultérieurement
	 */
	public function save () : Void;
	
}
