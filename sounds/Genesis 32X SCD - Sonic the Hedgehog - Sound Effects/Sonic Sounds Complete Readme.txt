NOTE: This readme is in regards to the entire collection! This pack is just one of the game rips out of the entire archive. These were separated for download convenience. This short paragraph is the only change to the readme. Get the full collection here:
http://www.mediafire.com/?ip32j2dnsge1h4w

These sound rips have been brought to you by Mr Lange. Credit is not at all required, but would be appreciated.
I have come across various sound rips from the original Sonic games, all of which are either terrible quality (horrible sample rate) or have at least one glaring flaw.
In my frustration, I decided to rip them all myself. I will say with confidence I've done a much better job.
Aside from poor sample rate, what I notice is how others ignore the emulator they use and its settings. Usually ignored:
The internal sample rate. Should be 44100.
Soften filter. Should be OFF.
YM2612 HQ Emulation. Should be ON.
These are the ideal settings. Special options vary among emulators, which makes it worse when sounds are ripped with an emulator with more junk food features than quality design.

Games Ripped:
Sonic 1
Sonic 2
Sonic 3 and Knuckles
Sonic 3D Blast
Sonic Spinball
Sonic CD
Knuckles Chaotix
Sonic Triple Trouble

For these rips I used Gens Rerecording 11b, which seems to be a very mature version of Gens, and also allows me to set every shortcut key making these tasks a little easier. Testing sounds in comparison with other emulators, this one appears to be closest to perfection.
However, I used Kega Fusion for Knuckles Chaotix, which as far as I know, is the only emulator which correctly emulates 32x sound. In comparison, Kega Fusion's 32x sound emulation was far superior to Gens 11b, however every Genesis game sounded identical between the two emulators. Thus for all of its other features, Gens 11b won out for every other game.
As sort of a bonus, I decided to rip Sonic Triple Trouble, since it has a convenient sound test, and I have yet to find sound rips of any of the Game Gear/Master System Sonic games. I think the sounds are mostly the same between these games anyway. For this game, I used Kega Fusion, because it directly supports GG/SMS games, has accurate sound emulation, and wav dumping.
I didn't do very thorough research so I could be off with my decision to use these emulators. If anyone knows better than me, please tell me what would be the best method. I will gladly do all of this again in favor of more accurate, better quality results.

These rips are very unbiased. I did not name any of the sound files by concept (jump, ring, spindash. etc), just by their numbers in the games' sound tests. The file names are short, abbreviations of the game name followed by the sound number. If you want to name them, go ahead.
I also did not make any attempts to remove doubles. Every sound effect possible is there. There are quite a few doubles though, between different games and sometimes even the same game will contain doubles. It would take too long to try and weed out all the doubles, and I would not want to compromise the integrity of these rips. If you want to do this, it too is the end user's responsibility. Also, there is a possibility that there are tiny variations in some of the doubles across games, given differences in sound engines and what not. I do not know for sure.
One exception though, I only ripped the few sounds from Sonic 3D Blast that I was sure are unique to that game. There's dozens of sounds which appear to be directly copied from Sonic 3 and Knuckles, even in the same order, so I didn't bother. If there are any other sounds unique to 3D Blast that I overlooked, let me know.
I should also mention that every ring sound is always stereo left or right. The normal ring sounds alternate, but some of the doubles are fixed on one side. For every ring sound, I manually copied the one used channel to the silent one so they would play on both sides.

You may notice the "sustain" folder in the S3&K rips. This is because there's a section of sounds from BC to DB that play differently depending on repetition. Playing once, they are short, some of which on release will decay in volume. If they are played repeatedly very quickly, they continue playing a special looped version. Some of these are simple loops, while others are long morphing sounds. I had no technical method for determining how long to sustain these sounds, I just used intuition, hoping to capture the loops a few times over for each sound along with any nonlooping morphing over time, until the sound showed no changes following a certain point. In other words, the normal rips are "one shot" versions while the sustain folder has the extended sustained/looping versions. I did not attempt to add any markers or loop points, so if needed, it will be up to the end user.

