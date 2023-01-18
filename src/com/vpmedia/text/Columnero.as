/**
 * @authors: Xavi Beumala http://www.code4net.com
 *			 Elecash http://www.elechash.com/blog
 *			 Dani http://desarrollo-web.blogspot.com/
 * @version: 1.0
 *
 * KNOWN ISSUES: cuando se quieren renderizar imágenes se corta el texto. Esto
 * se debe a que la imagen tiene un retraso en cargarse y sólo es cuando se carga
 * que se sabe lo que ocupará en altura. Por ello si no indicamos en el tag <img>
 * la altua y la anchura se perderá texto. 
 * 
 *
 ***/
import mx.core.UIObject;
import TextField.StyleSheet;
import mx.utils.Delegate;
class com.vpmedia.text.Columnero extends UIObject
{
	private var _nCols:Number = new Number ();
	private var _mediania:Number = new Number ();
	private var formato_fmt:TextFormat;
	private var boundingBox_mc:MovieClip;
	private var _texto:String;
	private var _css:String;
	private var styleSheet:StyleSheet;
	private var _notDrawedText:String;
	private var openTags:Array = new Array ();
	private var cssLoaded:Boolean;
	// Número de columnas
	[Inspectable(defaultValue=3)]
	 public function get nCols ():Number
	{
		return _nCols;
	}
	public function set nCols (nc:Number)
	{
		_nCols = nc;
		invalidate ();
	}
	// Separación entre columnas
	[Inspectable(defaultValue=10)]
	 public function get mediania ():Number
	{
		return _mediania;
	}
	public function set mediania (m:Number)
	{
		_mediania = m;
		invalidate ();
	}
	// Texto a renderizar
	[Inspectable(defaultValue="Texto de prueba")]
	 public function get texto ():String
	{
		return _texto;
	}
	public function set texto (t:String)
	{
		_texto = t;
		invalidate ();
	}
	// Archivo de css a aplicar
	[Inspectable(defaultValue="file.css")]
	 public function get css ():String
	{
		return _css;
	}
	public function set css (t:String)
	{
		_css = t;
		cssLoaded = false;
	}
	// evento disparado cuando se han terminado de cargar las css's
	// se tiene que redibujar el componente ya que no ocupa el mismo
	// espacio el texto que el texto con formato
	private function onCSSLoad ()
	{
		cssLoaded = true;
		invalidate ();
	}
	public function init ()
	{
		super.init ();
		formato_fmt = new TextFormat ();
		formato_fmt.font = "_sans";
		formato_fmt.size = 10;
		boundingBox_mc._visible = false;
		styleSheet = new StyleSheet ();
		styleSheet.onLoad = Delegate.create (this, onCSSLoad);
	}
	public function createChildren ()
	{
		_notDrawedText = new String ();
		var it:Number;
		var col:TextField;
		var w:Number = Math.round ((__width - nCols * mediania) / nCols);
		if (!cssLoaded)
		{
			styleSheet.load (css);
		}
		for (it = 0; it < nCols; it++)
		{
			createTextField ("columna" + it, it + 1, (w + mediania) * it, 0, w, __height);
			col = this["columna" + it];
			col.autoSize = "none";
			col.multiline = true;
			col.wordWrap = true;
			col.html = true;
			col.setNewTextFormat (formato_fmt);
			col.styleSheet = styleSheet;
		}
	}
	// Renderizado de las columnas
	// Para forzar el repintado del componente no usar esta función,
	// usar invalidate()
	public function draw ()
	{
		boundingBox_mc._height = __height;
		boundingBox_mc._width = __width;
		_xscale = _yscale = 100;
		var tmpCol = 0;
		var openTag:Array;
		var closeTag:Array;
		var words:Array;
		var tmpText:String = new String ("");
		var lastWord:String;
		var i, j, k;
		openTag = texto.split ("<");
		for (i = 0; i < openTag.length; i++)
		{
			words = new Array ();
			closeTag = openTag[i].split (">");
			var isEndTag = closeTag[0].substr (0, 1) == "/";
			var isSimpleTag = (closeTag[0].substr (closeTag[0].length - 1, 1) == "/");
			if (closeTag.length == 1 && !isEndTag)
			{
				words.push (closeTag[0]);
			}
			else
			{
				if (closeTag.length == 2)
				{
					if (isEndTag && !isSimpleTag)
					{
						tmpText += createCloseTag (closeTag[0]);
					}
					else if (!isEndTag && !isSimpleTag)
					{
						tmpText += createOpenTag (closeTag[0]);
					}
					else if (isSimpleTag)
					{
						tmpText += createSimpleTag (closeTag[0]);
					}
					words = closeTag[1].split (" ");
				}
			}
			for (j = 0; j < words.length; j++)
			{
				lastWord = words[j].length;
				tmpText += words[j] + " ";
				var col:TextField = this["columna" + tmpCol];
				col.htmlText = tmpText;
				if (col.maxscroll > 1)
				{
					tmpText = tmpText.substring (0, tmpText.length - lastWord - 1);
					for (k = openTags.length - 1; k >= 0; k--)
					{
						tmpText += openTags[k].close;
					}
					col.htmlText = tmpText;
					tmpCol++;
					tmpText = new String ();
					for (k = 0; k < openTags.length; k++)
					{
						tmpText += openTags[k].open;
					}
					tmpText += words[j] + " ";
					this["columna" + tmpCol].htmlText = tmpText;
				}
			}
		}
	}
	private function createOpenTag (tagName:String)
	{
		var o:String = "<" + tagName + ">";
		var c:String = "</" + tagName.split (" ")[0] + ">";
		openTags.push ({open:o, close:c});
		return o;
	}
	private function createCloseTag (tagName:String)
	{
		openTags.pop ();
		return "<" + tagName + ">";
	}
	private function createSimpleTag (tagName:String)
	{
		return "<" + tagName + ">";
	}
	// función invocada cuando se haga un setSize
	// tenemos que redimensionar las columnas, 
	// para eso las volvemos a crear
	public function size ()
	{
		createChildren ();
		invalidate ();
	}
	public function getPreferredHeight ()
	{
		return __height;
	}
	public function getPreferredWidth ()
	{
		return __width;
	}
	// Nos permite obtener el texto que se ha renderizado
	// en la columna i-ésima
	public function getTextAtColumn (i:Number):String
	{
		return this["columna" + i].htmlText;
	}
	// Si el texto que se tenía que renderizar no ha cabido 
	// en las columnas esta variable almacenará el texto pendiente
	public function get notDrawedText ():String
	{
		return _notDrawedText;
	}
}
