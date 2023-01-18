

/**
 * Interface qui représente un Layout
 *Le rôle d'un Layout est gérer le positionnement et la taille des enfants d'un Container
 *
 *@author Nicolas Desy  aka  liguorien   http://www.liguorien.com
 */

import com.liguo.layout.*;

interface com.liguo.layout.Layout {
		
	/**
	 *Réactualise la position et la taille des enfants d'un container
	 *cette méthode est invoqué par le container en question
	 *@param c:Container Le container
	 */
	public function doLayout(c:Container) : Void;
	
	
	/**
	 *Invoqué par le Container lorsque le layout lui est assigné
	 *@param c:Container Le container
	 */
	public function onSetLayout(c:Container) : Void;	
	
	
	/**
	 *Invoqué par le Container lorsque le layout ne lui est plus assigné
	 *@param c:Container Le container
	 */
	public function onRemoveLayout(c:Container) : Void;	
	
}
