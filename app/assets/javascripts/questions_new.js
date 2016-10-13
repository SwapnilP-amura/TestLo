$(document).ready(function() {

    switch ($('.qtype :input:checked').val()) {
        case '0':
            integer();
            break;

        case '1':
            single_correct();
            break;

        case '2':
            multiple_correct();
            break;
    }

    toggleForm();

});

function hello() {

    var person = prompt("Please enter your name" + this, "Harry Potter");

    $.ajax('/add_question_to_current_test/50/36?marks=3')
}

function freez() {
    $('#correct_answer :hidden :input').each(function(index) {
        $(this).prop('disabled', true);
    });

    $('#correct_answer :visible :input').each(function(index) {
        $(this).prop('disabled', false);
    });
}

function toggleForm() {

    $('#correct_answers_0').hide();
    $('#question_question_type_0').change(integer);
    $('#question_question_type_1').change(single_correct);
    $('#question_question_type_2').change(multiple_correct);
}

function integer() {
    $('#options').hide();
    $('#correct_answers_0').show();
    $('#correct_answers_1').hide();
    $('#correct_answers_2').hide();
    freez();
}

function single_correct() {
    $('#options').show();
    $('#correct_answers_0').hide();
    $('#correct_answers_1').show();
    $('#correct_answers_2').hide();
    freez();
}

function multiple_correct() {
    $('#options').show();
    $('#correct_answers_0').hide();
    $('#correct_answers_1').hide();
    $('#correct_answers_2').show();
    freez();
}
