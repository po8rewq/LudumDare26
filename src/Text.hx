package ;

import flash.text.TextFieldAutoSize;
import flash.display.Sprite;
import flash.text.TextFormat;
import flash.text.AntiAliasType;
import flash.text.TextField;

class Text extends Sprite
{
    var _textfield : TextField;
    var _format : TextFormat;

    public function new(pText: String, ?pSize: Int = 12, ?pColor: UInt = 0x000000)
    {
        super();

        _format = new TextFormat();
     //   _format.font = "Punk";
        _format.color = pColor;
        _format.size = pSize;

        _textfield = new TextField();
        _textfield.multiline = true;
    //    _textfield.embedFonts = true;
        _textfield.antiAliasType = AntiAliasType.ADVANCED;
        _textfield.autoSize = TextFieldAutoSize.LEFT;

        _textfield.defaultTextFormat = _format;
        _textfield.text = pText;
        addChild(_textfield);
    }

    public function setText(pStr: String)
    {
        _textfield.text = pStr;
    }

    public function destroy()
    {
        removeChild(_textfield);
        _textfield = null;
        _format = null;
    }
}

// class Punk extends flash.text.Font{}