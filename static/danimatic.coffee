
loadSoundManager = ->
  soundManager.setup(
    url: '/'
    preferFlash: false
    onready: ->
      console.log("ready")
  )

fixture =
  audio: 'fixture/audio.mp3'
  frames: [
    [1200, 'fixture/a.png'],
    [900, 'fixture/b.png'],
    [1000, 'fixture/c.png'],
    [2500, 'fixture/d.png'],
  ]


# Implements enough of the SoundManager sound object API that we can use SM and
# its callbacks to manage the timing of frames even if we don't have a real sound.

class Player
  constructor: ->
    @position = 0
    @frames = fixture.frames
    @frameIndex = 0
    @playing = false
    @duration = @calculateDuration()

    @tickDuration = 10

    @bindEm()

    @setFrame()

  calculateDuration: ->
    @frames.reduce ((prev, curr) -> prev + curr[0]), 0

  bindEm: ->
    $('.play-pause').on 'click', (e)=>
      e.preventDefault()
      e.stopPropagation()
      @playPause()

  setFrame: ->
    $('#player img').attr('src', @frames[@frameIndex][1])

  tick: =>
    console.log 'tick'
    @position += @tickDuration
    if @position > @duration
      @stop()
    @updateFrame()
    @updateChrome()

  updateFrame: ->
    i = 0
    timeCount = 0
    for frame in @frames
      console.error i, timeCount
      if timeCount >= @position
        @frameIndex = i
        break
      timeCount += @frames[i][0]
      i += 1

    @setFrame()

  updateChrome: ->
    $('.johnny-counts-a-lot').text(@position)

  playPause: ->
    if @playing
      @pause()
    else
      @play()

  play: ->
    @playing = true
    @interval = setInterval(@tick, @tickDuration, this)

  pause: ->
    clearInterval(@interval)
    @playing = false

  stop: ->
    clearInterval(@interval)


$(document).ready ->
  loadSoundManager()
  window.animaticPlayer = new Player()
