package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxBackdrop;

class CoolBG extends FlxBackdrop
{
	var colorArray:Array<Int> = [0xFF00febf, 0xFF9f469d, 0xFFfb95c7, 0xFFed208f, 0xFF3e4698, 0xFFfee612];
	var curColor:Int;
	var nextColor:Int;

	public function new(?startingColor:Int = 0xFF00febf, ?scrollSpeed:Int = 40, ?transTime:Int = 10)
	{
		super(Paths.image("tacoNeon"));

		curColor = startingColor;
		velocity.set(scrollSpeed, scrollSpeed);
		useScaleHack = false;
		antialiasing = ClientPrefs.globalAntialiasing;

		changeColor();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function changeColor(?tween:FlxTween = null) {
		if (tween != null) tween.cancel(); // just so you can use changeColor without a tween
		if (nextColor != 0) curColor = nextColor;
		nextColor = rollColor();
		FlxTween.color(this, 10, curColor, nextColor, { onComplete: changeColor });
	}

	function rollColor():Int {
		var color:Int = colorArray[Math.floor(Math.random()*(colorArray.length))];
		if (color == curColor) return rollColor();
		else return color;
	}
}
