

/**
 * Implémentation de base de l'interface com.liguo.layout.Component
 */
import com.liguo.layout.*;

class com.liguo.layout.BasicComponent implements Component {	
		
	public static var className:String = "BasicComponent";
	public static var classPackage:String = "com.liguo.layout";
	public static var version:String = "0.2.0";
	public static var author:String = "Nicolas Désy (liguorien)";
	public static var link:String = "http://www.liguorien.com";
	
	
	/**
	 *la largeur actuelle du composant
	 */
	private var _width:Number; 
	
	
	/**
	 *la hauteur actuelle du composant
	 */
	private var _height:Number;
	
	
	/**
	 *référence au container parent
	 */
	private var _container:Container;
	
	
	/**
	 *référence au MovieClip du composant
	 */
	private var _mc:MovieClip;
	
	
	/**
	 *données membres pour les margin
	 */
	private var _marginTop:Number; 
	private var _marginRight:Number;	
	private var _marginBottom:Number;	
	private var _marginLeft:Number;
	

	/**
	 *largeur préféré du composant
	 */
	private var _preferredWidth:Number;
	
	
	/**
	 *hauteur préféré du composant
	 */
	private var _preferredHeight:Number;

				
	/**
	 *@contructor
	 */			
	public function BasicComponent (){
		setMargin(0);		
		setPreferredWidth(0);
		setPreferredHeight(0);
	}
				
    /**
	 *Réactualise l'affichage du composant
	 */
	public function draw () : Void{
		
	}
		
			
	/**
	 *Libère les ressources du composant
	 */
	public function invalidate () : Void{
		_mc.removeMovieClip();
	}
			
		
	/**	 
	 *@return une référence au MovieClip du composant
	 */
	public function getMC () : MovieClip {
		if(!_mc)_mc = _container.createEmptyMC();
		return _mc;
	}
				
	/**
	 *Déplace le composant à l'intérieur de son parent de façon absolu
	 *@param x:Number coordonné horizontal
	 *@param y:Number coordonné vertical
	 */	
	public function moveTo (x:Number, y:Number) : Void{
		_mc._x = Math.round(x);
		_mc._y = Math.round(y);
	}
	
	
	/**
	 *Déplace le composant à l'intérieur de son parent de façon relative
	 *@param x:Number coordonné horizontal
	 *@param y:Number coordonné vertical
	 */
	public function moveBy (x:Number, y:Number) : Void{
		_mc._x = Math.round(_mc._x + x);
		_mc._y = Math.round(_mc._y + y);
	}
	
	
	/**
	 *Redimensionne le composant à une dimension spécifique
	 *@param w:Number La largeur
	 *@param h:Number La hauteur
	 */	
	public function resizeTo (w:Number, h:Number) : Void{
		_width = w;
		_height = h;
	}
		
	
	/**
	 *Redimensionne le composant de façon relative
	 *@param w:Number La largeur
	 *@param h:Number La hauteur
	 */
	public function resizeBy (w:Number, h:Number) : Void{
		_width += w;
		_height += h;
	}	
	
	
	/**
	 *Assigne le parent (Container) du composant
	 *@param c:Container Le container	 
	 */	
	public function setContainer (c:Container) : Void{
		_container = c;		
	}
	
	
	/**
	 *Retourne une référence au parent (Container)
	 *@return The container	 
	 */	
	public function getContainer () : Container{
		return _container;
	}
		
			
	/**
	 *Assigne la largeur du composant
	 *pour obtenir un changement au niveau de l'affichage, il faut invoquer la méthode draw()
	 *@param w:Number La largeur
	 */	
	public function setWidth (w:Number) : Void {
		_width = w;
	}
	
	
	/**
	 *Assigne la hauteur du composant
	 *pour obtenir un changement au niveau de l'affichage, il faut invoquer la méthode draw()
	 *@param h:Number La hauteur
	 */
	public function setHeight (h:Number) : Void {
		_height = h;
	}
	 
	 
	/**	
	 *@return La largeur du composant
	 */	
	public function getWidth () : Number {
		return _width;
	}
	
	
	/**	
	 *@return La hauteur du composant
	 */	
	public function getHeight () : Number {
		return _height;
	}
	

	/**
	 *Assigne la largeur préféré du composant
	 *@param w:Number la largeur préféré
	 */	
	public function setPreferredWidth (w:Number) : Void {
		_width = _preferredWidth = w;
	}
	
	
	/**
	 *Assigne la hauteur préféré du composant
	 *@param h:Number la hauteur préféré
	 */	
	public function setPreferredHeight (h:Number) : Void {
		_height = _preferredHeight = h;
	}
	
	
	/**	
	 *@return la largeur préféré du composant
	 */	
	public function getPreferredWidth () : Number {
		return _preferredWidth;
	}
	
	
	/**	
	 *@return la hauteur préféré du composant
	 */	
	public function getPreferredHeight () : Number {
		return _preferredHeight;
	}


	/**
	 *Assigne la marge du composant pour tous les côtés (top,rigth,bottom,left)
	 *@param nb:Number Le marge
	 */
	public function setMargin (nb:Number) : Void {
		_marginTop = _marginRight = _marginBottom = _marginLeft = nb;
	}


	/**
	 *Assigne la marge de droite
	 *@param nb:Number la marge de droite
	 */
	public function setMarginRight (nb:Number) : Void {
		_marginRight = nb;
	}
	
	
	/**
	 *Assigne la marge de gauche
	 *@param nb:Number la marge de gauche
	 */
	public function setMarginLeft (nb:Number) : Void {
		_marginLeft = nb;
	}
	
	
	/**
	 *Assigne la marge du haut
	 *@param nb:Number la marge du haut
	 */
	public function setMarginTop (nb:Number) : Void {
		_marginTop = nb;
	}
	
	
	/**
	 *Assigne la marge du bas
	 *@param nb:Number la marge du bas
	 */
	public function setMarginBottom (nb:Number) : Void {
		_marginBottom = nb;
	}
	

	/**	
	 *@return la marge de droite du composant
	 */	
	public function getMarginRight () : Number {
		return _marginRight;
	}
	
	/**	
	 *@return la marge de gauche du composant
	 */		
	public function getMarginLeft () : Number {
		return _marginLeft;
	}
	
	/**	
	 *@return la marge du haut du composant
	 */	
	public function getMarginTop () : Number {
		return _marginTop;
	}
	
	/**	
	 *@return la marge du bas du composant
	 */	
	public function getMarginBottom () : Number {
		return _marginBottom;
	}
}
