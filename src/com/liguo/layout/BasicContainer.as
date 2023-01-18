

/**
 * Impl�mentation de base de l'interface com.liguo.layout.container
 */
import com.liguo.layout.*;

class com.liguo.layout.BasicContainer extends BasicComponent implements Container {
		
	public static var className:String = "BasicContainer";
	public static var classPackage:String = "com.liguo.layout";
	public static var version:String = "0.2.0";
	public static var author:String = "Nicolas D�sy (liguorien)";
	public static var link:String = "http://www.liguorien.com";
	
		
	/**
	 *Array qui contient les enfants du container (Component)
	 */
	private var _components:Array;
		
	/**
	 * le layout qui g�re le positionnement des enfants du container
	 */
	private var _layout:Layout;
	
	/**
	 * donn�es membres pour le padding
	 */
	private var _paddingTop:Number;
	private var _paddingRight:Number;
	private var _paddingBottom:Number;
	private var _paddingLeft:Number;
		
		
		
	/**
	 *@constructor
	 */
	public function BasicContainer (){			
		super();						
		_components = [];
		setPadding(0);
	}
	
	
	/**
	 *Ajoute un composant
	 *@param c:Component Le composant � �tre ajout�
	 *@return l'index du nouveau composant
	 */
	public function addComponent (c:Component) : Number {
		c.setContainer(this);
		var index:Number = _components.length;
		_components[index] = c;
		return index;
	}
	
	
	/**
	 *Ajoute un composant � l'index sp�cifi�
	 *@param c:Component Le composant � �tre ajout�
	 *@param i:Number L'index
	 */
	public function addComponentAt (c:Component, i:Number) : Void {
		_components[i] = c;
		c.setContainer(this);	
	}

	
	/**
	 *Retourne les enfants du container
	 *@return Un Array contenant les enfants (Component)
	 */
	public function getComponents () : Array {
		return _components;
	}
	
	
	/**
	 *Retourne le composant � l'index sp�cifi�
	 *@return Un composant
	 */
	public function getComponentAt (i:Number) : Component {
		return _components[i];
	}
	
	
	/**
	 *Supprime un composant du container
	 *@param i:Number l'index du composant
	 *@return Le component qui a �t� supprim�
	 */
	public function removeComponentAt (i:Number) : Component {
		var c:Component = _components[i];
		_components.splice(i,1);
		return c;
	}
		
	
	/**
	 *impl�mentation de base de la m�thode draw() pour les container
	 */
	public function draw () : Void {
		getMC();//be sure the mc is created
		getLayout().doLayout(this);				
	}
	
	
	/**
	 *Assigne le Layout du container
	 *@param l:Layout Le layout
	 */
	public function setLayout (l:Layout) : Void {
		if(_layout) _layout.onRemoveLayout(this);
		(_layout = l).onSetLayout(this);		
	}
	
	
	/**
	 *Retourne une r�f�rence au layout du container
	 *@return Une r�f�rence au Layout
	 */
	public function getLayout () : Layout {
		return _layout;
	}
	
	
	/**
	 *Cr�e un MovieClip vide � l'int�rieur du container
	 *@return Le nouveau MovieClip vide 
	 */	
	public function createEmptyMC () : MovieClip {		
		var mc:MovieClip = getMC();
		var d:Number = mc.getNextHighestDepth();
		return mc.createEmptyMovieClip("_"+d,d);
	}
	
	
	/**
	 *Assigne le padding pour tous les c�t� (top,rigth,bottom,left)
	 *@param nb:Number La valeur du padding
	 */
	public function setPadding (nb:Number) : Void {
		_paddingTop = _paddingRight = _paddingBottom = _paddingLeft = nb;
	}


	/**
	 *Assigne le padding pour le c�t� droit
	 *@param nb:Number La valeur du padding
	 */
	public function setPaddingRight (nb:Number) : Void {
		_paddingRight = nb;
	}
	
	
	/**
	 *Assigne le padding pour le c�t� left
	 *@param nb:Number La valeur du padding
	 */
	public function setPaddingLeft (nb:Number) : Void {
		_paddingLeft = nb;
	}
	
	
	/**
	 *Assigne le padding pour le c�t� haut
	 *@param nb:Number La valeur du padding
	 */
	public function setPaddingTop (nb:Number) : Void {
		_paddingTop = nb;
	}
	
	
	/**
	 *Assigne le padding pour le c�t� bas
	 *@param nb:Number La valeur du padding
	 */
	public function setPaddingBottom (nb:Number) : Void {
		_paddingBottom = nb;
	}
	

	/**
	 *@return Le padding du c�t� droit	
	 */
	public function getPaddingRight () : Number {
		return _paddingRight;
	}
	
	
	/**
	 *@return Le padding du c�t� gauche	
	 */
	public function getPaddingLeft () : Number {
		return _paddingLeft;
	}
	
	/**
	 *@return Le padding du c�t� haut	
	 */	
	public function getPaddingTop () : Number {
		return _paddingTop;		
	}
	
	
	/**
	 *@return Le padding du c�t� bas	
	 */
	public function getPaddingBottom () : Number {
		return _paddingBottom;
	}	
}
