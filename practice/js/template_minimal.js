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
                  supportive : "Bob was very bad at algebra, so he hated...",
                  supportiveQ : "Is Bob bad at algebra?",
                  neutral : "Bob introduced himself to me as someone who loved...",
                  neutralQ : "Did Bob introduce himself to me?",
                  choice1 : "math",
                  choice2 : "mathematics",
                }, 
                "filler 1" : {
                  context : "John walked outside to talk to his...",
                  comp_q : "Did John stay inside?",
                  choice1 : "neighbor", 
                  choice2 : "friend",
                },
  };

  slides.critical = slide({
    name : "critical",

    /* trial information for this block
     (the variable 'stim' will change between each of these values,
      and for each of these, present_handle will be run.) */
    present : _.shuffle(Array(1).fill().map((_,i) => 'LongShort ' + (i+1)).concat(Array(1).fill().map((_,i) => 'filler ' + (i+1)))),

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
        stim = stim_item + ' ' + supportive + '_' + whichfirst
        $("#criticalSentence").html(context);
        $("#criticalQuestion").html(comp_q);
      } else {
        $("#criticalSentence").html(dict[stim_item].context);
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
  exp.structure=["i0", "consent", "instructions", "example", "critical", 'subj_info', 'thanks'];

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
