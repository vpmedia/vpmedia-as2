
/**
 * Le r�le d'une View est de communiquer avec les �l�ments de l'interface graphique
 */

import com.liguo.core.*;

interface com.liguo.core.View{	
		
	/**
	 *M�thode invoqu� par le controlleur lors de le reception du callback de l'action
	 */
	public function render (response:Response) : Void;	
}
