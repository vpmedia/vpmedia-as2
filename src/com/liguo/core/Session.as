
/**
 *Le r�le d'une Session est de stocker des donn�es persistente
 */
import com.liguo.core.Context;

interface com.liguo.core.Session extends Context {
	
	/**
	 * r�tabli la session comme elle �tait lors de sa derni�re utilisation
	 */
	public function restore () : Void;
	
	
	/**
	 * sauvegarde la session afin de la r�utiliser ult�rieurement
	 */
	public function save () : Void;
	
}
