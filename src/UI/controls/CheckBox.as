    class UI.controls.CheckBox extends UI.core.events
    {
        var sel, focusRect, attachMovie, createEmptyMovieClip, createTextField, txt, __enabled, format, BoxHit, notab, BoxBase, BoxOver, dispatchEvent, drawRect;
        function CheckBox () {
            super();
            sel = true;
            focusRect = true;
            this.attachMovie("CheckBox_Base", "BoxBase", 0);
            this.attachMovie("CheckBox_Over", "BoxOver", 1);
            this.createEmptyMovieClip("BoxHit", 2);
            this.createTextField("txt", 3, 15, 0, 1, 1);
            txt.autoSize = true;
            format = new TextFormat ();
            format.font = "Verdana";
            format.size = 10;
            format["color"] = 3355443 /* 0x333333 */;
            txt.setNewTextFormat(format);
            txt.selectable = false;
            txt._y = 1;
			__enabled = true;
            BoxHit.owner = this;
            notab(BoxHit);
            BoxHit.onPress = function () {
				if(!this.owner.__enabled) return;
                this.owner.selected = !this.owner.selected;
                this.owner.dispatchEvent("click", {target:this.owner, selected:this.owner.selected});
            };
            BoxHit.onRollOver = function () {
				if(!this.owner.__enabled) return;
                this.owner.dispatchEvent("onRollOver", {target:this.owner});
            };
            BoxHit.onRollOut = (BoxHit.onReleaseOutside = function () {
				if(!this.owner.__enabled) return;
                this.owner.dispatchEvent("onRollOut", {target:this.owner});
            });
            BoxBase._y = 2;
            BoxOver._x = 3;
            BoxOver._y = 5;
            redraw();
        }
        function onKeyDown() {
            if (Key.isDown(13)) {
                selected = (!selected);
                dispatchEvent("click", {target:this, selected:selected});
            } else if (Key.isDown(32)) {
                selected = (!selected);
                dispatchEvent("click", {target:this, selected:selected});
            }
        }
        function set selected(s) {
            sel = s;
            BoxOver._visible = s;
            //return (selected);
        }
        function get selected() {
            return (sel);
        }
		function set enabled(e){
			txt.textColor = e ? 0x000000 : 0x666666;
			__enabled = e;
		}
        function get width() {
            return ((txt.textWidth + txt._x) + 6);
        }
        function get height() {
            return (19);
        }
        function setFormat(prop, val) {
            format[prop] = val;
            txt.setNewTextFormat(format);
            txt.setTextFormat(format);
        }
        function set label(l) {
            txt.text = l;
            redraw();
            //return (label);
        }
        function get label() {
            return (txt.text);
        }
        function redraw() {
            BoxHit.clear();
            drawRect(BoxHit, 0, 0, txt.textWidth + 15, 15, 16777215, 0);
        }
    }
