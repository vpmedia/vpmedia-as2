

/**
 * Interface qui représente un Container
 *un Container est l'extension d'un Component pouvant contenir d'autre Component
 */
import com.liguo.layout.*;

interface com.liguo.layout.Container extends Component {
		
	
	/**
	 *Ajoute un composant
	 *@param c:Component Le composant à être ajouté
	 *@return l'index du nouveau composant
	 */
	public function addComponent(c:Component) : Number;
	
	
	/**
	 *Ajoute un composant à l'index spécifié
	 *@param c:Component Le composant à être ajouté
	 *@param i:Number L'index
	 */
	public function addComponentAt(c:Component, i:Number) : Void;

	
	/**
	 *Retourne les enfants du container
	 *@return Un Array contenant les enfants (Component)
	 */
	public function getComponents() : Array;
	
	
	/**
	 *Retourne le composant à l'index spécifié
	 *@return Un composant
	 */
	public function getComponentAt(i:Number) : Component;
		
		
	/**
	 *Supprime un composant du container
	 *@param i:Number l'index du composant
	 *@return Le component qui a été supprimé
	 */
	public function removeComponentAt(i:Number) : Component;
		
	
	/**
	 *Assigne le Layout du container
	 *@param l:Layout Le layout
	 */
	public function setLayout(l:Layout) : Void;
	
	
	/**
	 *Retourne une référence au layout du container
	 *@return Une référence au Layout
	 */
	public function getLayout() : Layout;
		
	
	/**
	 *Crée un MovieClip vide à l'intérieur du container
	 *@return Le nouveau MovieClip vide 
	 */	
	public function createEmptyMC() : MovieClip;
	
	
	/**
	 *Assigne le padding pour tous les côté (top,rigth,bottom,left)
	 *@param nb:Number La valeur du padding
	 */
	public function setPadding(nb:Number) : Void;


	/**
	 *Assigne le padding pour le côté droit
	 *@param nb:Number La valeur du padding
	 */
	public function setPaddingRight(nb:Number) : Void;
			
	
	/**
	 *Assigne le padding pour le côté left
	 *@param nb:Number La valeur du padding
	 */
	public function setPaddingLeft(nb:Number) : Void;
	
	
	/**
	 *Assigne le padding pour le côté haut
	 *@param nb:Number La valeur du padding
	 */
	public function setPaddingTop(nb:Number) : Void;
	
	
	/**
	 *Assigne le padding pour le côté bas
	 *@param nb:Number La valeur du padding
	 */
	public function setPaddingBottom(nb:Number) : Void;
	

	/**
	 *@return Le padding du côté droit	
	 */
	public function getPaddingRight() : Number;
	
	
	/**
	 *@return Le padding du côté gauche	
	 */	
	public function getPaddingLeft() : Number;
	
	
	/**
	 *@return Le padding du côté haut	
	 */	
	public function getPaddingTop() : Number;
	
	
	/**
	 *@return Le padding du côté bas	
	 */
	public function getPaddingBottom() : Number;
}
