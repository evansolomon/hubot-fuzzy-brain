{FuzzyBrain} = require '../'

should = require 'should'

makeFuzzyBrain = (key) ->
  new FuzzyBrain key

initFuzzyBrain = (key) ->
  fuzz = new FuzzyBrain key
  fuzz.init makeStrictBrain()

makeStrictBrain = ->
  {data: {}}

describe 'Fuzzy Brain', ->
  it 'Should define a brain key', ->
    makeFuzzyBrain().brainKey.should.eql 'FuzzyBrain'
    (makeFuzzyBrain 'FuzzyWuzzy').brainKey.should.eql 'FuzzyWuzzy'

  it 'Should initialize a strict brain', ->
    fuzz = makeFuzzyBrain()
    fuzz.init makeStrictBrain()
    Object.keys(fuzz.strictBrain).length.should.eql 0

  it 'Should store things in its strict brain', ->
    fuzz = initFuzzyBrain()
    fuzz.learn 'Chewbacca', 'Wookiee from Kashyyyk'
    fuzz.recall('Chewbacca').should.eql 'Wookiee from Kashyyyk'

  it 'Should not overwrite memories', ->
    fuzz = initFuzzyBrain()
    fuzz.learn 'Cousin Itt', 'Felix Silla'

    fuzz.learn('Cousin Itt', 'Roger Arroyo').should.not.be.ok
    fuzz.recall('Cousin Itt').should.eql 'Felix Silla'

  it 'Should list its memories', ->
    fuzz = initFuzzyBrain()

    fuzz.learn 'Mogwai', 'Do not feed after midnight'
    fuzz.learn 'Gizmo', 'But he is so cute'

    fuzz.list().should.include('Mogwai').and.include('Gizmo')

  it 'Should guess what you mean', ->
    fuzz = initFuzzyBrain()
    fuzz.learn 'peach', 'Princess Toadstool'

    fuzz.guess('pch').knownMemoryName.should.eql 'peach'
    fuzz.guess('pch').answer.should.eql 'Princess Toadstool'

  it 'Should explain its guesses', ->
    FuzzyBrain.communicate
      score: .5
      answer: 'Fuzzies first appear in Super Mario World'
    .should.endWith ': Fuzzies first appear in Super Mario World'

  it 'Should know when it is correct', ->
    FuzzyBrain.communicate
      score: 1
      answer: 'cannot be defeated'
    .should.eql 'cannot be defeated'

