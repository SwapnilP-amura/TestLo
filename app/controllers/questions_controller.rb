class QuestionsController < ApplicationController
    before_action :check_user

    def new
        @test = Test.find(params[:test_id])
        @question = Question.new
    end

    def index
        @questions = Question.all
    end

    def create
        # should logged and should be employer
        @question = current_user.questions.build(question_params)
        @test = Test.find(params[:test_id])
        if @question.save
            flash[:success] = 'Question added to Bank successfully'
            redirect_to test_path(@test)
        else
            @question.a = @question.options[0]
            @question.b = @question.options[1]
            @question.c = @question.options[2]
            @question.d = @question.options[3]
            render 'new'
        end
    end

    def destroy
        @question = Question.find(params[:id])
        if @question.destroy
            flash[:success] = 'Question Removed from Question bank'
            redirect_to test_path(id: params[:test_id])
        end
    end

    def show
        @question = Question.find(params[:id])
    end

    private

    def question_params
        # passing options and correct answers as arrays
        p params.require(:question).permit(:category_id, :question_type, :question, options: [], correct_answer: [])
    end

    def check_user
        unless current_user.type == 'Employer'
            flash[:danger] = 'Authorizaion Error'
            redirect_to error_path
        end
    end
end
