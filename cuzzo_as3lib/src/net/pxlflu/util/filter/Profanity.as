﻿package com.atmospherebbdo.util.filter{

public class Profanity{
	public static var PROFANITY:Array = ['wtf','wop','whore','whoar','wetback','wank','wanker','wang',
        'vagina','vag','vaj','veejay',
        'twaty','twat','titty','titties','tits','testicles','testes','teets','tit','titfuck','teats',
		'spunk','spic','snatch','snatchface','smut','sluts','slut','sleaze','slag','shiz','shitty','shittings','shitting','shitters','shitter','shitted','shits','shitings','shiting','shitfull','shited','shit','shithead','shitsmear','shitstain','shit stain','shitface','shitass','shit ass','shitty-ass','shitfuck','shitbucket','scheise','scheisse','scheiss','shemale','sheister','sh!t','scrotum','scrote','scrotal','screw','schlong','strapon','strap on',
        'retard','tard',
        'qweef','queer','queef',
        'poop','pussys','pussy','pussies','pussyfart','pussyfist','pussyhead','pussywhip','pussywhipped','pussy whip','pussylip','pussylips','pusse','prostitute','pricks','prick','poon','poontang','poonany','poonanny','pr0n','pornos','pornography','porno','porn','pissoff','pissing','pissin','pisses','pissers','pisser','pissed','piss','pissface','pissdrinker','piss drinker','pissmouth','pimp','phuq','phuks','phukking','phukked','phuking','phuked','phuk','phuck','phonesex','penis','peen','penishead','penis head','penisface','pecker',
        'orgasms','orgasm','orgasims','orgasim',
        'niggers','nigger','nigga','niggaz',
		'muff','mound','motherfucks','motherfuckings','motherfucking','motherfuckin','motherfuckers','motherfucker','motherfucked','motherfuck','mothafucks','mothafuckings','mothafucking','mothafuckin','mothafuckers','mothafucker','mothafucked','mothafuckaz','mothafuckas','mothafucka','mothafuck','mick','merde','masturbate',
        'lusting','lust','lesbo','lesbian',
        'kunilingus','kums','kumming','kummer','kum','kuksuger','kuk','kraut','kondums','kondum','kock','knob','kike','kawk',
        'jizz','jizm','jiz','jism','jesus h christ', 'jesus fucking christ','jerk-off','jerk','jap','jackoff','jackingoff','jackass','jack-off','jack off',
        'hussy','hotsex','horny','horniest','hore','hooker','honkey','homo','hoer','hell','hardcoresex','hard on','hardon','humpbox','hardon','h4x0r','h0r','hobag','ho bag',
        'goatse','goatsex','guinne','gook','gonads','goddamn','gazongers','gaysex','gay','gaywad','gaytard','gayass','gay ass','gay-ass','gangbangs','gangbanged','gangbang',
        'fellatio','fellate','fellating','fu*k','fuk','fux0r','furburger','fuks','fuk','fucks','fuckme','fuckings','fucking','fuckin','fuckers','fuckface','fuckhead','fuckhole','fuckyou','fucku','fuckfist','fucktard','fuckwad','fuckball','fuckfuck','fucktit','fuct','fuckass','fucknut','fuckhard','fuckstick','fuckle','fuckjuice','fuckslut','fuckslot','fucker','fucked','fuck','fu','foreskin','fistfucks','fistfuckings','fistfucking','fistfuckers','fistfucker','fistfucked','fistfuck','fisting','fister','fingerfucks','fingerfucking','fingerfuckers','fingerfucker','fingerfucked','fingerfuck','fellatio','felatio','feg','feces','fecal','fecalface','fecesface','fecal face','feces face','fcuk','fatso','fatass','farty','farts','fartings','farting','farted','fart','fags','fagots','fagot','faggs','faggot','faggit','fagging','fagget','fag','f.a.g.', 'f.u.c.k.', 'f u c k', 'f*ck','fucky',
        'ejaculation','ejaculatings','ejaculating','ejaculates','ejaculated','ejaculate',
        'dyke','dumbass','douchebag','dong','dipshit','dinks','dink','dildos','dildo','dike','dickhead','dickshit','dicks','dicksuck','dickfuck','dickrag','dickfer','dickfor','dickjuice','dicksauce','dicknut','dickmouth','dicktard','dickface','dickbutt','dickhole','dickvein','dickslot','dickhair','dick hair','damn','damn','dogfuck','dogfucker','dongfuck','donger','dingdong','pigfucker','pig fucker','pedophile','paedophile','paedobear','paedo bear','pedobear','pedo bear','pedorast','molester','child molester','sex offender','rapist','child rapist','rapeface','raper','rapey','childrape','NAMBLA','N.A.M.B.L.A','NMBLA','N.M.B.L.A',
        'cyberfucking','cyberfuckers','cyberfucker','cyberfucked','cyberfuck','cyberfuc','cunt','cunts','cuntsucker','cuntface','cuntburglar','anal cunt','cuntsuck','cunty','cuntwad','cuntface','cuntfart','cuntlicking','cuntlicker','cuntlick','cunt','cunt hair','cunthair','cuntjuice','cuntsauce','cuntslick','cuntrag','cunt rag','cunnilingus','cunillingus','cunilingus','cumshot','cums','cumming','cummer','cum','cumgun','cumwad','cumface','cumsauce','cumsucker','cumsuck','cumtit','cum tits','cumstick','cumslick','crap','cooter','cooch','coochie','coochy','coochface','coochstick','cocksucks','cocksucking','cocksucker','cocksuckers','cocksucked','cock suck','cocks','cock','cockwad','cockface','cockmouth','cockass','cockstroke','cocknut','cockbutt','cockhole','cobia','clits','clit','clitface','clitorus','circle jerk','chink','cawk',
        'boobs','breasts','b00bs','b00b','boner','bonedong','boned','boxmunch','boxmuncher','boxtwat','buttpicker','butthole','butthead','buttfucker','buttfuck','buttface','butthair','butt fucker','buttfist','butt breath','butt','butch','bunghole','bum','bullshit','bull shit','bucketcunt','browntown','browneye','browneye','boner','bonehead','blowjobs','blowjob','blowjob','bitching','bitchin','bitches','bitchers','bitcher','bitch','bestiality','bestial','bellywhacker','beaver','beastility','beastiality','beastial','bastard','balls','ballsack','ballsac',
        'asswipe','asskisser','assfart','assfuck','assholes','asshole','asses','asslick','ass','assboob','asshead','assshit','asstard','asswad','assream','assreamer','assram','asspound','anal explorer','assfist','assfisting']
		}
	};