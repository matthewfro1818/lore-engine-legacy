package;

import flixel.FlxSprite;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';

	public function new(char:String = 'bf', isPlayer:Bool = false, ?hasVictory:Bool = false)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char, hasVictory);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	public function swapOldIcon() {
		if(isOldIcon = !isOldIcon) changeIcon('bf-old');
		else changeIcon('bf');
	}

	private var actualDimensions:Array<Int> = [150, 150];
	public function changeIcon(char:String, ?hasVictory:Bool = false) {
		if(this.char != char) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			var file:Dynamic = Paths.image(name);

			loadGraphic(file); //Load stupidly first for getting the file size
			loadGraphic(file, true, Math.floor(hasVictory ? width / 3 : width / 2), Math.floor(height)); //Then load it fr

			var existingScale = [scale.x, scale.y];
			scale.set(1,1);
			actualDimensions = [Math.floor(width), Math.floor(height)];
			scale.set(existingScale[0], existingScale[1]);

			updateHitbox();

			animation.add(char, (hasVictory ? [0, 1, 2] : [0, 1]), 0, false, isPlayer);
			animation.play(char);
			this.char = char;

			antialiasing = ClientPrefs.globalAntialiasing;
			if(char.endsWith('-pixel')) {
				antialiasing = false;
			}
		}
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = (width - actualDimensions[0]) / 2;
		offset.y = (height - actualDimensions[1]) / 2;
	}

	public function getCharacter():String {
		return char;
	}
}
