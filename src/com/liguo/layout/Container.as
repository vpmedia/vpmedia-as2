

/**
 * Interface qui repr�sente un Container
 *un Container est l'extension d'un Component pouvant contenir d'autre Component
 */
import com.liguo.layout.*;

interface com.liguo.layout.Container extends Component {
		
	
	/**
	 *Ajoute un composant
	 *@param c:Component Le composant � �tre ajout�
	 *@return l'index du nouveau composant
	 */
	public function addComponent(c:Component) : Number;
	
	
	/**
	 *Ajoute un composant � l'index sp�cifi�
	 *@param c:Component Le composant � �tre ajout�
	 *@param i:Number L'index
	 */
	public function addComponentAt(c:Component, i:Number) : Void;

	
	/**
	 *Retourne les enfants du container
	 *@return Un Array contenant les enfants (Component)
	 */
	public function getComponents() : Array;
	
	
	/**
	 *Retourne le composant � l'index sp�cifi�
	 *@return Un composant
	 */
	public function getComponentAt(i:Number) : Component;
		
		
	/**
	 *Supprime un composant du container
	 *@param i:Number l'index du composant
	 *@return Le component qui a �t� supprim�
	 */
	public function removeComponentAt(i:Number) : Component;
		
	
	/**
	 *Assigne le Layout du container
	 *@param l:Layout Le layout
	 */
	public function setLayout(l:Layout) : Void;
	
	
	/**
	 *Retourne une r�f�rence au layout du container
	 *@return Une r�f�rence au Layout
	 */
	public function getLayout() : Layout;
		
	
	/**
	 *Cr�e un MovieClip vide � l'int�rieur du container
	 *@return Le nouveau MovieClip vide 
	 */	
	public function createEmptyMC() : MovieClip;
	
	
	/**
	 *Assigne le padding pour tous les c�t� (top,rigth,bottom,left)
	 *@param nb:Number La valeur du padding
	 */
	public function setPadding(nb:Number) : Void;


	/**
	 *Assigne le padding pour le c�t� droit
	 *@param nb:Number La valeur du padding
	 */
	public function setPaddingRight(nb:Number) : Void;
			
	
	/**
	 *Assigne le padding pour le c�t� left
	 *@param nb:Number La valeur du padding
	 */
	public function setPaddingLeft(nb:Number) : Void;
	
	
	/**
	 *Assigne le padding pour le c�t� haut
	 *@param nb:Number La valeur du padding
	 */
	public function setPaddingTop(nb:Number) : Void;
	
	
	/**
	 *Assigne le padding pour le c�t� bas
	 *@param nb:Number La valeur du padding
	 */
	public function setPaddingBottom(nb:Number) : Void;
	

	/**
	 *@return Le padding du c�t� droit	
	 */
	public function getPaddingRight() : Number;
	
	
	/**
	 *@return Le padding du c�t� gauche	
	 */	
	public function getPaddingLeft() : Number;
	
	
	/**
	 *@return Le padding du c�t� haut	
	 */	
	public function getPaddingTop() : Number;
	
	
	/**
	 *@return Le padding du c�t� bas	
	 */
	public function getPaddingBottom() : Number;
}
