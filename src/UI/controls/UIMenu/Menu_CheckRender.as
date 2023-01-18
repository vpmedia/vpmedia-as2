    class UI.controls.UIMenu.Menu_CheckRender extends UI.core.movieclip
    {
        var attachMovie, cMC, __label;
        function Menu_CheckRender () {
            super();
            this.attachMovie("Label", "__label", 0);
            this.attachMovie("blackCheck", "cMC", 1);
            cMC._x = 1;
            __label._x = 10;
        }
        function set text(t) {
            __label.text = t;
            //return (text);
        }
        function get text() {
            return (__label.text);
        }
        function set selected(s) {
            cMC._visible = s;
            //return (selected);
        }
        function get selected() {
            return (cMC._visible);
        }
		function setFormat(prop, val) {
			__label.setFormat(prop, val);
        }
        function setSize(w, h) {
            __label.setSize(w - 10, h);
            cMC._y = Math.round((h / 2) - (cMC._height / 2));
        }
    }
