# Description:
#   Give Hubot fuzzy-searchable memories.
#
# Commands:
#   hubot (how do i|what do you know)? - List the memories Hubot has.
#   hubot (how do i|what is) <hint>? - Search for an answer.
#   hubot learn[ how to] <memory> is <details> - Teach Hubot how to do a thing.
#   hubot forget[ how to] <memory> - Purge one of Hubot's memories.

FuzzySet = require 'fuzzyset.js'

class FuzzyBrain
  constructor: (@brainKey = 'FuzzyBrain') ->

  init: (robotBrain) ->
    @strictBrain = robotBrain.data[@brainKey] ?= {}
    return this

  learn: (memory, answer) ->
    if @recall memory then false else @strictBrain[memory] = answer

  dump: ->
    @strictBrain

  list: ->
    Object.keys @dump()

  recall: (memory) ->
    @dump()[memory]

  forget: (memory) ->
    delete @dump()[memory]

  guess: (description) ->
    fuzzy = new FuzzySet @list()
    return unless guesses = fuzzy.get description

    [score, knownMemoryName] = guesses.sort (a, b) ->
      a.score - b.score
    .pop()

    {score, knownMemoryName, answer: @recall knownMemoryName}

  @communicate: ({answer, score}) ->
    qualifier = switch
      when score > .9 then null
      when score > .5 then "It's probably"
      when score > .2 then "I'm not sure, but maybe it's"
      else "This is a complete shot in the dark"

    if qualifier then "#{qualifier}: #{answer}" else answer


module.exports = (robot) ->
  fuzzyBrain = new FuzzyBrain

  robot.brain.on 'loaded', ->
    fuzzyBrain.init robot.brain

  robot.respond /(?:how do i|what do you know)\??$/, (msg) ->
    memories = fuzzyBrain.list()
    msg.reply if memories.length
      """
        I know how to:
        #{memories.join '\n'}
      """
    else
      "I don't know how to do anything yet :(  Please teach me something."

  robot.respond /(how do i|what is) (.+)/i, (msg) ->
    question = msg.match[1]
    hint = msg.match[2].replace /\?+/, ''
    return msg.reply "I don't know how to do that, yet" unless guess = fuzzyBrain.guess hint

    response = FuzzyBrain.communicate guess
    if guess.score < .9
      description = switch question
        when 'how do i' then 'how to'
        when 'what is' then 'what is'

      response = """
        I think you want to know #{description}: #{guess.knownMemoryName}
        #{response}
      """

    msg.reply response

  robot.respond /learn (?:how to )?(.+) is (.+)/i, (msg) ->
    [memory, answer] = msg.match[1..2]

    msg.reply unless fuzzyBrain.learn(memory, answer) is off
      "Learned #{memory}"
    else
      "I already know how to do that, you should tell me to forget it first if there's a better way"

  robot.respond /(?:unlearn|forget) (?:how to )?(.+)/i, (msg) ->
    memory = msg.match[1]
    fuzzyBrain.forget memory
    msg.reply "Okay, I unlearned #{memory}"


module.exports.FuzzyBrain = FuzzyBrain
