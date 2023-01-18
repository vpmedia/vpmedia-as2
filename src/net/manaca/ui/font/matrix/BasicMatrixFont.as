import net.manaca.lang.BObject;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-3-23
 */
class net.manaca.ui.font.matrix.BasicMatrixFont extends BObject {
	private var className : String = "net.manaca.ui.font.matrix.BasicMatrixFont";
	public function BasicMatrixFont() {
		super();
	}
	static function getAllStrMatrix(mat, str):Array{
        if (mat != undefined)
        {
            var _l2 = new Array();
            var _l1 = 0;
            while (_l1 < str.length)
            {
                _l2 = unite(_l2, getAStrMatrix(mat, str.charAt(_l1)));
                _l1++;
            }
            return(_l2);
        }
        return(null);
    }
    static function getAStrMatrix(mat, str):Array{
        if (mat != undefined)
        {
            var _l2 = mat[str];
            var _l4 = net.manaca.util.ArrayUtil.getMax(_l2).toString(2).length;
            var _l3 = new Array();
            var _l1 = 0;
            while (_l1 < _l2.length)
            {
                _l3.push(getLineArray(_l2[_l1], _l4));
                _l1++;
            }
            return(_l3);
        }
        return(null);
    }
    static function unite(m1, m2)
    {
        if (m1.length > 0)
        {
            var _l2 = 0;
            while (_l2 < m1.length)
            {
                var _l1 = 0;
                while (_l1 < m2[_l2].length)
                {
                    m1[_l2].push(m2[_l2][_l1]);
                    _l1++;
                } // end while
                _l2++;
            } // end while
            return(m1);
        } // end if
        return(m2);
    } // End of the function
    static function getLineArray(num, l)
    {
        var _l2 = num;
        var _l3 = new Array();
        while (_l2 > 0)
        {
            _l3.push(_l2 & 1);
            _l2 = _l2 >> 1;
        } // end while
        if (_l3.length < l)
        {
            var _l4 = _l3.length;
            var _l1 = 0;
            while (_l1 < l - _l4)
            {
                _l3.push(0);
                _l1++;
            } // end while
        } // end if
        _l3.reverse();
        return(_l3);
    }
}