class Website {

    private var _content:Array;
    private var _mc:MovieClip;
    
    public function Website(mc:MovieClip) {

        _mc = mc;
        _content = [
            'Català', 
            'Česky', 
            'Dansk', 
            'Deutsch', 
            'English', 
            'Español', 
            'Esperanto', 
            'Français', 
            'Bahasa Indonesia', 
            'Italiano', 
            'Magyar', 
            'Nederlands', 
            '日本語', 
            'Norsk (bokmål)', 
            'Polski', 
            'Português', 
            'Русский', 
            'Română', 
            'Slovenčina', 
            'Suomi', 
            'Svenska', 
            'Türkçe', 
            'Українська', 
            'Volapük', 
            '中文',
            'Afrikaans', 
            'العربية', 
            'Aragonés', 
            'Asturianu', 
            'Kreyòl Ayisyen', 
            'Azərbaycan / آذربايجان ديلی', 
            'Беларуская (Акадэмічная ·Тарашкевiца)', 
            'Bosanski', 
            'Brezhoneg', 
            'Български', 
            'Чăваш', 
            'Cymraeg', 
            'Eesti', 
            'Ελληνικά', 
            'Euskara', 
            'فارسی', 
            'Frysk', 
            'Galego', 
            '한국어', 
            'Hrvatski', 
            'Ido', 
            'Íslenska', 
            'עברית', 
            'Basa Jawa', 
            'Kurdî / كوردی', 
            'Latina', 
            'Latviešu', 
            'Lëtzebuergesch', 
            'Lietuvių', 
            'Македонски', 
            'Bahasa Melayu', 
            'Norsk (nynorsk)', 
            'Nnapulitano', 
            'Occitan', 
            'Piemontèis', 
            'Plattdüütsch', 
            'Ripoarisch', 
            'Runa Simi', 
            'Shqip', 
            'Sicilianu', 
            'Simple English', 
            'Sinugboanon', 
            'Slovenščina', 
            'Српски', 
            'Srpskohrvatski / Српскохрватски', 
            'Basa Sunda', 'Kiswahili', 
            'Tagalog', 
            'ไทย', 
            'Tiếng Việt', 
            'اردو', 
            'Walon', 
            '粵語', 
            'Žemaitėška'            
        ];
        
        Stage.scaleMode = 'noScale';
        Stage.align = 'T';
        
        var title_fmt:TextFormat = new TextFormat();
        title_fmt.font = 'Arial';
        title_fmt.bold = true;
        title_fmt.size = 32;
        title_fmt.color = 0x666666;
        title_fmt.letterSpacing = -2.5;
        
        _mc.title_txt = _mc.createTextField('title_txt', _mc.getNextHighestDepth(), 40, 20, 400, 40);
        _mc.title_txt.setNewTextFormat(title_fmt);
        _mc.title_txt.antiAliasType = 'advanced';
        _mc.title_txt.html = true;
        _mc.title_txt.htmlText = '<a href="asfunction:SWFAddress.setValue,/">SWFAddress Website</a>';

        var content_fmt:TextFormat = new TextFormat();
        content_fmt.font = 'Arial';
        content_fmt.leading = 10;
        content_fmt.size = 14;
        
        _mc.content_txt = _mc.createTextField('content_txt', _mc.getNextHighestDepth(), 40, 100, 402, 480);
        _mc.content_txt.setNewTextFormat(content_fmt);
        _mc.content_txt.antiAliasType = 'advanced';
        _mc.content_txt.html = true;
        _mc.content_txt.multiline = true;
        _mc.content_txt.wordWrap = true;
        
        SWFAddress.addEventListener(SWFAddressEvent.CHANGE, delegate(this, handleChange));
    }
    
    public function handleChange(e:SWFAddressEvent):Void {
    
        var content:Array = [];
        var value:String = e.value.substr(1);
        
        for (var i:Number = 0, l:Number = _content.length; i < l; i++) {
            content[i] = '<a href="asfunction:SWFAddress.setValue,' + _content[i] + '">' + 
                (value == _content[i] ? '<font color="#CC0000">' + _content[i] + '</font>' : _content[i]) + '</a>';
        }
        _mc.content_txt.htmlText = content.join(' · ');

        SWFAddress.setTitle('SWFAddress Website' + (value ? ' | ' + value : ''));
    }
    
    public function delegate(target:Object, handler:Function):Function {
    
        var f:Function = function() {
            var context:Function = arguments.callee;
            var args:Array = arguments.concat(context.initial);
            return context.handler.apply(context.target, args);
        }
        f.target = target;
        f.handler = handler;
        f.initial = arguments.slice(2);
        return f;
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