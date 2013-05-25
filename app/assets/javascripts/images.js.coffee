# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# References:
# http://arstechnica.com/business/2012/01/hands-on-building-an-html5-photo-booth-with-chromes-new-webcam-api/
# http://stackoverflow.com/questions/4998908/convert-data-uri-to-file-then-append-to-formdata
# http://www.scottpreston.com/articles/1442.php

# This converts dataURI in a image file (blob). This way we can append to FormData.
window.dataURItoBlob = (dataURI) ->
  binary = atob(dataURI.split(',')[1])
  array = []
  for i in [0..binary.length]
      array.push(binary.charCodeAt(i))
  return new Blob([new Uint8Array(array)], {type: 'image/jpeg'})

window.uploadFile = (file) ->
  formData = new FormData()
  formData.append("image[cover_image]", file)
    
  jQuery.ajax
    url: '/images'
    type: "POST"
    data: formData
    dataType: "json"
    cache: false
    contentType: false
    processData: false
    async: false
    wait: true
  .done (data, textStatus, jqXHR) ->
    # Do whatever you want when "ok"
    ;
  .fail (jqXHR, textStatus, errorThrown) ->
    # Do whatever you want when "fail"
    ;

window.snap = () ->
  live = document.getElementById("live")
  snapshot = document.getElementById("snapshot")
  thumbs = document.getElementById("thumbs")

  # Make the canvas the same size as the live video
  snapshot.width = live.clientWidth
  snapshot.height = live.clientHeight

  # Draw a frame of the live video onto the canvas
  c = snapshot.getContext("2d")
  c.drawImage(live, 0, 0, snapshot.width, snapshot.height)

  # Create an image element with the canvas image data
  img = document.createElement("img")
  img.src = snapshot.toDataURL("image/png")
  img.style.padding = 5
  img.width = snapshot.width / 2
  img.height = snapshot.height / 2

  # Add the new image to the film roll
  thumbs.appendChild(img)
  uploadFile(dataURItoBlob(img.src))
  
$(document).ready ->

  window.navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia
  window.URL = window.URL || window.webkitURL
  
  video = document.getElementById("live")
  
  navigator.getUserMedia({video:true},
    (stream) ->
      video.src = window.URL.createObjectURL(stream)
    (err) ->
      console.log("Unable to get video stream!")
  )
