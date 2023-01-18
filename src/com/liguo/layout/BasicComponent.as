

/**
 * Impl�mentation de base de l'interface com.liguo.layout.Component
 */
import com.liguo.layout.*;

class com.liguo.layout.BasicComponent implements Component {	
		
	public static var className:String = "BasicComponent";
	public static var classPackage:String = "com.liguo.layout";
	public static var version:String = "0.2.0";
	public static var author:String = "Nicolas D�sy (liguorien)";
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
	 *r�f�rence au container parent
	 */
	private var _container:Container;
	
	
	/**
	 *r�f�rence au MovieClip du composant
	 */
	private var _mc:MovieClip;
	
	
	/**
	 *donn�es membres pour les margin
	 */
	private var _marginTop:Number; 
	private var _marginRight:Number;	
	private var _marginBottom:Number;	
	private var _marginLeft:Number;
	

	/**
	 *largeur pr�f�r� du composant
	 */
	private var _preferredWidth:Number;
	
	
	/**
	 *hauteur pr�f�r� du composant
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
	 *R�actualise l'affichage du composant
	 */
	public function draw () : Void{
		
	}
		
			
	/**
	 *Lib�re les ressources du composant
	 */
	public function invalidate () : Void{
		_mc.removeMovieClip();
	}
			
		
	/**	 
	 *@return une r�f�rence au MovieClip du composant
	 */
	public function getMC () : MovieClip {
		if(!_mc)_mc = _container.createEmptyMC();
		return _mc;
	}
				
	/**
	 *D�place le composant � l'int�rieur de son parent de fa�on absolu
	 *@param x:Number coordonn� horizontal
	 *@param y:Number coordonn� vertical
	 */	
	public function moveTo (x:Number, y:Number) : Void{
		_mc._x = Math.round(x);
		_mc._y = Math.round(y);
	}
	
	
	/**
	 *D�place le composant � l'int�rieur de son parent de fa�on relative
	 *@param x:Number coordonn� horizontal
	 *@param y:Number coordonn� vertical
	 */
	public function moveBy (x:Number, y:Number) : Void{
		_mc._x = Math.round(_mc._x + x);
		_mc._y = Math.round(_mc._y + y);
	}
	
	
	/**
	 *Redimensionne le composant � une dimension sp�cifique
	 *@param w:Number La largeur
	 *@param h:Number La hauteur
	 */	
	public function resizeTo (w:Number, h:Number) : Void{
		_width = w;
		_height = h;
	}
		
	
	/**
	 *Redimensionne le composant de fa�on relative
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
	 *Retourne une r�f�rence au parent (Container)
	 *@return The container	 
	 */	
	public function getContainer () : Container{
		return _container;
	}
		
			
	/**
	 *Assigne la largeur du composant
	 *pour obtenir un changement au niveau de l'affichage, il faut invoquer la m�thode draw()
	 *@param w:Number La largeur
	 */	
	public function setWidth (w:Number) : Void {
		_width = w;
	}
	
	
	/**
	 *Assigne la hauteur du composant
	 *pour obtenir un changement au niveau de l'affichage, il faut invoquer la m�thode draw()
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
	 *Assigne la largeur pr�f�r� du composant
	 *@param w:Number la largeur pr�f�r�
	 */	
	public function setPreferredWidth (w:Number) : Void {
		_width = _preferredWidth = w;
	}
	
	
	/**
	 *Assigne la hauteur pr�f�r� du composant
	 *@param h:Number la hauteur pr�f�r�
	 */	
	public function setPreferredHeight (h:Number) : Void {
		_height = _preferredHeight = h;
	}
	
	
	/**	
	 *@return la largeur pr�f�r� du composant
	 */	
	public function getPreferredWidth () : Number {
		return _preferredWidth;
	}
	
	
	/**	
	 *@return la hauteur pr�f�r� du composant
	 */	
	public function getPreferredHeight () : Number {
		return _preferredHeight;
	}


	/**
	 *Assigne la marge du composant pour tous les c�t�s (top,rigth,bottom,left)
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
