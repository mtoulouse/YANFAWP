Welcome to "Your Alliance's Nation, Foreign Aid, and War Parser (YANFAWP).

I used to play an online browser nation simulation game named Cyber Nations (CN). Still technically have a nation on there, but I don't pay attention to it. Anyways, this is a CN data gathering and parsing software package I created a year or two ago as a hobby, mostly to practice using regular expressions. It actually reads the html source and parses it for information, which is an awful way to do it and should horrify any professional coder, but it worked and I managed to generate some fun graphs and charts and utilities to help out my CN alliance, the "Goon Order of Oppression, Negligence, and Sadism" (GOONS).

My favorite use of YANFAWP was to automatically generate PM lists to message people. Find the people in your alliance who are using 0 or 1 nation aid slots when they could be using 5, create a list that you can just paste right into the messaging CC: field, and send out a mass PM.

Here's the original README below:

-----
YANFAWP is a general-purpose data-parsing program, focused on analyzing and assessing your own alliance in depth. It's not really for world-wide statistics.

There are three stages to using YANFAWP:

1) Gathering the html source from CN.
2) Parsing the gathered source into usable data.
3) Manipulating the data into useful forms.

1 and 2 are pretty set in stone, but the general nature of the data gathered means that if you know MATLAB you can think up myriad new ways to use it if you know a little programming.

-Initial Setup-

1) First, you need the requisite programs, iMacros for Firefox and MATLAB. I use version 2008a. If something drastically changed since then and the program doesn't work now, let me know.

Note: I also suggest Adblock. The advertisements can sometime do funky things to the parser.

2) Copy the contents of the "MATLAB CN Tools" folder to whatever location you want. Note where this working directory is. Example: "C:\Users\User Name\Desktop\CNTools\"

3) Copy the contents of the "Firefox Macros" folder to iMacros' working directory. It's probably something like "C:\Users\User Name\Documents\iMacros\Macros", but just look for it.

4) Open up MATLAB, enter the command 

addpath('your working directory')

In the example, it would be something like 

addpath('C:\Users\User Name\Desktop\CNTools\')

5) Open up iMacros, and edit the three macros (aid, names, war) to point to the working directory\AAsources. Example: 

SAVEAS TYPE=HTM FOLDER=C:\Users\UserName\Desktop\YF\MATLAB<SP>CN<SP>Tools\AAsources FILE={{!EXTRACT}}<SP>{{!NOW:yyyymmdd}}T{{!NOW:hhnn}}<SP>aidsource<SP>{{!LOOP}}

Change the "FOLDER=" field to point to the AAsources directory within the chosen working directory. Use <SP> instead of spaces, it doesn't handle that too well.

6) Also, just in case, edit your profile in CN to allow 40 nations per page. You probably already have this, but it's less hassle for the gathering task.

-Gathering the Source-

There are three locations from which YANFAWP can gather data: "Alliance Rankings", "Search Foreign Aid", and "Search Wars". They can all be accessed from the alliance statistics screen or your nation's AA field. Each uses a very slightly different macro: "CNdatamining-aid.iim","CNdatamining-names.iim","CNdatamining-wars.iim". I think you can figure out what matches what.

1) Open a window for each type of data to gather. If you want nation listings, aid rankings, and war listings, do it in separate windows.

2) For each window, open the tabs with your desired data. If you have 110 members, you're opening three tabs to gather the nation listings. Remember the number of tabs you've opened.

Note: It is important that you MANUALLY open each tab. It's against CN Terms of Service to automate any further; it might put a strain on their awful, poorly maintained servers if you made the macro also automatically access a bunch of pages.

3) Run the corresponding macro using "Play Loop". Have the number go from 1 to whatever number of tabs there are.

4) There should now be a matching number of htm files sitting in your AAsources directory. The name will be something like "AAname datenumber aidsource 2.htm".

-Parsing the data-
Open up MATLAB. Make sure the current directory matches your working directory. Enter something like cd('C:\Users\<username>\Desktop\CN Tool Pack') if you're not sure. You can also do it via the "Current Directory" menu up top.

Here's an example set of commands:

AA = 'Goon Order of Oppression Negligence and Sadism';
GNN = CreateNameList(AA);
GNA = CreateAidList(AA);
GNW = CreateWarList(AA);
GNA = RemoveExpired(GNA);
GNW = RemoveExpired(GNW);
CombineLists(GNN,GNA,GNW);

