    class UI.controls.RadioButton extends UI.core.events
    {
        var attachMovie, createEmptyMovieClip, createTextField, txt, format, BoxHit, notab, BoxBase, BoxOver, __enabled, __get__group, dispatchEvent, drawRect, radiodata;
        function RadioButton () {
            super();
            if (!_global.RadioManager) {
                _global.RadioManager = new Object ();
                _global.RadioManager.data = new Object ();
                _global.RadioManager.register = function (mc, group) {
                    if (this.data[group] == undefined) {
                        this.data[group] = {selected:mc, buttons:new Array ()};
                        this.data[group].buttons.push(mc);
                        _global.RadioManager.select(mc, group);
                    } else {
                        this.data[group].buttons.push(mc);
                     }
                };
                _global.RadioManager.select = function (mc, group) {
                    var o = this.data[group];
                    o.selected.showSelected(false);
                    o.selected = mc;
                    mc.showSelected(true);
                    var i = 0;
                    while (i < o.buttons.length) {
                        o.buttons[i].dispatchEvent("change", {target:mc});
                        i++;
                    }
                };
                _global.RadioManager.remove = function (mc, group) {
                    var o = this.data[group];
                    var i = 0;
                    while (i < o.buttons.length) {
                        if (o.buttons[i] == mc) {
                            o.buttons.splice(i, 1);
                            break;
                        }
                        i++;
                    }
                    if (o.buttons.length == 0) {
                        delete this.data[group];
                    }
                };
            }
            this.attachMovie("RadioButton_Base", "BoxBase", 0);
            this.attachMovie("RadioButton_Fill", "BoxOver", 1);
            this.createEmptyMovieClip("BoxHit", 2);
            this.createTextField("txt", 3, 15, 0, 1, 1);
            txt.autoSize = true;
            format = new TextFormat ();
            format.font = "arial";
            format.size = 10;
            format.bold = true;
            txt.setNewTextFormat(format);
            txt.selectable = false;
			__enabled = true;
            BoxHit.owner = this;
            notab(BoxHit);
            BoxHit.onPress = function () {
				if(this.owner.__enabled) this.owner.selected = !this.owner.selected;
            };
            BoxBase._y = 2;
            BoxOver._x = 4;
            BoxOver._y = 6;
            BoxOver._visible = false;
            redraw();
        }
        function onKeyDown() {
            if (Key.isDown(13)) {
                selected = (!selected);
            }
        }
        function set group(g) {
            __group = g;
            _global.RadioManager.register(this, g);
            //return (__get__group());
        }
		function set enabled(e){
			txt.textColor = e ? 0x000000 : 0x666666;
			__enabled = e;
		}
        function onUnload() {
            _global.RadioManager.remove(this, __group);
        }
        function set selected(s) {
            _global.RadioManager.select(this, __group);
            //return (selected);
        }
        function showSelected(s) {
            BoxOver._visible = s;
			if(s) dispatchEvent("click", {target:this, selected:selected});
        }
        function get selected() {
            return (BoxOver._visible);
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
		function set data(i){
			radiodata = i;
		}
		function get data(){
			return radiodata;
		}
        function get label() {
            return (txt.text);
        }
        function redraw() {
            BoxHit.clear();
            drawRect(BoxHit, 0, 0, txt.textWidth + 15, 15, 16777215, 0);
        }
        var __group = "foo";
        var focusBox = true;
    }
