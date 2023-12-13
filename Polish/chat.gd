extends Sprite2D

var actionframe = 0
var nextmsgframe = 20
var latestchatter := ""
var latestmessage := ""

var currentchat = []
var maxchats = 30
var minimumlength := 1
var minimumlength_max = 40 #yeah this is confusing


func _ready():
	pass 
	generatemsg(maxchats)

	

func _process(delta):
	
	actionframe+=1
	
	if actionframe >= nextmsgframe:
		generatemsg()
		actionframe = 0
		nextmsgframe = minimumlength + (randi() % int(minimumlength * 2.5))
		var rng = randi() % 2
		if rng == 0 and minimumlength < minimumlength_max:
			minimumlength +=1
		rendertext()


func generatemsg(times:int=1):
	for x in times:
		var norepeats = false
		while norepeats == false:
			
			var chosenchatter = chatters[randi() % len(chatters)]
			var chosenmessage = chatmessages[randi() % len(chatmessages)]
			
			if not (chosenchatter == latestchatter or chosenmessage == latestmessage):
			
				norepeats = true
				latestchatter = chosenchatter
				latestmessage = chosenmessage
				currentchat.append(chosenchatter + ":  " + chosenmessage)
				if len(currentchat) > maxchats:
					currentchat.pop_at(0)
			

			

func rendertext():
	$Label.text = ""
	for x in currentchat:
		$Label.text = $Label.text +  "\n" + x



var chatters:Array[String] = [
	"bofa","mike melty","look kanshire","ana aloet", "deez",
	"dicktaker", "john manden", "mom bedder 1999", "plastic-eater69",
	"Mika's Roommate", "Mika's Armpits", "vtuber clip channel #5858214",
	"terrible person", "proletarian nightmare", "i fuck like i fly- economy",
	"person with mysta pfp", "Ghost Blade, Punisher Of The Ancient Sins",
	"medium", "larger than a coke", "the second chatter", "milfs make me breathe",
	"bark bark im a dog", "babypunter", "jadedmyon", #this one is the stupidest
	"evil", "live hard cum harder", "normal human", "fellow american",
	"Sandwich Maker Fan", "call an ambulance im gay", "NFS truster", 
	"fujoshi slayer", "NorthernLion", "kebab spinner", "SS Gyatt",
	"politics understander", "user", "say ara ara", "honk if thatcher's dead",
	"let's find it", "pussy venturer", "talented semen retentionist",
	"talented semen contortionist", "i am good at bonking", #actual thing JSH said
	"John Chatter", "THEY CANCELLED THE COPE CAGE", #im sorry
	"[USER WAS MILKED FOR THIS POST]", "say gex",
	"NobleNoisii", "Eating Mike Tyson's Ass", "Sean Ramsey", #actual people
	
	
	
]
var chatmessages:Array[String] = [
"LMAO","damn","L rip bozo","LUL", "LMAAAOOOO", "fucking what", "WHY", "?????", "LMAAOOO",
"rip bozo", "L", "rip", 
"hey guys im new here, is this the first video game she ever played?",
"mika ur muted",
"muted","muted",
"still muted",
"MUTED",
"STILL MUTED",
"MIKA UR MUTED",
"muted", "muted", "muted", "muted", "muted", "muted", "muted", "muted", 
"MIKA YOU ARE MUTED",
"mika stop playing this pandering crap and go back to house cleaner 2099",
"can we go back to house flipper instead",
"this is too much for you mika go back to house flipper",
"mika I got fired from my job because I was listening to your asmr at work. I cannot be a pastor any longer its all your fault",
"i stuck my wee nor in trhe ceeinling fan",
"why did you do that",
"end this suffering",
"why is she this bad at this",
"gugu gaga ass gameplay",
"mika check your doorstopper",
"is she still pooping",
"this game isnt even difficult. I have the speedrun world record btw",
"mika are you really so starved for content that youre making your own fans create it for you",
"is mimka preganta??",
"hi staff san",
"this game is trying way too hard to be meta. cringe.",
"mika please theres a 9 button",
"i swear to god use the 9 button",
"SPAM 9 PLEASE I WANT TO GO TO BED",
"inb4 ten hour stream",
"chat dont make fun of her shes dyslexic its hard for her to press keyboard keys correctly",
"fuck",
"ITS BEEN 17 YEARS",
"why is she this bad at games",
"oml",
"omg",
"hi mika",
"I must avenge Mario.",
"british boyfriend is just like me frrrrrr",
"whoever wrote this game really hates you lmao",
"what you should have done instead is a diagonal dash slideoff into forward dash broom cancel smhhhhhh",
"we could have had a 15 hour zatsu instead",
"mika I will literally donate 100 dollars for you to stop playing",
"It's okay Mika! You'll get 'em next time!",
"the children never asked for this",
"i napped for an hour and woke up and shes still on this part",
"waduh moment", "waduh",
"mika late?",
"you're late and muted",
"where are the boobs",
"mika you forgot the banana in level 2",
]