The first line creates the string containing the AA name. The next three are the workhorse programs that parse the data and create arrays of Nation/Aid/War objects (More in the next section). The program will stop to ask you to choose the date of storage, so you can distinguish between current and older data. 

Note: "Date of storage" is essentially when you used the FF macro, in local time, as compared to the "date taken", which is when you opened the web page, in game time.

"RemoveExpired" are functions that trim those lists of any expired entries (Wars older than 7 days, or aid older than 10). CombineLists cross-references the data in each list. A nation might be mentioned on your nation listings and your aid listings, but the aid listing didn't show its information beyond ruler/nation name. This fills in the blanks so that you can, for example, filter out all the entries in your aid list that belong to your AA's nations under 1000 tech and generate a PM list to their aid partners or something like that.

-Using the data-

There are multiple ways to use the data. I suggest you investigate yourself, but here are some major uses I have found:

1) Making PM lists. Generate a forum-formatted (url links, bolded, etc.) list of ruler names, with every 26th entry being a message-sending link, like the little envelopes you can click on the nation rankings. Click the link, copy and paste the next 25 names into the CC field, repeat.

2) Aid slot analysis. Find out who has been using their slots and who hasn't, and make a PM list of the zero-slot guys to harass them. Find out what percentage of your slots are being used. Find out the relative distribution of AAs with which you tech deal.

3) Make nifty plots of your NS/tech distribution, etc. Data visualization is always fun. 

4) Create auditing spreadsheets. MATLAB is able to create .xls files. You can write a spreadsheet with basic info on it and copy/paste that into a google docs, for example.

5) Target Lists. List all the nations in your target AA, their basic stats, whether they are in war/peace mode, their open off/def war slots, and export it all to an excel file which you can then copy/paste into google spreadsheets and distribute  the link to your AA. If you want, you can grab your own alliance's info too and determine how many open offense slots you have in war range for each target! I haven't made that function yet, but it's very possible, and I'll make it if people want it.

There are a couple of files in the pack which are mostly demo platforms for various snippets of code: CNscripts.m, makeplots.m, and MakeSpreadsheets.m. Feel free to test it out. Remember, F9 evaluates only your highlighted code! There are also some fully-completed tools lying around in there.

Seriously, though, most of the code is commented. I suggest opening them all up and at least reading the opening comments.

-What data is taken?-

I encourage people to make their own programs to utilize the data, so I'm just mentioning what exactly is gathered and how it's stored. I used an object-oriented paradigm, so Java dudes may pick it up quickly.

There are three classes: Nation, Aid, and War. Listing the properties/fields for each below ("double" is a number, btw)

Nation class:

RulerName % string
NationName % string
Alliance % string
Team % string
Mode % double (1 = WAR)
ID % double
Seniority % double
NS % double
Tech % double
Infra % double
Nukes = 0; % double
StatDateTaken % date data was gathered
LastActivity % date
AidsList % array of Aid objects
WarsList % array of War objects

Aid class:

StatDateTaken % date data was gathered
DateAided % date of aid
Amount % structure w/ Money, Tech, Soldier fields
Memo % string
Sender % Nation object
Receiver % Nation object
Status % pending, expired, etc.

War class:

StatDateTaken % date data was gathered
DateDeclared % date
Memo % string
Attacker % Nation object
Defender % Nation object
Status % fighting, peaced, etc.


-Example commands to access info-

Say you have an array of Nation objects named NL containing all your alliance members. 

"NL(1)" (minus quotes) gives the first entry in the list. "NL(1).RulerName" would give you their ruler name. "NL(1).AidsList" gives an array of Aid objects, each of which he is involved in. "NL(1).AidsList(1).Amount.Money" would give the amount of $$ involved in the transaction. NL(1:20) would give you a shortened list with just the first twenty entries.

Say you want a list of all the ruler names on your aid list. Just entering NL.RulerName would not give you an orderly list, but instead treat the request as 100 sequential commands. "ans = ruler1" "ans = ruler2" and so on. Not useful.

Instead, use the PropertyArray function. "RL = PropertyArray(NL,'RulerName')", and you now have an orderly list of strings named RL. 