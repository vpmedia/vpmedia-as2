

/**
 * Implémentation de base de l'interface com.liguo.layout.container
 */
import com.liguo.layout.*;

class com.liguo.layout.BasicContainer extends BasicComponent implements Container {
		
	public static var className:String = "BasicContainer";
	public static var classPackage:String = "com.liguo.layout";
	public static var version:String = "0.2.0";
	public static var author:String = "Nicolas Désy (liguorien)";
	public static var link:String = "http://www.liguorien.com";
	
		
	/**
	 *Array qui contient les enfants du container (Component)
	 */
	private var _components:Array;
		
	/**
	 * le layout qui gère le positionnement des enfants du container
	 */
	private var _layout:Layout;
	
	/**
	 * données membres pour le padding
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
	 *@param c:Component Le composant à être ajouté
	 *@return l'index du nouveau composant
	 */
	public function addComponent (c:Component) : Number {
		c.setContainer(this);
		var index:Number = _components.length;
		_components[index] = c;
		return index;
	}
	
	
	/**
	 *Ajoute un composant à l'index spécifié
	 *@param c:Component Le composant à être ajouté
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
	 *Retourne le composant à l'index spécifié
	 *@return Un composant
	 */
	public function getComponentAt (i:Number) : Component {
		return _components[i];
	}
	
	
	/**
	 *Supprime un composant du container
	 *@param i:Number l'index du composant
	 *@return Le component qui a été supprimé
	 */
	public function removeComponentAt (i:Number) : Component {
		var c:Component = _components[i];
		_components.splice(i,1);
		return c;
	}
		
	
	/**
	 *implémentation de base de la méthode draw() pour les container
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
	 *Retourne une référence au layout du container
	 *@return Une référence au Layout
	 */
	public function getLayout () : Layout {
		return _layout;
	}
	
	
	/**
	 *Crée un MovieClip vide à l'intérieur du container
	 *@return Le nouveau MovieClip vide 
	 */	
	public function createEmptyMC () : MovieClip {		
		var mc:MovieClip = getMC();
		var d:Number = mc.getNextHighestDepth();
		return mc.createEmptyMovieClip("_"+d,d);
	}
	
	
	/**
	 *Assigne le padding pour tous les côté (top,rigth,bottom,left)
	 *@param nb:Number La valeur du padding
	 */
	public function setPadding (nb:Number) : Void {
		_paddingTop = _paddingRight = _paddingBottom = _paddingLeft = nb;
	}


	/**
	 *Assigne le padding pour le côté droit
	 *@param nb:Number La valeur du padding
	 */
	public function setPaddingRight (nb:Number) : Void {
		_paddingRight = nb;
	}
	
	
	/**
	 *Assigne le padding pour le côté left
	 *@param nb:Number La valeur du padding
	 */
	public function setPaddingLeft (nb:Number) : Void {
		_paddingLeft = nb;
	}
	
	
	/**
	 *Assigne le padding pour le côté haut
	 *@param nb:Number La valeur du padding
	 */
	public function setPaddingTop (nb:Number) : Void {
		_paddingTop = nb;
	}
	
	
	/**
	 *Assigne le padding pour le côté bas
	 *@param nb:Number La valeur du padding
	 */
	public function setPaddingBottom (nb:Number) : Void {
		_paddingBottom = nb;
	}
	

	/**
	 *@return Le padding du côté droit	
	 */
	public function getPaddingRight () : Number {
		return _paddingRight;
	}
	
	
	/**
	 *@return Le padding du côté gauche	
	 */
	public function getPaddingLeft () : Number {
		return _paddingLeft;
	}
	
	/**
	 *@return Le padding du côté haut	
	 */	
	public function getPaddingTop () : Number {
		return _paddingTop;		
	}
	
	
	/**
	 *@return Le padding du côté bas	
	 */
	public function getPaddingBottom () : Number {
		return _paddingBottom;
	}	
}
