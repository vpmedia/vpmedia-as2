

/**
 * Interface qui repr�sente un Layout
 *Le r�le d'un Layout est g�rer le positionnement et la taille des enfants d'un Container
 *
 *@author Nicolas Desy  aka  liguorien   http://www.liguorien.com
 */

import com.liguo.layout.*;

interface com.liguo.layout.Layout {
		
	/**
	 *R�actualise la position et la taille des enfants d'un container
	 *cette m�thode est invoqu� par le container en question
	 *@param c:Container Le container
	 */
	public function doLayout(c:Container) : Void;
	
	
	/**
	 *Invoqu� par le Container lorsque le layout lui est assign�
	 *@param c:Container Le container
	 */
	public function onSetLayout(c:Container) : Void;	
	
	
	/**
	 *Invoqu� par le Container lorsque le layout ne lui est plus assign�
	 *@param c:Container Le container
	 */
	public function onRemoveLayout(c:Container) : Void;	
	
}