The Sonic Spinball rip was a little sketchier than the others, and some sounds required a little manual editing. I did listen for and ignore doubles for this game's rip. There were a lot of sounds that have permanent loops, so I used careful judgement on how they should be trimmed in a way that preserves slow modulations over time, as well as ensuring that they are loopable. There are a couple sounds that had minor variations with each play, such as the cluck sound (51, 52, 53), so I ripped these multiple times and singled out the most prominent variations. Sound 60 is a long version of the steam launcher gimmick in Lava Powerhouse. In the game, the sound actually stops after a few repetitions and is followed by another sound, which is 63 in this rip. Therefore, I ripped and studied the original sound, and manually combined 60 and 63 exactly as it is in the game, which is 60b. Its possible the game variates it slightly, but my edit should be the best possible average. Also, the spindash sound, 65, loops in the game, rising in pitch with every iteration. The custom sound test I used does not do this, only playing the sound once. For this, I did a manual vgm rip and rendered the complete version of the sound, 65b. Unfortunately, in_vgm plugin does not support HQ 2612 emulation, so the sound is not as accurate as it should be (compare 65 to 65b, you can especially hear the problem as the sound distorts with high frequencies). Its a very close approximation though. It seems in_vgm 4.0 supports HQ sound, but its currently in alpha and does not support channel muting, so when that is done I will add the proper sound. I should also mention that sound 64, the plane sound that plays during the Sega logo, actually loops forever in the sound test, but I trimmed it to exactly the point it stops in the game.

The Sonic Misc folder has common jingles from the games. While you could just convert them from an existing vgm soundtrack, these at least have the advantage of HQ YM2612 emulation, something in_vgm does not seem to have. I gave these samples proper names. The jingles between Sonic 1 and 2 are pretty much the same, albeit tiny differences. I left them in together for the sake of completeness. Chaotix's "Decision" and "From Party to Party" are infinitely looped by the game, so I attempted to trim these manually to their approximate loop points to my best ability. I may be off a few samples, but I preserved the illusion. I feel I must warn about this as it is the most biased edit in this project. Also, I did not rip Sonic Triple Trouble's jingles, as I felt it would be unfair to rip those and not every GG/SMS game's jingles which are all different. To do this would take too much time, especially considering not every game has a sound test. They are available in emulated soundtracks on other sites, such as Zophar's Domain, and easy to convert.
Note, the jingles for collecting all emeralds and gaining a continue are part of the sound effects, and not included in the jingles folder.
Another note, I did not separate Sonic Spinball's jingles from its sounds folder. It was too difficult to determine what does and doesn't count as a jingle since the game has many different kinds.

Every sound is:
wav format
44,100 hz
Stereo
16 bit

Every sound was batch processed by Sound Forge, using the auto trim plugin. The settings were careful about only cutting silence and leaving 1 ms of time before and after every sample.
Kega ripped sounds a bit quieter. Knuckles Chaotix is thus a bit quieter than the other games. Triple Trouble was especially quiet, so every sample from that game was given a volume increase of a few dbs during the batch process. I did not modify the volume of Chaotix's sounds though, because some of the sounds are loud enough that they might clip. Anything less wouldn't be worth it. I will not normalize the sounds individually because the volume differences between the sounds is important and also part of the integrity of this ripping project. Otherwise I might as well normalize the volume of every sound from every game. This would be destructive. The end user can opt to do that on their own.

Updates:
-Jan 25, 2012
Initial release.
-Feb 06, 2012
I'm happy to report that I was finally able to properly rip Sonic Spinball's sounds, thanks to GenesisFan64 who shared a custom hack that runs a raw sound test. Using this, I was able to accurately rip the game's sounds just as I have with every other game, thus unofficially completing this project (not every possible thing is done yet, but basically this is completed). See above for notes on the Sonic Spinball rip.
I also fixed one or two tiny issues I missed, as well as a big mistake I made. I accidentally left behind repeats in a couple of the jingles that I was going to examine, and I forgot to do that and edit them, so I took care of that.

Anyway, it goes without saying these sounds are for any purpose. Hopefully fan games will sound less shitty from now on. Have fun.
I would like any feedback. Did I miss anything? Did I do anything wrong or suboptimally?
Again, credit is appreciated but not necessary.

Thanks to GenesisFan64 for helping rip Sonic Spinball's sounds by way of creating a custom sound test for the game's sounds. Additional thanks to MarkeyJester for the suggestion, and lukeusher123 for his original work on the custom sound test.


Mr Lange

My name on Sonic Retro and Sonic Fan Games HQ is also Mr Lange.
shortfactor@hotmail.com
Youtube: shortfactor
Newgrounds: Short-Factor