
/**
 * Interface que les �couteurs d'un RessourceBundle doivent impl�menter 
 */
import com.liguo.lang.*;

interface com.liguo.lang.BundleListener {

	/**
	 * invoqu� lorsque le chargement du bundle est termin�
	 */
	public function onLoadComplete (bundle:RessourceBundle) : Void;

}
