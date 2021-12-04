package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = 1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];

	private static var creditsStuff:Array<Dynamic> = [ //Name - Icon name - Description - Link - BG Color
		["Taco Bell Tuesday"],
		//["Music"],
		["HugeNate", 				"nate", 					"All Playable Music, Charting, Director, Writer", 	"https://twitter.com/HugeNate_", 0xFF1AFCD4],
		["Mind Of The Eye", "mote", 					"Main Menu music", 																	"https://twitter.com/MindoftheEye1", 0xFFDADADA],
		["Coquers",					"coquers", 				"Green Flames", 																		"https://twitter.com/Coquers1", 0xFF4F5662],
		["Jorclai",					"jorclai", 				"Pause / Game Over music",													"https://twitter.com/OfficialJorclai", 0xFFA51F38],
		//["Art"],
		["ImBurger", 				"burger", 				"Nate and ian sprites, menu BG, health icons",			"https://twitter.com/MBorgor", 0xFF2E46C7],
		["SajiArts", 				"saji", 					"Logo Art and UI design, Stage BG Art, Cameos",			"https://twitter.com/sajiarts", 0xFFE43753],
		["KaosKurve", 			"kaoskurve",			"Stage BG Art", 																		"https://twitter.com/KaoskurveA", 0xFFF9A32B],
		["Biohazard_Boi", 			"biohazard",			"BG Cameos", 																		"https://twitter.com/biohazard_boi", 0xFFF9A32B],
		["Box in the Jack", 			"boxinjack",			"BG Cameos", 																		"https://twitter.com/BoxintheJack3", 0xFFF9A32B],
		["Flan The Man", 		"flan", 							"Dialogue sprites, playable Nate stuff",						"https://twitter.com/F14nTh3M4n", 0xFF4D6DA9],
		["JoeyAnimations",	"joenuts", 					"Nate Alt Animations",															"https://twitter.com/joey_animations", 0xFF8797d8],
		//["Code"],
		["Munkyfr",				 	"munky", 					"Code", 																						"https://munkyfr.github.io/", 0xFFFF9048],
		["MadBear422", 			"madbear", 				"Code Again", 																			"https://youtube.com/channel/UCuUWs5LR42EaSwtI_IqxO-w", 0xFFFF0000],
		["CanadianGoose", 	"goose",	 				"Code Again Again", 																"https://twitter.com/Goose1881", 0xFFFFB800],
		["CrystalSlime", 		"crystal", 				"Code Again Again Again",														"https://www.youtube.com/c/CrystalSlime_TheCoolest/", 0xFF36ebff],
		//["Chart"],
		["Chromaatical", 		"chromatical", 		"Charted first song", 															"https://twitter.com/chromaatical", 0xFFBE5252], // STILL NEED TO ADD OTHER CHARTERS
		["Niffirg", 		"niffirg", 		"Charted third song, Green Flames", 															"https://twitter.com/n1ffirg", 0xFFD22E73],
		["Virus", 		"virus", 		"Easy and normal charts, Taco Battle", 															"https://twitter.com/Glitchy2260", 0xFF82CD49],
		//["Special Thanks"],
		["NonsenseHumor", 	"nonsense", 			"Nate Chromatic Scale",															"https://twitter.com/NonsenseNH", 0xFF74e6ff],
		["TheMistake", 			"mistake", 				"Trailer",																					"https://twitter.com/themistakeyt", 0xFF765a48],
		["Racckoon", 				"racckoon", 			"Made the logo move",																"https://twitter.com/GirlWaluigi", 0xFFdd65c6],

		['Psych Engine Team'],
		['Shadow Mario',		'shadowmario',		'Main Programmer of Psych Engine',					'https://twitter.com/Shadow_Mario_',	0xFFFFDD33],
		['RiverOaken',			'riveroaken',		'Main Artist/Animator of Psych Engine',				'https://twitter.com/river_oaken',		0xFFC30085],
		[''],
		['Engine Contributors'],
		['shubs',				'shubs',			'New Input System Programmer',						'https://twitter.com/yoshubs',			0xFF4494E6],
		['PolybiusProxy',		'polybiusproxy',	'.MP4 Video Loader Extension',						'https://twitter.com/polybiusproxy',	0xFFE01F32],
		['gedehari',			'gedehari',			'Chart Editor\'s Sound Waveform base',				'https://twitter.com/gedehari',			0xFFFF9300],
		['Keoiki',				'keoiki',			'Note Splash Animations',															'https://twitter.com/Keoiki_',			0xFFFFFFFF],
		['bubba',				'bubba',		'Guest Composer for "Hot Dilf"',	'https://www.youtube.com/channel/UCxQTnLmv0OAS63yzk9pVfaw',	0xFF61536A],
		[''],
		["Funkin' Crew"],
		['ninjamuffin99',		'ninjamuffin99',	"Programmer of Friday Night Funkin'",				'https://twitter.com/ninja_muffin99',	0xFFF73838],
		['PhantomArcade',		'phantomarcade',	"Animator of Friday Night Funkin'",					'https://twitter.com/PhantomArcade3K',	0xFFFFBB1B],
		['evilsk8r',			'evilsk8r',			"Artist of Friday Night Funkin'",					'https://twitter.com/evilsk8r',			0xFF53E52C],
		['kawaisprite',			'kawaisprite',		"Composer of Friday Night Funkin'",					'https://twitter.com/kawaisprite',		0xFF6475F3]
	];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		var dumbArray:Array<String> = ["music", "art", "code", "charting", "special thanks"];

		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var bold:Bool = !isSelectable;
			/*
			if (!isSelectable) {
				bold = dumbArray.contains(creditsStuff[i][0].toLowerCase());
			}
			*/
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], bold, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			if(isSelectable) {
				optionText.x -= 70;
			}
			optionText.forceX = optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable) {
				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;

				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
			}
		}

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		bg.color = creditsStuff[curSelected][4];
		intendedColor = bg.color;
		changeSelection();
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
		if(controls.ACCEPT) {
			CoolUtil.browserLoad(creditsStuff[curSelected][3]);
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int = creditsStuff[curSelected][4];

		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}
		descText.text = creditsStuff[curSelected][2];
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
