$(document).ready(function() {

minPic = 0;
$("#number .picNo").html(minPic+1);

maxPic = $(".imageHolder").length;
$("#number .picTotal").html(maxPic);

button=1;
$.each($(".imageHolder"), function() {
$('#buttons p').append("<b>"+button+"</b>");
button++;
});

$.each($(".imageHolder img"), function() {
$src=$(this).attr("alt");
$(this).attr("src", $src)
});

var thumbs = $("#buttons b");
var img = $(".imageHolder img");
var txt = $(".imageText div");

$src=img.eq(minPic).attr("alt");
img.eq(minPic).attr("src", $src)
img.eq(minPic).css("left", "0px");
txt.eq(minPic).css("top", "0px");
setColor()

thumbs.click(function() {
current = ($(this).index())
if (current > minPic) {
resetColor()
hideLeftTop()
minPic = current;
setColor()
showRightBottom()
}
if (current < minPic) {
resetColor()
hideRightBottom()
minPic = current;
setColor()
showLeftTop()
}
});

$("#previous").click(function() {
resetColor()
hideRightBottom()
minPic--;
if (minPic < 0) {minPic = maxPic-1}
setColor()
showLeftTop()
});

$("#next").click(function() {
resetColor()
hideLeftTop()
minPic++;
if (minPic == maxPic) {minPic = 0}
setColor()
showRightBottom()
});

function setColor() {
thumbs.eq(minPic).addClass("current");
}

function resetColor() {
thumbs.eq(minPic).removeClass("current");
}

function hideLeftTop() {
img.eq(minPic).animate({"left": "-500px"}, 400, "swing");
txt.eq(minPic).animate({"top": "-200px"}, 400, "swing");
}

function hideRightBottom() {
img.eq(minPic).animate({"left": "500px"}, 400, "swing");
txt.eq(minPic).animate({"top": "200px"}, 400, "swing");
}

function showLeftTop() {
img.eq(minPic).css("left","-500px");
txt.eq(minPic).css("top", "-200px");
img.eq(minPic).animate({"left": "0px"}, 400, "swing");
txt.eq(minPic).animate({"top": "0px"}, 400, "swing");
$("#number .picNo").html(minPic+1);
}

function showRightBottom() {
img.eq(minPic).css("left", "500px");
txt.eq(minPic).css("top", "200px");
img.eq(minPic).animate({"left": "0px"}, 400, "swing");
txt.eq(minPic).animate({"top": "0px"}, 400, "swing");
$("#number .picNo").html(minPic+1);
}

});
