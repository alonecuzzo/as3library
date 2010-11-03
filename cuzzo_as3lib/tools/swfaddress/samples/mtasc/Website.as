class Website {

    private var _mc:MovieClip;
    
    public function Website(mc:MovieClip) {

        _mc = mc;
        
        Stage.scaleMode = 'noScale';
        Stage.align = 'T';
        
        _mc.beginFill(0xFFFFFF);
        drawRect(_mc, 0, 0, 480, 2480);
        _mc.endFill();
        
        var title_fmt:TextFormat = new TextFormat();
        title_fmt.font = 'Arial';
        title_fmt.bold = true;
        title_fmt.size = 32;
        title_fmt.color = 0x666666;
        title_fmt.letterSpacing = -2.5;
        
        _mc.title_txt = _mc.createTextField('title_txt', _mc.getNextHighestDepth(), 38, 20, 20, 20);
        _mc.title_txt.autoSize = 'left';
        _mc.title_txt.selectable = false;            
        _mc.title_txt.antiAliasType = 'advanced';
        _mc.title_txt.setNewTextFormat(title_fmt);
        _mc.title_txt.text = 'SWFAddress Website';
        
        _mc.home_mc = drawButton(_mc, 'HOME');
        _mc.home_mc._x = 40;
        _mc.home_mc._y = 80;
        _mc.home_mc.onRelease = function() {
            SWFAddress.setValue('/');
        }
        
        _mc.about_mc = drawButton(_mc, 'ABOUT');
        _mc.about_mc._x = _mc.home_mc._x + _mc.home_mc._width + 2;
        _mc.about_mc._y = 80;
        _mc.about_mc.onRelease = function() {
            SWFAddress.setValue('/about/');
        }
        
        _mc.contact_mc = drawButton(_mc, 'CONTACT');
        _mc.contact_mc._x = _mc.about_mc._x + _mc.about_mc._width + 2;
        _mc.contact_mc._y = 80;
        _mc.contact_mc.onRelease = function() {
            SWFAddress.setValue('/contact/');
        }

        _mc.self_mc = drawLink(_mc, 'MTASC Website (Same window)');
        _mc.self_mc._x = 40;
        _mc.self_mc._y = 120;
        _mc.self_mc.onRelease = function() {
            SWFAddress.href('http://www.mtasc.org/');
        }

        _mc.blank_mc = drawLink(_mc, 'MTASC Mailing List (Blank window)');
        _mc.blank_mc._x = 40;
        _mc.blank_mc._y = 140;
        _mc.blank_mc.onRelease = function() {
            SWFAddress.href('http://lists.motion-twin.com/mailman/listinfo/mtasc', '_blank');
        }  

        _mc.mail_mc = drawLink(_mc, 'MTASC Mailing List Post (E-mail)');
        _mc.mail_mc._x = 40;
        _mc.mail_mc._y = 160;
        _mc.mail_mc.onRelease = function() {
            SWFAddress.href('mailto:mtasc@lists.motion-twin.com');
        }  
        
        _mc.popup_mc = drawLink(_mc, 'MTASC Successor (Popup window)');
        _mc.popup_mc._x = 40;
        _mc.popup_mc._y = 180;
        _mc.popup_mc.onRelease = function() {
            SWFAddress.popup('http://www.haxe.org/','haxe',
                '"toolbar=0,location=0,status=0,menubar=0,scrollbars=0,resizable=1,width=960,height=620,left=" + (screen.width - 960)/2 + ",top=" + (screen.height - 620)/2',
                'popup.focus();');
        }
        
        _mc.back_mc = drawLink(_mc, '<a href="asfunction:SWFAddress.back">&lt;&lt; Back</a>');
        _mc.back_mc._x = 40;
        _mc.back_mc._y = 240;
 
        _mc.forward_mc = drawLink(_mc, '<a href="asfunction:SWFAddress.forward">Forward &gt;&gt;</a>');
        _mc.forward_mc._x = 100;
        _mc.forward_mc._y = 240;
 
        SWFAddress.addEventListener(SWFAddressEvent.CHANGE, delegate(this, handleChange));
    }
    
    public function handleChange(e:SWFAddressEvent):Void {
        _mc.home_mc.label_txt.textColor = (e.value == '/') ? 0xCCCCCC : 0xFFFFFF;
        _mc.about_mc.label_txt.textColor = (e.value == '/about/') ? 0xCCCCCC : 0xFFFFFF;
        _mc.contact_mc.label_txt.textColor = (e.value == '/contact/') ? 0xCCCCCC : 0xFFFFFF;

        var title = 'SWFAddress Website';
        for (var i = 0; i < e.pathNames.length; i++) {
            title += ' / ' + e.pathNames[i].substr(0,1).toUpperCase() + e.pathNames[i].substr(1);
        }
        SWFAddress.setTitle(title);
    }
    
    public function delegate(target:Object, handler:Function):Function {
        var f = function() {
            var context:Function = arguments.callee;
            var args:Array = arguments.concat(context.initial);
            return context.handler.apply(context.target, args);
        }
        f.target = target;
        f.handler = handler;
        f.initial = arguments.slice(2);
        return f;
    }
    
    public static function drawLink(mc:MovieClip, label:String):MovieClip {

        var depth = mc.getNextHighestDepth();
        var link_mc = mc.createEmptyMovieClip('link' + depth + '_mc', depth);

        var label_fmt:TextFormat = new TextFormat();
        label_fmt.font = 'Arial';
        label_fmt.underline = true;
        label_fmt.size = 12;
        
        var label_txt = link_mc.createTextField('label_txt', 0, 0, 0, 60, 20);
        label_txt.autoSize = 'left';
        label_txt.selectable = false;            
        label_txt.antiAliasType = 'advanced';
        label_txt.setNewTextFormat(label_fmt);
        label_txt.html = true;
        label_txt.htmlText = label;
        label_txt.textColor = 0x000000;

        return link_mc;       
    }
    
    public static function drawButton(mc:MovieClip, label:String):MovieClip {

        var depth = mc.getNextHighestDepth();
        var button_mc = mc.createEmptyMovieClip('button' + depth + '_mc', depth);

        var label_fmt:TextFormat = new TextFormat();
        label_fmt.font = 'Arial';
        label_fmt.bold = true;
        label_fmt.size = 14;
        
        var label_txt = button_mc.createTextField('label_txt', 0, 10, 0, 60, 20);
        label_txt.autoSize = 'left';
        label_txt.selectable = false;            
        label_txt.antiAliasType = 'advanced';
        label_txt.setNewTextFormat(label_fmt);
        label_txt.text = label;
        label_txt.textColor = 0xFFFFFF;
       
        button_mc.beginFill(0x000000);
        drawRect(button_mc, 0, 0, label_txt._width + 20, label_txt._height);
        button_mc.endFill();
        
        return button_mc;       
    }
    
    public static function drawRect(mc:MovieClip, x:Number, y:Number, w:Number, h:Number):Void {
        mc.moveTo(x, y);
        mc.lineTo(x + w, y);
        mc.lineTo(x + w, y + h);
        mc.lineTo(x, y + h);
        mc.lineTo(x, y);
    }

    public static function main():Void {
        _root.onEnterFrame = function() {
            var bl:Number = this.getBytesLoaded();
            var bt:Number = this.getBytesTotal();
            if (bl && bt && bl == bt) {
                var website:Website = new Website(_root);
                delete this.onEnterFrame;
            }
        }        
    }
}