class QuestionsController < ApplicationController
  #before_action :array_to_string,only:[:create]
  #to check params are valid depending on
  def new
    @question=Question.new
  end

  def index
    #@questions=Question.all
  end

  def create
    #options=params[:question][:temp_options].join('#####')
    #@user=Question.new(question_params)
    @question=Question.new(question_params)
    render plain: params
    # if @question.save
    #   flash[:success]="Question added to Bank successfully"
    #   redirect_to questions_path
    # else
    #   render 'new'
    # end

  end

  private

  def question_params
    p params.require(:question).permit(:category_id,:question_type,:question,:correct_answer,options:[])
  end

  # def array_to_string
  #   if params[:question][:correct_answer].is_a?Array
  #     params[:question][:correct_answer]=params[:question][:correct_answer].join('#####')
  #   end
  #   params[:question][:options]=params[:question][:temp_options].join('#####')
  # end
end
