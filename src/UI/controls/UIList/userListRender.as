    class UI.controls.UIList.userListRender extends UI.core.events
    {
        var createTextField, createEmptyMovieClip, label_txt, __icon, iconSpace, __iconStatus, attachMovie, __width, __height, List, hitSpace, drawRect;
        function userListRender () {
            super();
            this.createTextField("label_txt", 0, 0, 0, 50, 50);
            this.createEmptyMovieClip("hitSpace", 2);
			//label_txt.border = true;
            label_txt.autoSize = true;
            label_txt.selectable = false;
            label_txt.owner = this;
            var _local3 = new TextFormat ();
            _local3.font = "verdana";
            _local3.size = 10;
            label_txt.setNewTextFormat(_local3);
        }
        function set label(l) {
            label_txt.text = l;
            //return (label);
        }
        function get label() {
            return (label_txt.text);
        }
        function set icon(i) {
            __icon = i;
            iconSpace.removeMovieClip();
            this.attachMovie(i, "iconSpace", 3);
            setSize(__width, __height);
            //return (icon);
        }
        function get icon() {
            return (__icon);
        }
		function set iconStatus(i){
			__iconStatus.removeMovieClip();
            this.attachMovie(i, "__iconStatus", 4);
            setSize(__width, __height);
		}
        function getBestHeight() {
            return (List.__rowHeight);
        }
        function getWidth() {
            return (label_txt._x + label_txt._width);
        }
        function setSize(width, height) {
            if (iconSpace) {
                iconSpace._x = 15 - (iconSpace._width / 2);
                label_txt._x = 30;
            } else {
                label_txt._x = 0;
            }
            label_txt._width = width - iconSpace._width;
            label_txt._height = height;
            label_txt._y = (height / 2) - (label_txt._height / 2);
            iconSpace._y = (height / 2) - (iconSpace._height / 2);
            hitSpace.clear();
            drawRect(hitSpace, 0, 0, width, height, 16777215, 0);
            __width = width;
            __height = height;
			
			__iconStatus._x = hitSpace._width - __iconStatus._width - 10;
			__iconStatus._y = (height / 2) - (__iconStatus._height / 2);
			
        }
    }
