function make_slides(f) {
  var   slides = {};

/* For Ling245, no need to change the code
 for i0 and consent slides*/
  slides.i0 = slide({
     name : "i0",
     start: function() {
      exp.startT = Date.now();
     }
  });

  slides.consent = slide({
     name : "consent",
     start: function() {
      exp.startT = Date.now();
      $("#consent_2").hide();
      exp.consent_position = 0;
     },
    button : function() {
      if(exp.consent_position == 0) {
         exp.consent_position++;
         $("#consent_1").hide();
         $("#consent_2").show();
      } else {
        exp.go(); //use exp.go() if and only if there is no "present" data.
      }
    }
  });

/*Consult the code in the consent slide if you
  want to break down very long instructions */
  slides.instructions = slide({
    name : "instructions",
    button : function() {
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });

  slides.example = slide({
    name: "example",
    start: function() {
      $(".err").hide();
      $('input[name=exChoice]:checked').prop('checked', false);
    },
    button : function() {
      exp.go(); //use exp.go() if and only if there is no "present" data.
    },
  });

  var dict = { 
              "LongShort 1" : {
                choice2 : "mathematics",
                choice1 : "math",
                neutralQ : "Did Bob introduce himself to me?",
                supportiveQ : "Is Bob bad at algebra?",
                neutral : "Bob introduced himself to me as someone who loved...",
                supportive : "Bob was very bad at algebra, so he hated...",
              },
              "LongShort 10" : {
                choice2 : "rhinoceros",
                choice1 : "rhino",
                neutralQ : "Did Mary see an animal?",
                supportiveQ : "Did Mary go to the zoo?",
                neutral : "Mary marveled at the calm quiet composure of the...",
                supportive : "Mary went to the zoo to see a thick-skinned...",
              },
              "LongShort 11" : {
                choice2 : "chimpanzee",
                choice1 : "chimp",
                neutralQ : "Was Susan comfortable during charades?",
                supportiveQ : "Does Susan dislike the apes at the zoo?",
                neutral : "During a game of charades, Susan was too embarrassed to act like a...",
                supportive : "Susan loves the apes at the zoo, and she even has a favorite...",
              },
              "LongShort 12" : {
                choice2 : "pornography",
                choice1 : "porn",
                neutralQ : "Did Mark disapprove of something?",
                supportiveQ : "Did Mark feel embarrassed to be caught downloading something?",
                neutral : "My brother Mark does not approve of...",
                supportive : "Mark was embarrassed to be caught downloading...",
              },
              "LongShort 13" : {
                choice2 : "limousine",
                choice1 : "limo",
                neutralQ : "Did Paul's father rent something?",
                supportiveQ : "Did Paul go to prom?",
                neutral : "Last month, Paul and his friends rented a...",
                supportive : "For going to the prom, Paul rented a...",
              },
              "LongShort 14" : {
                choice2 : "saxophone",
                choice1 : "sax",
                neutralQ : "Is Tucker innocent of theft?",
                supportiveQ : "Is Tucker in a polka band?",
                neutral : "Last week, Tucker picked a lock and stole a...",
                supportive : "In the jazz band, Tucker almost always plays the...",
              },
              "LongShort 15" : {
                choice2 : "cockroach",
                choice1 : "roach",
                neutralQ : "Did my brother stay in the house all day yesterday?",
                supportiveQ : "Did my brother call the florist?",
                neutral : "Leaving our family's house yesterday, my brother discovered a...",
                supportive : "My brother called the exterminator after he found a...",
              },
              "LongShort 16" : {
                choice2 : "telephone",
                choice1 : "phone",
                neutralQ : "Does John's family have a home?",
                supportiveQ : "Does John avoid answering his mother's calls?",
                neutral : "In every room of John's family home, there is a...",
                supportive : "When John's mother calls, he does not pick up the...",
              },
              "LongShort 17" : {
                choice2 : "referee",
                choice1 : "ref",
                neutralQ : "Does Justin just relax and not work on weekends?",
                supportiveQ : "Did the coach's team score?",
                neutral : "To make extra money on weekends, Justin works as a...",
                supportive : "After the other team scored, the coach argued with the...",
              },
              "LongShort 18" : {
                choice2 : "undergraduate",
                choice1 : "undergrad",
                neutralQ : "Does James still frequently throw baseballs?",
                supportiveQ : "Did James go to Yale?",
                neutral : "James had not thrown a football or baseball since he was an...",
                supportive : "James knows Harvard well since he spent four years there as an...",
              },
              "LongShort 19" : {
                choice2 : "kilogram",
                choice1 : "kilo",
                neutralQ : "Did Florian refuse to tell the others how much to order?",
                supportiveQ : "Is the package green?",
                neutral : "Florian told the others they should order approximately one...",
                supportive : "Florian thought that the brown package weighed approximately one...",
              },
              "LongShort 2" : {
                choice2 : "bicycle",
                choice1 : "bike",
                neutralQ : "Did John buy a new bike?",
                supportiveQ : "Does John commute to work?",
                neutral : "Last week John finally bought himself a new...",
                supportive : "For commuting to work, John got a 10-speed...",
              },
              "LongShort 20" : {
                choice2 : "chemotherapy",
                choice1 : "chemo",
                neutralQ : "Did the man refuse to speak to Lionel?",
                supportiveQ : "Is it true that Lionel was never diagnosed with cancer?",
                neutral : "The man explained to Lionel that no one enjoys having to undergo...",
                supportive : "After being diagnosed with cancer, Lionel had to undergo a course of...",
              },
              "LongShort 21" : {
                choice2 : "television",
                choice1 : "TV",
                neutralQ : "Did John buy a car to celebrate his promotion?",
                supportiveQ : "When John gets home, does he first read a book?",
                neutral : "To celebrate his important promotion, John went out and bought a new...",
                supportive : "When John gets home, he relaxes on the couch and watches his...",
              },
              "LongShort 22" : {
                choice2 : "carbohydrates",
                choice1 : "carbs",
                neutralQ : "Does Gary ignore what he eats?",
                supportiveQ : "Did Gary want to keep eating a lot of bread and cereal?",
                neutral : "Ever since he talked to Lily, Gary has been trying to avoid...",
                supportive : "After realizing he ate too much bread and cereal, Gary cut down on...",
              },
              "LongShort 23" : {
                choice2 : "advertisement",
                choice1 : "ad",
                neutralQ : "Did Bill see a lot of something?",
                supportiveQ : "Did Bill pass a billboard?",
                neutral : "Almost everywhere Bill looked, there seemed to be another...",
                supportive : "Bill drove past the billboard with his company's latest...",
              },
              "LongShort 24" : {
                choice2 : "air conditioning",
                choice1 : "A/C",
                neutralQ : "Did Eric continue putting off making a decision?",
                supportiveQ : "Is Eric's only house in Maine?",
                neutral : "After several years, Eric finally decided that he was going to get...",
                supportive : "When it got really hot, Eric wished his house in Florida had...",
              },
              "LongShort 25" : {
                choice2 : "gasoline",
                choice1 : "gas",
                neutralQ : "Does Susan think something is too expensive?",
                supportiveQ : "Did Susan stop at a Shell station?",
                neutral : "These days, Susan thinks that it costs far too much to buy...",
                supportive : "Susan stopped at the Shell station because her car was low on...",
              },
              "LongShort 26" : {
                choice2 : "United Kingdom",
                choice1 : "U.K.",
                neutralQ : "Does Kevin leave home often?",
                supportiveQ : "Does Kevin hate British culture?",
                neutral : "Although he rarely leaves home, Kevin's favorite place to go is the...",
                supportive : "Although Kevin loves British culture, he has never actually been to the...",
              },
              "LongShort 27" : {
                choice2 : "microphone",
                choice1 : "mic",
                neutralQ : "Did Susan ask the store staff about laptops?",
                supportiveQ : "Did Susan test the mic last?",
                neutral : "Susan asked the store staff several questions about their best...",
                supportive : "Susan made sure the sound system worked, first testing the...",
              },
              "LongShort 28" : {
                choice2 : "laboratory",
                choice1 : "lab",
                neutralQ : "Did Mary want to show Susan a building?",
                supportiveQ : "Did Mary spill chemicals?",
                neutral : "Mary wanted to show Susan the building with her...",
                supportive : "Mary caused a panic by spilling some dangerous chemicals in her...",
              },
              "LongShort 29" : {
                choice2 : "Labrador",
                choice1 : "Lab",
                neutralQ : "Was a tiger the first thing Clay saw at the park?",
                supportiveQ : "Is a Golden Retriever a type of cat?",
                neutral : "The first thing that Clay saw at the park was a...",
                supportive : "Clay knew the dog was either a Golden Retriever or a...",
              },
              "LongShort 3" : {
                choice2 : "examination",
                choice1 : "exam",
                neutralQ : "Was Henry stressed?",
                supportiveQ : "Did Henry study?",
                neutral : "Henry was stressed because he had a major...",
                supportive : "Henry stayed up all night studying for his...",
              },
              "LongShort 30" : {
                choice2 : "identification",
                choice1 : "ID",
                neutralQ : "Was Mary told she didn't need to bring anything?",
                supportiveQ : "Does Mary look old for her age?",
                neutral : "Several days ago, Mary was told to bring her...",
                supportive : "Mary looks young, so the bartender asked her for...",
              },
              "LongShort 31" : {
                choice2 : "mayonnaise",
                choice1 : "mayo",
                neutralQ : "Did Chris go shopping yesterday?",
                supportiveQ : "Did Chris order a sandwich?",
                neutral : "Yesterday Chris went the store and bought...",
                supportive : "Chris ordered a sandwich with mustard instead of...",
              },
              "LongShort 32" : {
                choice2 : "Coca-Cola",
                choice1 : "Coke",
                neutralQ : "Did Clarence order water?",
                supportiveQ : "Does Clarence prefer soda to water?",
                neutral : "At the restaurant we went to, Clarence ordered...",
                supportive : "Clarence would rather drink water than Pepsi or...",
              },
              "LongShort 33" : {
                choice2 : "milkshake",
                choice1 : "shake",
                neutralQ : "Does Joey like Snickers best?",
                supportiveQ : "Did the ice cream store's blender work well?",
                neutral : "His friends all know that there is nothing Joey loves more than a...",
                supportive : "The ice cream store's blender broke, so they could not make Joey a...",
              },
              "LongShort 34" : {
                choice2 : "veterinarian",
                choice1 : "vet",
                neutralQ : "Is Karen training to work with animals?",
                supportiveQ : "Does Karen have a dog?",
                neutral : "Just as she planned, Karen is training to be a...",
                supportive : "When her dog got sick, Karen took it to the...",
              },
              "LongShort 35" : {
                choice2 : "hamburger",
                choice1 : "burger",
                neutralQ : "Did Stan eat only hot dogs last night?",
                supportiveQ : "Does Stan think Wendy's has the best burgers?",
                neutral : "Last night, Stan bought himself a...",
                supportive : "Stan thinks McDonald's makes the best...",
              },
              "LongShort 36" : {
                choice2 : "quadriceps",
                choice1 : "quads",
                neutralQ : "Was Jack known for his big biceps?",
                supportiveQ : "Did Jack do only arm exercises?",
                neutral : "Jack was known for having very large...",
                supportive : "Jack did leg exercises to strengthen his...",
              },
              "LongShort 37" : {
                choice2 : "quadrangle",
                choice1 : "quad",
                neutralQ : "Did Joseph spend a lot of time indoors yesterday?",
                supportiveQ : "Do the students go to the cafeteria to get fresh air?",
                neutral : "Yesterday, before he went home, Joseph spent a lot of time in the...",
                supportive : "To get some fresh air, the students like to spend time in the...",
              },
              "LongShort 38" : {
                choice2 : "emergency room",
                choice1 : "ER",
                neutralQ : "Does Ben have a wife?",
                supportiveQ : "Did Ben have a car accident?",
                neutral : "Neither Ben nor his wife have ever had to go to the...",
                supportive : "After the car accident, Ben was taken in an ambulance to the...",
              },
              "LongShort 39" : {
                choice2 : "United States",
                choice1 : "U.S.",
                neutralQ : "Did John receive a package?",
                supportiveQ : "Does John now live in France?",
                neutral : "When he opened the box, John was surprised to learn he had received a package from the...",
                supportive : "Although John now lives in France, he still considers himself American because he was born in the...",
              },
              "LongShort 4" : {
                choice2 : "dormitory",
                choice1 : "dorm",
                neutralQ : "Did Dan leave Jason's office?",
                supportiveQ : "Did Jason want to keep living on campus?",
                neutral : "After leaving Dan's office, Jason did not want to go to the...",
                supportive : "Jason moved off campus because he was tired of living in a...",
              },
              "LongShort 40" : {
                choice2 : "United Nations",
                choice1 : "U.N.",
                neutralQ : "Is Don hoping to do something?",
                supportiveQ : "Is Switzerland a neutral country?",
                neutral : "If he has free time, Don is still hoping to get to visit the...",
                supportive : "Because it is a neutral country, Switzerland will never become a member of the...",
              },
              "LongShort 5" : {
                choice2 : "memorandum",
                choice1 : "memo",
                neutralQ : "Did the boss find something?",
                supportiveQ : "Did the boss send something to everyone in the office?",
                neutral : "While he was going through a stack of papers, the boss found a...",
                supportive : "To clarify the new policy, the boss sent everyone in the office a...",
              },
              "LongShort 6" : {
                choice2 : "photograph",
                choice1 : "photo",
                neutralQ : "Does Paul think something would be useful?",
                supportiveQ : "Did Paul know what Mary looked like before meeting her?",
                neutral : "Paul thinks that what would be really useful in that particular situation is a...",
                supportive : "Paul knew what Mary looked like before meeting her because he had seen a...",
              },
              "LongShort 7" : {
                choice2 : "fraternity",
                choice1 : "frat",
                neutralQ : "Did Jim try to avoid something?",
                supportiveQ : "Did Jim want to go to parties?",
                neutral : "When coming home from work, Jim did everything he possibly could to avoid walking by the...",
                supportive : "Jim wanted to go to the wildest parties on campus, so he went to the biggest...",
              },
              "LongShort 8" : {
                choice2 : "refrigerator",
                choice1 : "fridge",
                neutralQ : "Did Mary ask for help moving the piano?",
                supportiveQ : "Did Mary get just juice from the fridge?",
                neutral : "Mary asked Bill to help her move the...",
                supportive : "Mary got some chocolate milk out of the...",
              },
              "LongShort 9" : {
                choice2 : "hippopotamus",
                choice1 : "hippo",
                neutralQ : "Does John love his picture book?",
                supportiveQ : "Did John take pictures at the zoo?",
                neutral : "John loves his picture book, especially the page with the...",
                supportive : "At the zoo, John took a picture of a fat...",
              },
              "filler 1" : {
                context : "John walked outside to talk to his...",
                choice2 : "friend",
                choice1 : "neighbor",
                comp_q : "Did John stay inside?",
              },
              "filler 10" : {
                context : "Tired, Bill took a four-hour...",
                choice2 : "snooze",
                choice1 : "nap",
                comp_q : "Did Bill sleep?",
              },
              "filler 11" : {
                context : "At John's company, they created...",
                choice2 : "tables",
                choice1 : "armchairs",
                comp_q : "Does the company make CDs?",
              },
              "filler 12" : {
                context : "Next week, Susan will vacation in...",
                choice2 : "California",
                choice1 : "Mexico",
                comp_q : "Will Susan will be in Mexico next week?",
              },
              "filler 13" : {
                context : "Afraid of many-legged creatures, Bill couldn't kill the...",
                choice2 : "centipede",
                choice1 : "spider",
                comp_q : "Did Bill kill the spider?",
              },
              "filler 14" : {
                context : "Someone broke in and stole Mary's...",
                choice2 : "PC",
                choice1 : "computer",
                comp_q : "Was Mary's computer stolen?",
              },
              "filler 15" : {
                context : "John's dog barked at every cat on the...",
                choice2 : "road",
                choice1 : "street",
                comp_q : "Did John have a dog?",
              },
              "filler 16" : {
                context : "Bill carefully washed the...",
                choice2 : "house",
                choice1 : "car",
                comp_q : "Did Bill wash the dishes?",
              },
              "filler 17" : {
                context : "Confused, Susan asked him for an...",
                choice2 : "clarification",
                choice1 : "explanation",
                comp_q : "Did Susan understand at first?",
              },
              "filler 18" : {
                context : "Mary can't wait to see her...",
                choice2 : "bro",
                choice1 : "brother",
                comp_q : "Does Mary have a brother?",
              },
              "filler 19" : {
                context : "Susan altered the length of her...",
                choice2 : "skirt",
                choice1 : "dress",
                comp_q : "Did Susan alter her pants?",
              },
              "filler 2" : {
                context : "Mary washed the dishes with the...",
                choice2 : "soap",
                choice1 : "detergent",
                comp_q : "Did Mary wash the dishes?",
              },
              "filler 20" : {
                context : "John laughed at the...",
                choice2 : "jester",
                choice1 : "clown",
                comp_q : "Did John laugh?",
              },
              "filler 21" : {
                context : "After he twisted his ankle, Bill hopped on one...",
                choice2 : "foot",
                choice1 : "leg",
                comp_q : "Did Bill break his arm?",
              },
              "filler 22" : {
                context : "After losing the election, John went to the...",
                choice2 : "school",
                choice1 : "park",
                comp_q : "Did John lose the election?",
              },
              "filler 23" : {
                context : "As an Italian, Kevin enjoys eating...",
                choice2 : "pasta",
                choice1 : "pizza",
                comp_q : "Is Kevin Italian?",
              },
              "filler 24" : {
                context : "Never at a loss for words, Tom gave a long...",
                choice2 : "recital",
                choice1 : "speech",
                comp_q : "Is Tom a quiet person?",
              },
              "filler 25" : {
                context : "Roger wanted his son to play...",
                choice2 : "golf",
                choice1 : "tennis",
                comp_q : "Does Roger have a son?",
              },
              "filler 26" : {
                context : "Sam was hungry even after eating...",
                choice2 : "turkey",
                choice1 : "chicken",
                comp_q : "Was Sam still hungry after eating?",
              },
              "filler 27" : {
                context : "Marge was angry that her son broke the...",
                choice2 : "table",
                choice1 : "lamp",
                comp_q : "Was Marge angry?",
              },
              "filler 28" : {
                context : "Ken doesn't know how to use a computer so has never been on the...",
                choice2 : "Internet",
                choice1 : "web",
                comp_q : "Does Ken use a computer?",
              },
              "filler 29" : {
                context : "Lori is known for being a good...",
                choice2 : "chef",
                choice1 : "cook",
                comp_q : "Does Lori make food?",
              },
              "filler 3" : {
                context : "Yesterday Susan went to the...",
                choice2 : "physician",
                choice1 : "doctor",
                comp_q : "Did Susan stay home yesterday?",
              },
              "filler 30" : {
                context : "Lester, who is from Indiana, has never been to....",
                choice2 : "Maine",
                choice1 : "India",
                comp_q : "Is Lester from Arizona?",
              },
              "filler 31" : {
                context : "Sean, who likes to cook, bought a special...",
                choice2 : "potato",
                choice1 : "tomato",
                comp_q : "Does Sean hate cooking?",
              },
              "filler 32" : {
                context : "Mike's aunt loves drawing pictures of...",
                choice2 : "bears",
                choice1 : "fish",
                comp_q : "Does Mike's aunt draw?",
              },
              "filler 33" : {
                context : "Denver, a city in Colorado, is known for its...",
                choice2 : "lakes",
                choice1 : "mountains",
                comp_q : "Is Denver in Utah?",
              },
              "filler 34" : {
                context : "Birds can make good pets but require a lot of...",
                choice2 : "water",
                choice1 : "food",
                comp_q : "Can birds make good pets?",
              },
              "filler 35" : {
                context : "Strangely, Leo climbed the mountain without any...",
                choice2 : "boots",
                choice1 : "shoes",
                comp_q : "Did Leo climb a mountain?",
              },
              "filler 36" : {
                context : "The red bottle that Adam dropped was made of...",
                choice2 : "plastic",
                choice1 : "glass",
                comp_q : "Did Greg drop the red bottle?",
              },
              "filler 37" : {
                context : "Nine artists were gathered at the...",
                choice2 : "meeting",
                choice1 : "convention",
                comp_q : "Were there thirteen artists gathered?",
              },
              "filler 38" : {
                context : "The farmer, who never left his farm, grew a big...",
                choice2 : "turnip",
                choice1 : "radish",
                comp_q : "Did the farmer spend a lot of time at his farm?",
              },
              "filler 39" : {
                context : "Hugo fled from the hurricane, that was approaching his...",
                choice2 : "town",
                choice1 : "city",
                comp_q : "Did Hugo flee a hurricane?",
              },
              "filler 4" : {
                context : "After many years, Paul ran into an old...",
                choice2 : "pal",
                choice1 : "classmate",
                comp_q : "Did Paul see someone?",
              },
              "filler 40" : {
                context : "Astronauts have been to the moon but never...",
                choice2 : "Jupiter",
                choice1 : "Mars",
                comp_q : "Have astronauts been to the moon?",
              },
              "filler 5" : {
                context : "Bill's aunt went to the mall to buy...",
                choice2 : "socks",
                choice1 : "shoes",
                comp_q : "Did Bill's aunt go home?",
              },
              "filler 6" : {
                context : "Susan kept a jewelry box full of...",
                choice2 : "diamonds",
                choice1 : "rings",
                comp_q : "Did Susan have a jewelry box?",
              },
              "filler 7" : {
                context : "Mary saw the neighbor's...",
                choice2 : "dog",
                choice1 : "car",
                comp_q : "Did Mary have neighbor?",
              },
              "filler 8" : {
                context : "John didn't get to see the new...",
                choice2 : "film",
                choice1 : "movie",
                comp_q : "Did John see the new movie?",
              },
              "filler 9" : {
                context : "Just yesterday, Mary found out about the...",
                choice2 : "affair",
                choice1 : "scandal",
                comp_q : "Did Mary know about the scandal all along?",
              },
  };

  slides.critical = slide({
    name : "critical",

    /* trial information for this block
     (the variable 'stim' will change between each of these values,
      and for each of these, present_handle will be run.) */
    present : _.shuffle(Array(40).fill().map((_,i) => 'LongShort ' + (i+1)).concat(Array(40).fill().map((_,i) => 'filler ' + (i+1)))),

    //this gets run only at the beginning of the block
    present_handle : function(stim_item) {
      $(".err").hide();

      // uncheck the button and erase the previous value
      exp.criticalResponse1 == null;
      exp.criticalResponse2 == null;
      $('input[name=criticalChoice1]:checked').prop('checked', false);
      $('input[name=criticalChoice2]:checked').prop('checked', false);
      if (stim_item.startsWith("LongShort ")) {
        var supportive = _.sample(['supp', 'neut'])
        if (supportive == 'supp') {
          var context = dict[stim_item].supportive
          var comp_q = dict[stim_item].supportiveQ
        } else {
          var context = dict[stim_item].neutral
          var comp_q = dict[stim_item].neutralQ
        }
        var whichfirst = _.sample(['shortfirst', 'longfirst'])
        if (whichfirst == 'shortfirst') {
          var choice1 = dict[stim_item].choice1
          var choice2 = dict[stim_item].choice2
        } else {
          var choice1 = dict[stim_item].choice2
          var choice2 = dict[stim_item].choice1
        }
        stim = stim_item + ' ' + supportive + '_' + whichfirst
        // $("#stim").html(stim);
        $("#criticalSentence").html(context);
        $("#option1").html(choice1);
        $("#option2").html(choice2);
        $("#criticalQuestion").html(comp_q);
      } else {
        // $("#stim").html(stim_item);
        $("#criticalSentence").html(dict[stim_item].context);
        $("#option1").html(dict[stim_item].choice1);
        $("#option2").html(dict[stim_item].choice2);
        $("#criticalQuestion").html(dict[stim_item].comp_q);
      }

      this.stim = stim; //you can store this information in the slide so you can record it later.

    },

    button : function() {
      //find out the checked option
      exp.criticalResponse1 = $('input[name=criticalChoice1]:checked').val();
      exp.criticalResponse2 = $('input[name=criticalChoice2]:checked').val();

      // verify the response
      if (exp.criticalResponse1 == null || exp.criticalResponse2 == null) { //or exp.criticalResponse2 == null) {
        $(".err").show();
      } else {
        this.log_responses();

        /* use _stream.apply(this); if and only if there is
        "present" data. (and only *after* responses are logged) */
        _stream.apply(this);
      }
    },

    log_responses : function() {
      exp.data_trials.push({
        "trial_type" : "critical",
        "sentence": this.stim, // don't forget to log the stimulus
        "response1" : exp.criticalResponse1,
        "response2" : exp.criticalResponse2 
      });
    }
  });

  slides.subj_info =  slide({
    name : "subj_info",
    submit : function(e){
      //if (e.preventDefault) e.preventDefault(); // I don't know what this means.
      exp.subj_data = {
        language : $("#language").val(),
        enjoyment : $("#enjoyment").val(),
        asses : $('input[name="assess"]:checked').val(),
        age : $("#age").val(),
        gender : $("#gender").val(),
        education : $("#education").val(),
        comments : $("#comments").val(),
        problems: $("#problems").val(),
        fairprice: $("#fairprice").val()
      };
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });

  slides.thanks = slide({
    name : "thanks",
    start : function() {
      exp.data= {
          "trials" : exp.data_trials,
          "catch_trials" : exp.catch_trials,
          "system" : exp.system,
          // "condition" : exp.condition,
          "subject_information" : exp.subj_data,
          "time_in_minutes" : (Date.now() - exp.startT)/60000
      };
      setTimeout(function() {turk.submit(exp.data);}, 1000);
    }
  });

  return slides;
}

/// init ///
function init() {
  //specify conditions
  // exp.condition = _.sample(["comparatives", "multiple negations"]); //can randomize between subject conditions here
  //blocks of the experiment:
  exp.structure=["i0", "consent", "example", "instructions", "critical", 'subj_info', 'thanks'];

  // generally no need to change anything below
  exp.trials = [];
  exp.catch_trials = [];
  exp.data_trials = [];
  exp.system = {
      Browser : BrowserDetect.browser,
      OS : BrowserDetect.OS,
      screenH: screen.height,
      screenUH: exp.height,
      screenW: screen.width,
      screenUW: exp.width
    };

  //make corresponding slides:
  exp.slides = make_slides(exp);

  exp.nQs = utils.get_exp_length(); //this does not work if there are stacks of stims (but does work for an experiment with this structure)
                    //relies on structure and slides being defined

  $('.slide').hide(); //hide everything

  //make sure turkers have accepted HIT (or you're not in mturk)
  $("#start_button").click(function() {
    if (turk.previewMode) {
      $("#mustaccept").show();
    } else {
      $("#start_button").click(function() {$("#mustaccept").show();});
      exp.go();
    }
  });

  exp.go(); //show first slide
}
