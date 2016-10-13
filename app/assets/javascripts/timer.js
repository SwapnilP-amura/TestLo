$(document).ready(function() {

    var myVar = setInterval(myTimer, 1000);
});

function myTimer() {
    var total_time = $('div .timer :first-child').html();
    total_time = parseInt(total_time);

    var start_time = $('div .timer :last-child').html();
    start_time = parseInt(start_time);

    var now = new Date();

    var current_time = now.getHours() * 60 * 60 + now.getMinutes() * 60 + now.getSeconds()
    var secs = total_time - (current_time - start_time)

    $('.countdown :first-child').html(convert(secs));
}


function convert(totalSec) {
    if (totalSec == 0) {
        timeUP();
    }
    var hours = parseInt(totalSec / 3600) % 24;
    var minutes = parseInt(totalSec / 60) % 60;
    var seconds = totalSec % 60;

    var result = (hours < 10 ? "0" + hours : hours) + ":" + (minutes < 10 ? "0" + minutes : minutes) + ":" + (seconds < 10 ? "0" + seconds : seconds);
    return result;
}


function timeUP() {
    $.ajax({
        type: "GET",
        url: document.URL + "/finish.js",
        success: function(data) {
            alert('Time up');
        },

        error: function(data) {
            alert('failed');
        }
    });
}
