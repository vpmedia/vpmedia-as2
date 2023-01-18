
/**
 * Le rôle d'une View est de communiquer avec les éléments de l'interface graphique
 */

import com.liguo.core.*;

interface com.liguo.core.View{	
		
	/**
	 *Méthode invoqué par le controlleur lors de le reception du callback de l'action
	 */
	public function render (response:Response) : Void;	
}
