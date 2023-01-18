
/**
 * Interface que les écouteurs d'un RessourceBundle doivent implémenter 
 */
import com.liguo.lang.*;

interface com.liguo.lang.BundleListener {

	/**
	 * invoqué lorsque le chargement du bundle est terminé
	 */
	public function onLoadComplete (bundle:RessourceBundle) : Void;

}
