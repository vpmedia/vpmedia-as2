class net.stevensacks.data.XML2AS 
{
	public static function parse(n, r) {
		var a, d, k;
		if (r[k=n.nodeName] == null) r = ((a=r[k]=[{}]))[d=0];
		else r = (a=r[k])[d=r[k].push({})-1];
		if (n.hasChildNodes()) {
			if ((k=n.firstChild.nodeType) == 1) {
				r.attributes = n.attributes;
				for (var i in k=n.childNodes) XML2AS.parse(k[i], r);
			} else if (k == 3) {
				a[d] = new String(n.firstChild.nodeValue);
				a[d].attributes = n.attributes;
			}
		}else r.attributes = n.attributes;
	}
};