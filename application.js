var CaptionsModel,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

CaptionsModel = (function(_super) {
  __extends(CaptionsModel, _super);

  function CaptionsModel() {
    this.saveToLocalStorage = __bind(this.saveToLocalStorage, this);
    return CaptionsModel.__super__.constructor.apply(this, arguments);
  }

  CaptionsModel.prototype.initialize = function(model, options) {
    this.video = options.video;
    return this.on('change', this.saveToLocalStorage);
  };

  CaptionsModel.prototype.saveToLocalStorage = function() {
    return localStorage[this.video] = JSON.stringify(this.toJSON());
  };

  return CaptionsModel;

})(Backbone.Model);

var CaptionView,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

CaptionView = (function(_super) {
  __extends(CaptionView, _super);

  function CaptionView() {
    this["delete"] = __bind(this["delete"], this);
    this.resetCaption = __bind(this.resetCaption, this);
    this.saveCaption = __bind(this.saveCaption, this);
    this.onBlur = __bind(this.onBlur, this);
    this.onKeyDownTextarea = __bind(this.onKeyDownTextarea, this);
    return CaptionView.__super__.constructor.apply(this, arguments);
  }

  CaptionView.prototype.el = 'textarea';

  CaptionView.prototype.duration = 2;

  CaptionView.prototype.ENTER = 13;

  CaptionView.prototype.ESC = 27;

  CaptionView.prototype.done = false;

  CaptionView.prototype.events = {
    'keydown': 'onKeyDownTextarea',
    'blur': 'onBlur'
  };

  CaptionView.prototype.initialize = function(options) {
    if (options == null) {
      options = {};
    }
    this.model = options.model;
    this.player = options.player;
    this.parentView = options.parentView;
    this.startTime = options.startTime;
    this.initialState = this.player.getPlayerState();
    this.backupCaption = this.model.get(this.startTime);
    this.$el.data('current-view', this.cid);
    return this.listenTo(this.parentView, 'change:currentTime', this.onTimeChange);
  };

  CaptionView.prototype.render = function() {
    return this.$el.val(this.model.get("" + this.startTime));
  };

  CaptionView.prototype.onTimeChange = function(currentTime) {
    this.currentTime = currentTime;
    if (currentTime >= this.startTime + this.duration) {
      this.leave();
    }
    if (currentTime < this.startTime) {
      return this.leave();
    }
  };

  CaptionView.prototype.onKeyDownTextarea = function(e) {
    if (e.keyCode === this.ENTER) {
      e.preventDefault();
      this.$el.blur();
      return false;
    }
    if (e.keyCode === this.ESC) {
      e.preventDefault();
      this._preventWrite = true;
      this.$el.blur();
      delete this._preventWrite;
      return false;
    }
  };

  CaptionView.prototype.onBlur = function() {
    if (this._preventWrite) {
      this.resetCaption();
    } else {
      this.saveCaption();
    }
    if (this.player.getPlayerState() !== YT.PlayerState.PLAYING) {
      return this.player.playVideo();
    }
  };

  CaptionView.prototype.saveCaption = function() {
    var val;
    if ((val = this.$el.val()) !== '') {
      return this.model.set("" + this.startTime, val);
    }
  };

  CaptionView.prototype.resetCaption = function() {
    if (this.backupCaption != null) {
      return this.$el.val(this.backupCaption);
    }
  };

  CaptionView.prototype["delete"] = function() {
    this.model.unset("" + this.startTime);
    return this.leave();
  };

  CaptionView.prototype.leave = function() {
    this.undelegateEvents();
    this.stopListening(this.parentView);
    if (this.$el.data('current-view') === this.cid) {
      this.$el.val('');
      this.$el.blur();
    }
    return this.done = true;
  };

  return CaptionView;

})(Backbone.View);

var PlayerView,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

PlayerView = (function(_super) {
  __extends(PlayerView, _super);

  function PlayerView() {
    this.onTimeChange = __bind(this.onTimeChange, this);
    this.onKeyDownHTML = __bind(this.onKeyDownHTML, this);
    this.getCurrentTime = __bind(this.getCurrentTime, this);
    this.roundToThirdSecond = __bind(this.roundToThirdSecond, this);
    this.roundToHalfSecond = __bind(this.roundToHalfSecond, this);
    this.onPlayerReady = __bind(this.onPlayerReady, this);
    this.setupYoutube = __bind(this.setupYoutube, this);
    this.mockupPlayer = __bind(this.mockupPlayer, this);
    this.playerVars = __bind(this.playerVars, this);
    return PlayerView.__super__.constructor.apply(this, arguments);
  }

  PlayerView.prototype.currentTime = -1;

  PlayerView.prototype.video = 'JsdAwdhd0Aw';

  PlayerView.prototype.youtubeURL = 'https://www.youtube.com/watch?v=';

  PlayerView.prototype.el = 'body';

  PlayerView.prototype.events = {
    'click .close': 'onCloseClick',
    'focus textarea': 'onFocusTextarea',
    'blur textarea': 'onBlurTextarea',
    'mouseenter textarea': 'onmouseenter',
    'mouseleave textarea': 'onmouseleave',
    'mouseenter .centererer': 'onmouseenter',
    'mouseleave .centererer': 'onmouseleave',
    'submit form': 'onFormSubmit'
  };

  PlayerView.prototype.playerVars = function() {
    var start;
    start = this.video === 'JsdAwdhd0Aw' ? 2 : 0;
    return {
      controls: 1,
      iv_load_policy: 3,
      autoplay: 1,
      autohide: 1,
      modestbranding: 1,
      rel: 0,
      showinfo: 0,
      start: start
    };
  };

  PlayerView.prototype.initialize = function() {
    if (this.getQueryString().v == null) {
      return this.redirectToVideo();
    }
    $('html').on('keydown', this.onKeyDownHTML);
    this.on('change:currentTime', this.onTimeChange);
    this.initVideo();
    return window.onYouTubeIframeAPIReady = this.setupYoutube;
  };

  PlayerView.prototype.initVideo = function() {
    this.getVideoIdFromLocation();
    this.preloadCaps();
    return this.model = new CaptionsModel(this.getSavedCaps(), {
      video: this.video
    });
  };

  PlayerView.prototype.getVideoIdFromLocation = function() {
    return this.video = this.getQueryString().v;
  };

  PlayerView.prototype.getVideoIdFromInput = function() {
    var split;
    split = this.$('input').val().match(/.*v=(\w*)\W*/, '');
    if (split != null) {
      return this.video = split[1];
    }
  };

  PlayerView.prototype.getSavedCaps = function() {
    var savedCaptions;
    return savedCaptions = localStorage[this.video] != null ? JSON.parse(localStorage[this.video]) : {};
  };

  PlayerView.prototype.preloadCaps = function() {
    if ((this[this.video] != null) && (localStorage[this.video] == null)) {
      return localStorage[this.video] = JSON.stringify(this[this.video]);
    }
  };

  PlayerView.prototype.mockupPlayer = function() {
    this.player = {
      count: -1,
      state: 1,
      getCurrentTime: function() {
        if (this.state === 1) {
          this.count += 1;
        }
        return this.count * 0.5;
      },
      getPlayerState: function() {
        return this.state;
      },
      pauseVideo: function() {
        return this.state = 0;
      },
      playVideo: function() {
        return this.state = 1;
      }
    };
    window.YT = {
      PlayerState: {
        PAUSE: 0,
        PLAYING: 1
      }
    };
    return setInterval(this.getCurrentTime, 500);
  };

  PlayerView.prototype.width = "640";

  PlayerView.prototype.height = "390";

  PlayerView.prototype.setupYoutube = function() {
    this.player = new YT.Player("player", {
      height: this.height,
      width: this.width,
      videoId: this.video,
      playerVars: this.playerVars()
    });
    return this.player.addEventListener('onReady', this.onPlayerReady);
  };

  PlayerView.prototype.onPlayerReady = function(event) {
    this.player.setPlaybackQuality('large');
    return this._intervalId = setInterval(this.getCurrentTime, 250);
  };

  PlayerView.prototype.roundToHalfSecond = function(input) {
    return this.roundToFractionOfSecond(input, 2);
  };

  PlayerView.prototype.roundToThirdSecond = function(input) {
    var output;
    output = this.roundToFractionOfSecond(input, 3);
    if (output % 1 > 0.9) {
      output = Math.ceil(output);
    }
    return output;
  };

  PlayerView.prototype.roundToFractionOfSecond = function(input, timesPerSecond) {
    var cutoff, fractionOfSecond, i, output, remainder, _i, _ref;
    if (timesPerSecond == null) {
      timesPerSecond = 2;
    }
    output = Math.floor(input);
    remainder = Math.ceil((input % 1) * 100) / 100;
    fractionOfSecond = (Math.floor((1 / timesPerSecond) * 100)) / 100;
    for (i = _i = 0, _ref = timesPerSecond - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
      cutoff = (i * fractionOfSecond) + (fractionOfSecond / 2);
      cutoff = (Math.floor(cutoff * 1000)) / 1000;
      if (remainder >= cutoff) {
        output += fractionOfSecond;
      }
    }
    return output;
  };

  PlayerView.prototype.getCurrentTime = function() {
    var playerTime, roundTime, _oldTime;
    playerTime = this.player.getCurrentTime();
    roundTime = this.roundToThirdSecond(playerTime);
    console.log(roundTime);
    if (this.currentTime !== roundTime) {
      _oldTime = this.currentTime;
      this.currentTime = roundTime;
      return this.trigger('change:currentTime', this.currentTime, _oldTime);
    }
  };

  PlayerView.prototype.onKeyDownHTML = function(e) {
    if (e.target.tagName !== 'BODY') {
      return;
    }
    this.createCaptionsView();
    this.$('textarea').focus();
    this.$el.addClass('reveal');
    return this.player.pauseVideo();
  };

  PlayerView.prototype.onFocusTextarea = function() {
    this.createCaptionsView();
    this.player.pauseVideo();
    return this.$el.addClass('reveal');
  };

  PlayerView.prototype.onBlurTextarea = function() {
    return setTimeout((function(_this) {
      return function() {
        return _this.$el.removeClass('reveal');
      };
    })(this), 50);
  };

  PlayerView.prototype.onCloseClick = function() {
    var _ref;
    return (_ref = this.captionsView) != null ? _ref["delete"]() : void 0;
  };

  PlayerView.prototype.createCaptionsView = function() {
    if ((this.captionsView == null) || this.captionsView.done) {
      this.captionsView = new CaptionView({
        parentView: this,
        model: this.model,
        player: this.player,
        startTime: this.currentTime
      });
    }
    return this.captionsView;
  };

  PlayerView.prototype.onTimeChange = function(current, old) {
    var _ref;
    if (this.model.get(current)) {
      if ((_ref = this.captionsView) != null) {
        _ref.leave();
      }
      return this.createCaptionsView().render();
    }
  };

  PlayerView.prototype.onmouseenter = function() {
    if (this.player.getPlayerState() === 5) {
      return;
    }
    clearTimeout(this._revealTimer);
    return this.$el.addClass('reveal');
  };

  PlayerView.prototype.onmouseleave = function() {
    if (this.$('textarea').is(":focus")) {
      return;
    }
    return this._revealTimer = setTimeout((function(_this) {
      return function() {
        return _this.$el.removeClass('reveal');
      };
    })(this), 50);
  };

  PlayerView.prototype.onFormSubmit = function(e) {
    e.preventDefault();
    this.getVideoIdFromInput();
    return this.redirectToVideo();
  };

  PlayerView.prototype.JsdAwdhd0Aw = {
    "11": "smells ok...",
    "20": "c'mon I can take ya",
    "5.33": "holy crap",
    "7.66": "what's that?",
    "14": "ERMAHGERD!!",
    "17.66": "stay still!",
    "22.66": "don't you get any closer",
    "25.33": "nope",
    "28.33": "skat",
    "30.33": "(note the studio lighting...)",
    "3.99": "doo doo doo",
    "35.33": "outta here junior",
    "44": "what's that thing again?",
    "46.66": "ERMAGHERD!!",
    "53.33": "[exit stage left]"
  };

  PlayerView.prototype.getQueryString = function() {
    var m, queryString, re, result;
    result = {};
    queryString = location.search.slice(1);
    re = /([^&=]+)=([^&]*)/g;
    m = void 0;
    while (m = re.exec(queryString)) {
      result[decodeURIComponent(m[1])] = decodeURIComponent(m[2]);
    }
    return result;
  };

  PlayerView.prototype.redirectToVideo = function(video) {
    if (video == null) {
      video = this.video;
    }
    return location.href = "" + location.origin + location.pathname + "?v=" + video;
  };

  return PlayerView;

})(Backbone.View);

var player;

player = new PlayerView();
